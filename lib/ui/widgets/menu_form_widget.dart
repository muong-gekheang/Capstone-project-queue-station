import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/add_new_category.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/add_ons_management.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/add_size_management.dart';
import 'package:queue_station_app/ui/widgets/add_on_tile_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/menu_size_tile_widget.dart';
import 'package:queue_station_app/ui/widgets/profile_editor_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';
import 'package:uuid/uuid.dart';

class MenuForm extends StatefulWidget {
  final MenuItem? initialMenu; // null = Add, not null = Edit
  final void Function(MenuItem menu) onSubmit;

  const MenuForm({super.key, this.initialMenu, required this.onSubmit});

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();
  late final TextEditingController _priceController = TextEditingController();
  late TextEditingController _minTimeController = TextEditingController();
  late TextEditingController _maxTimeController = TextEditingController();

  late String? selectedImageFile;
  List<MenuSize> menuSizes = [];
  List<AddOn> addOns = [];
  List<int> addOnIds = [];
  MenuItemCategory? selectedCategory;
  final addCategory = MenuItemCategory(id: "-1", name: ' + Add New');

  // Controllers for SizesPriceList
  final Map<MenuSize, TextEditingController> menuSizeController = {};
  final Map<AddOn, TextEditingController> addOnController = {};

  @override
  void initState() {
    super.initState();
    final menu = widget.initialMenu;

    _nameController.text = menu?.name ?? '';
    _descriptionController.text = menu?.description ?? '';
    _minTimeController = TextEditingController(
      text: menu?.minPrepTimeMinutes.toString() ?? '',
    );
    _maxTimeController = TextEditingController(
      text: menu?.maxPrepTimeMinutes.toString() ?? '',
    );

    if (menu != null) {
      selectedCategory = mockMenuCategories.firstWhere(
        (c) => c.id == menu.category.id,
        orElse: () => mockMenuCategories.isNotEmpty
            ? mockMenuCategories.first
            : MenuItemCategory(id: Uuid().v4(), name: 'Unknown'),
      );
    } else {
      selectedCategory = mockMenuCategories.isNotEmpty
          ? mockMenuCategories.first
          : MenuItemCategory(id: Uuid().v4(), name: 'Unknown');
    }

    if (menu?.image != null && menu!.image!.isNotEmpty) {
      selectedImageFile = menu.image;
    } else {
      selectedImageFile = null;
    }

    menuSizes = menu?.sizes.toList() ?? [];
    addOns = menu?.addOns ?? [];
  }

