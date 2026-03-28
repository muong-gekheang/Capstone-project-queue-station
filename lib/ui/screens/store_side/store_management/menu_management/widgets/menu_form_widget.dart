import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/view_model/menu_management_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/add_new_category.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/add_ons_management.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/add_size_management.dart';
import 'package:queue_station_app/ui/widgets/add_on_tile_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/menu_size_tile_widget.dart';
import 'package:queue_station_app/ui/widgets/profile_editor_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';
import 'package:uuid/uuid.dart';

class MenuForm extends StatefulWidget {
  final MenuItem? initialMenu; // null = Add, not null = Edit
  final void Function(MenuItem menu, Uint8List? pickedLogoBytes) onSubmit;

  const MenuForm({super.key, this.initialMenu, required this.onSubmit});

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();
  late TextEditingController _minTimeController = TextEditingController();
  late TextEditingController _maxTimeController = TextEditingController();

  late String? selectedImageFile;

  final addCategory = MenuItemCategory(id: "-1", name: ' + Add New');

  // Controllers for SizesPriceList
  final Map<MenuSize, TextEditingController> menuSizeController = {};
  final Map<AddOn, TextEditingController> addOnController = {};

  MenuItemCategory? selectedCategory;
  List<AddOn> selectedAddOns = [];
  List<MenuSize> availableMenuSizes = [];
  Uint8List? pickedLogoBytes;

