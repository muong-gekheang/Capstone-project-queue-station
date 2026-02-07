import 'package:flutter/material.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/model//menu.dart';
import 'package:queue_station_app/model//menu_size.dart';
import 'package:queue_station_app/model//size.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';

class AddSizeScreen extends StatefulWidget {
  final Menu? existingMenu;
  const AddSizeScreen({super.key, this.existingMenu});

  @override
  State<AddSizeScreen> createState() => _AddSizeScreenState();
}

class _AddSizeScreenState extends State<AddSizeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<MenuSizeOption> selectedSizes = [];

  String? _nullValidtor(String? value) {
    if (value != null && value.trim().isEmpty) {
      return 'this field cannot be null';
    } else {
      return null;
    }
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
    final price = _priceController.text.trim();
    final double? parsedPrice = double.tryParse(price);

    if (parsedPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid numbers")),
      );
      return;
    }

    MenuSizeOption? existingSize;
    try {
      existingSize = globalSizes.firstWhere(
        (s) => s.name.toLowerCase() == sizeName.toLowerCase(),
      );
    } catch (e) {
      existingSize = null;
    }

    if (existingSize == null) {
      existingSize = MenuSizeOption(id: globalSizes.length + 1, name: sizeName);
      globalSizes.add(existingSize);
    }

    final menuSizesToAdd = MenuSize(size: existingSize, price: parsedPrice);

    Navigator.pop(context, menuSizesToAdd);
  }

  Widget existingSize() {
    final globalMenuSizes = globalSizes;

    if (globalMenuSizes.isEmpty) {
      return Center(child: Text("This menu has no size yet"));
    }

    return ListView.builder(
      itemCount: globalMenuSizes.length,
      itemBuilder: (context, index) {
        final globalMenuSize = globalSizes[index];
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
                }, // checkbox also triggers parent
              ),
              Expanded(
                child: Text(
                  globalMenuSize.name,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onAdd() {
    // Just return the selected sizes (MenuSizeOption)
    Navigator.pop(context, selectedSizes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Existing Size",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(child: existingSize()),
          SizedBox(height: 10),
          ButtonWidget(
            title: 'Add',
            onPressed: onAdd,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          SizedBox(height: 10),
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
                      validator: _nullValidtor,
                      textController: _sizeController,
                    ),
                    SizedBox(height: 10),

                    ButtonWidget(
                      title: 'Save',
                      onPressed: onSave,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.surface,
                      padding: EdgeInsets.symmetric(
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
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
