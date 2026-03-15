import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart'; // for globalSizeOptions
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class AddSizeScreen extends StatefulWidget {
  final MenuItem? existingMenu;
  const AddSizeScreen({super.key, this.existingMenu});

  @override
  State<AddSizeScreen> createState() => _AddSizeScreenState();
}

class _AddSizeScreenState extends State<AddSizeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<SizeOption> selectedSizes = [];

  @override
  void initState() {
    super.initState();
    selectedSizes =
        widget.existingMenu?.sizes
            .map((menuSize) => menuSize.sizeOption)
            .toList() ??
        [];
  }

  String? _nullValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return 'this field cannot be null';
    }
    return null;
  }

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields correctly"),
        ),
      );
      return;
    }
    final sizeName = _sizeController.text.trim();

    SizeOption? existingSize;
    try {
      existingSize = globalSizeOptions.firstWhere(
        (s) => s.name.toLowerCase() == sizeName.toLowerCase(),
      );
    } catch (e) {
      existingSize = null;
    }

    existingSize ??= SizeOption(id: _uuid.v4(), name: sizeName);

    Navigator.pop(context, existingSize);
  }

  Widget existingSize() {
    // Use globalSizeOptions for existing sizes
    if (globalSizeOptions.isEmpty) {
      return const Center(child: Text("This menu has no size yet"));
    }

    return ListView.builder(
      itemCount: globalSizeOptions.length,
      itemBuilder: (context, index) {
        final globalMenuSize = globalSizeOptions[index];
        final isSelected = selectedSizes.contains(globalMenuSize);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedSizes.add(globalMenuSize);
                    } else {
                      selectedSizes.remove(globalMenuSize);
                    }
                  });
                },
              ),
              Expanded(
                child: Text(
                  globalMenuSize.name,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool get isAddDisabled {
    if (widget.existingMenu?.sizes == null) return false;

    final nonSelected = selectedSizes.isEmpty;

    final existingMenuSizes =
        widget.existingMenu?.sizes
            .map((existingSize) => existingSize.sizeOption.name.toLowerCase())
            .toList() ??
        [];

    final hasDuplicate = selectedSizes.any(
      (size) => existingMenuSizes.contains(size.name.toLowerCase()),
    );

    final allSelected = existingMenuSizes.every(
      (existingSizeName) => selectedSizes.any(
        (size) => size.name.toLowerCase() == existingSizeName,
      ),
    );

    return nonSelected || hasDuplicate || allSelected;
  }

  void onAdd() {
    Navigator.pop(context, selectedSizes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Existing Size",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(child: existingSize()),
          const SizedBox(height: 10),
          ButtonWidget(
            title: 'Add',
            onPressed: isAddDisabled ? null : onAdd,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          const SizedBox(height: 10),
          ExpansionTile(
            title: Text(
              'Add new size',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            collapsedBackgroundColor: Theme.of(
              context,
            ).colorScheme.secondary.withAlpha(127),
            childrenPadding: const EdgeInsets.all(12),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                      title: 'Size',
                      hintText: 'e.g. L',
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(127),
                      validator: _nullValidator,
                      textController: _sizeController,
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      title: 'Save',
                      onPressed: onSave,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 5,
                      ),
                      borderRadius: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