  @override
  void initState() {
    var vm = context.read<MenuManagementViewModel>();
    final menu = widget.initialMenu;

    selectedAddOns.addAll(widget.initialMenu?.addOns ?? []);

    availableMenuSizes.addAll(widget.initialMenu?.sizes ?? []);

    // in here we have 3 fallbacks
    // 1. try initialMenu.category
    // 2. if it fails, try vm.selectedCategory
    // 3. if it fails, choose the first category
    selectedCategory =
        widget.initialMenu?.category ??
        vm.selectedCategory ??
        (vm.allCategories.isNotEmpty ? vm.allCategories.first : null);
    _nameController.text = menu?.name ?? '';
    _descriptionController.text = menu?.description ?? '';
    _minTimeController = TextEditingController(
      text: menu?.minPrepTimeMinutes.toString() ?? '',
    );
    _maxTimeController = TextEditingController(
      text: menu?.maxPrepTimeMinutes.toString() ?? '',
    );

    if (menu?.image != null && menu!.image!.isNotEmpty) {
      selectedImageFile = menu.image;
    } else {
      selectedImageFile = null;
    }
    super.initState();
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

  void onPickImage() async {
    final ImagePicker picker = ImagePicker();
    Uint8List? selectedImageBytes;

    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage == null) return;

    selectedImageBytes = await pickedImage.readAsBytes();
    setState(() {
      pickedLogoBytes = selectedImageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<MenuManagementViewModel>();
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileEditorWidget(
            image: pickedLogoBytes != null
                ? MemoryImage(pickedLogoBytes!)
                : (selectedImageFile != null && selectedImageFile!.isNotEmpty)
                ? NetworkImage(selectedImageFile!) as ImageProvider
                : null,
            onPickImage: onPickImage,
          ),
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
                          (vm.allCategories.isNotEmpty &&
                                  selectedCategory != null)
                              ? DropdownButtonFormField<MenuItemCategory>(
                                  initialValue: selectedCategory,
                                  items: [
                                    DropdownMenuItem(
                                      value: addCategory,
                                      child: const Text("+ Add"),
                                    ),
                                    ...vm.allCategories.map((category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(category.name),
                                      );
                                    }),
                                  ],
                                  onChanged: (value) async {
                                    if (value == null) return;
                                    if (value.id == '-1') {
                                      final result =
                                          await showModalBottomSheet<
                                            (MenuItemCategory, Uint8List?)
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
                                      if (result != null) {
                                        final newCategory = result.$1;
                                        final selectedImageBytes = result.$2;

                                        vm.addNewCategory(
                                          newCategory,
                                          selectedImageBytes,
                                        );
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
                                )
                              : Column(
                                  spacing: 10,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Add at least 1 category",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                    ),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        ...vm.allCategories.map(
                                          (e) => Chip(label: Text(e.name)),
                                        ),
                                        ButtonWidget(
                                          title: '+ Add Category',
                                          onPressed: () async {
                                            final result =
                                                await showModalBottomSheet<
                                                  (MenuItemCategory, Uint8List?)
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
                                            if (result != null) {
                                              final newCategory = result.$1;
                                              final selectedImageBytes =
                                                  result.$2;

                                              try {
                                                vm.addNewCategory(
                                                  newCategory,
                                                  selectedImageBytes,
                                                );
                                                setState(() {
                                                  selectedCategory =
                                                      newCategory;
                                                });
                                              } catch (err) {
                                                debugPrint("$err");
                                              }
                                            }
                                          },
                                          backgroundColor: Color.fromRGBO(
                                            255,
                                            104,
                                            53,
                                            1,
                                          ),
                                          textColor: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          borderRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ],
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
                  items: availableMenuSizes,
                  controllers: menuSizeController,
                  getName: (item) => item.sizeOption!.name,
                  getPrice: (item) => item.price,
                  onPriceChanged: (item, newPrice) {
                    setState(() {
                      item.price = newPrice;
                    });
                  },
                  onDelete: (item) {
                    setState(() {
                      availableMenuSizes.remove(item);
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
                          await showModalBottomSheet<List<MenuSize>>(
                            context: context,
                            builder: (context) {
                              return ChangeNotifierProvider.value(
                                value: vm,
                                child: AddSizeScreen(
                                  selectedMenuSizes: availableMenuSizes,
                                ),
                              );
                            },
                          );

                      if (returnedMenuSizes != null &&
                          returnedMenuSizes.isNotEmpty) {
                        setState(() {
                          // 1. Create a Set of sizeOptions  for lightning-fast lookup
                          final existingSizeOptions = availableMenuSizes
                              .map((s) => s.sizeOption)
                              .toSet();

                          final newSizeOptions = returnedMenuSizes
                              .map((e) => e.sizeOption)
                              .toSet();

                          // 2. Create add and delete list
                          final toAddSizeOptions = newSizeOptions.difference(
                            existingSizeOptions,
                          );

                          final toRemoveSizeOption = existingSizeOptions
                              .difference(newSizeOptions);

                          // 3. Update the MenuSize list

                          availableMenuSizes.addAll(
                            returnedMenuSizes.where(
                              (e) => toAddSizeOptions.contains(e.sizeOption),
                            ),
                          );

                          availableMenuSizes.removeWhere(
                            (e) => toRemoveSizeOption.contains(e.sizeOption),
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
                  addOns: selectedAddOns,
                  onDelete: (addOn) {
                    setState(() {
                      selectedAddOns.remove(addOn);
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
                              return ChangeNotifierProvider.value(
                                value: vm,
                                child: AddOnsManagement(
                                  selectedAddOns: selectedAddOns,
                                ),
                              );
                            },
                          );

                      if (newAddOns != null) {
                        setState(() {
                          selectedAddOns = newAddOns;
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
                        onPressed:
                            (selectedCategory != null &&
                                availableMenuSizes.isNotEmpty)
                            ? () => widget.onSubmit(
                                MenuItem(
                                  id: widget.initialMenu?.id ?? Uuid().v4(),
                                  addOnIds: selectedAddOns
                                      .map((e) => e.id)
                                      .toList(),
                                  sizes: availableMenuSizes,
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  categoryId: selectedCategory!.id,
                                  minPrepTimeMinutes: int.tryParse(
                                    _minTimeController.text,
                                  ),
                                  maxPrepTimeMinutes: int.tryParse(
                                    _maxTimeController.text,
                                  ),
                                  restaurantId: '',
                                  minPrice: _getMinPrice(availableMenuSizes),
                                ),
                                pickedLogoBytes,
                              )
                            : null,
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

double _getMinPrice(List<MenuSize> availableSizes) {
  double result = availableSizes[0].price;
  for (var menuSize in availableSizes) {
    if (menuSize.price < result) {
      result = menuSize.price;
    }
  }
  return result;
}