  String? _nullValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return 'this field cannot be null';
    } else {
      return null;
    }
  }

  String? _descriptionValidator(String? value) {
    if (value != null && value.length > 200) {
      return 'The description should be less than 200';
    } else {
      return null;
    }
  }

  String? _preparationTimeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final int? minutes = int.tryParse(value);
    if (minutes == null) {
      return 'preparation time must be a number';
    }
    if (minutes < 0 || minutes > 60) {
      return 'preparation must be in the range of 0 and 60';
    }

    return null;
  }

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix the errors in the form")),
      );
      return;
    }

    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();
    // final double? parsedPrice = double.tryParse(_priceController.text.trim());
    final int minPrep = int.tryParse(_minTimeController.text.trim()) ?? 0;
    final int maxPrep = int.tryParse(_maxTimeController.text.trim()) ?? 0;

    if (selectedCategory == null || selectedCategory!.id == "-1") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid category")),
      );
      return;
    }

    if (minPrep > maxPrep) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Min preparation time cannot be greater than max time"),
        ),
      );
      return; // prevent saving
    }

    // Update menuSizes price from controllers
    for (var menuSize in menuSizes) {
      final controller = menuSizeController[menuSize];
      if (controller != null) {
        final price = double.tryParse(controller.text);
        if (price != null) {
          menuSize.price = price;
        }
      }
    }

    for (var add in addOns) {
      final controller = addOnController[add];
      if (controller != null) {
        final price = double.tryParse(controller.text);
        if (price != null) {
          add.price = price;
        }
      }
    }


    final MenuItem newMenu = MenuItem(
      id: Uuid().v4(),
      name: name,
      description: description,
      category: selectedCategory!,
      minPrepTimeMinutes: minPrep,
      maxPrepTimeMinutes: maxPrep,
      sizes: menuSizes,
      addOns: addOns,
    );

    Navigator.pop(context, newMenu);
  }

  Future<void> onEdit() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImageFile = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileEditorWidget(onEdit: onEdit, imagePath: selectedImageFile),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  title: 'Name',
                  hintText: 'e.g. Item name',
                  color: Theme.of(context).colorScheme.secondary.withAlpha(127),
                  validator: _nullValidator,
                  textController: _nameController,
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  title: 'Description',
                  hintText: 'Add details customers should know ',
                  color: Theme.of(context).colorScheme.secondary.withAlpha(127),
                  validator: _descriptionValidator,
                  textController: _descriptionController,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Expanded(
                    //   child: TextFieldWidget(
                    //     title: 'Price',
                    //     hintText: '9.9',
                    //     prefixText: '\$',
                    //     color: Theme.of(
                    //       context,
                    //     ).colorScheme.secondary.withAlpha(127),
                    //     validator: _nullValidator,
                    //     textController: _priceController,
                    //   ),
                    // ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<MenuItemCategory>(
                            initialValue: selectedCategory,
                            items: [
                              DropdownMenuItem(
                                value: addCategory,
                                child: const Text("+ Add"),
                              ),
                              ...mockMenuCategories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }),
                            ],
                            onChanged: (value) async {
                              if (value == null) return;
                              if (value.id == '-1') {
                                final newCategory =
                                    await showModalBottomSheet<
                                      MenuItemCategory
                                    >(
                                      context: context,
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(
                                            context,
                                          ).viewInsets.bottom,
                                        ),
                                        child: AddNewCategory(),
                                      ),
                                    );
                                if (newCategory != null) {
                                  mockMenuCategories.add(newCategory);
                                  setState(() {
                                    selectedCategory = newCategory;
                                  });
                                }
                              } else {
                                setState(() {
                                  selectedCategory = value;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withAlpha(127),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withAlpha(127),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  title: 'Min preparation time',
                  color: Theme.of(context).colorScheme.secondary.withAlpha(127),
                  validator: _preparationTimeValidator,
                  textController: _minTimeController,
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  title: 'Max preparation time',
                  color: Theme.of(context).colorScheme.secondary.withAlpha(127),
                  validator: _preparationTimeValidator,
                  textController: _maxTimeController,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sizes',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                MenuSizeTileWidget<MenuSize>(
                  items: menuSizes,
                  controllers: menuSizeController,
                  getName: (item) => item.sizeOption.name,
                  getPrice: (item) => item.price,
                  onPriceChanged: (item, newPrice) {
                    setState(() {
                      item.price = newPrice;
                    });
                  },
                  onDelete: (item) {
                    setState(() {
                      menuSizes.remove(item);
                      menuSizeController.remove(item);
                    });
                  },
                ),

                SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    leadingIcon: Icons.add,
                    title: 'Add Size',
                    onPressed: () async {
                      final returnedMenuSizes =
                          await showModalBottomSheet<List<SizeOption>>(
                            context: context,
                            builder: (context) {
                              return AddSizeScreen(
                                existingMenu: widget.initialMenu,
                              );
                            },
                          );
                  
                      if (returnedMenuSizes != null &&
                          returnedMenuSizes.isNotEmpty) {
                        setState(() {
                          // Convert MenuSizeOption -> MenuSize with default price 0
                          menuSizes.addAll(
                            returnedMenuSizes.map(
                              (e) => MenuSize(sizeOption: e, price: 0),
                            ),
                          );
                        });
                      }
                    },
                    backgroundColor: AppTheme.secondaryColor.withAlpha(127),
                    textColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 5,
                    ),
                    borderRadius: 5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Add-Ons',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                AddOnTileWidget(
                  addOns: addOns,
                  onDelete: (addOn) {
                    setState(() {
                      addOns.remove(addOn);
                    });
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    leadingIcon: Icons.add,
                    title: 'Add Add-Ons',
                    onPressed: () async {
                      final List<AddOn>? newAddOns =
                          await showModalBottomSheet<List<AddOn>>(
                            context: context,
                            builder: (BuildContext context) {
                              return AddOnsManagement(
                                existingMenu: widget.initialMenu,
                              );
                            },
                          );
                  
                      if (newAddOns != null) {
                        setState(() {
                          for (AddOn addOn in newAddOns) {
                            addOns.add(addOn);
                          }
                        });
                      }
                    },
                    backgroundColor: AppTheme.secondaryColor.withAlpha(127),
                    textColor: AppTheme.secondaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    borderRadius: 5,
                  ),
                ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWidget(
                        title: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: AppTheme.naturalWhite,
                        textColor: AppTheme.secondaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 5,
                        ),
                      ),
                      ButtonWidget(
                        title: 'Save',
                        onPressed: onSave,
                        backgroundColor: AppTheme.primaryColor,
                        textColor: AppTheme.naturalWhite,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
