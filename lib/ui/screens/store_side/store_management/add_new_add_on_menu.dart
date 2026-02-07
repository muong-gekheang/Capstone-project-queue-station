import 'package:flutter/material.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/old_model/menu.dart';
import 'package:queue_station_app/old_model/menu_category.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/add_ons_management.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';

class AddNewAddOnMenu extends StatefulWidget {
  const AddNewAddOnMenu({super.key});

  @override
  State<AddNewAddOnMenu> createState() => _AddNewAddOnMenuState();
}

class _AddNewAddOnMenuState extends State<AddNewAddOnMenu> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _minTimeController = TextEditingController();
  final TextEditingController _maxTimeController = TextEditingController();
  MenuCategory selectedCategory = mockMenuCategories.firstWhere(
    (c) => c.categoryName.toLowerCase().contains('Add-Ons'.toLowerCase()),
  );

  String? _nullValidtor(String? value) {
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
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String description = _descriptionController.text;
      String price = _priceController.text;
      String minTime = _minTimeController.text;
      String maxTime = _maxTimeController.text;

      print('All fields are valid!');

      Menu newMenu = Menu(
        name: name,
        description: description,
        price: double.tryParse(price)!,
        isAvailable: true,
        categoryId: selectedCategory.categoryId!,
        minPreparationTime: int.tryParse(minTime)!,
        maxPreparationTime: int.tryParse(maxTime)!,
      );

      Navigator.pop(context, newMenu);
    } else {
      print('Please fix the errors in the form');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Add Menu Item", color: Colors.black),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 15,
          vertical: 25,
        ),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldWidget(
                    title: 'Name',
                    hintText: 'e.g. Item name',
                    color: Color.fromRGBO(13, 71, 161, 0.5),
                    validator: _nullValidtor,
                    textController: _nameController,
                  ),
                  SizedBox(height: 10),
                  TextFieldWidget(
                    title: 'Description',
                    hintText: 'Add details customers should know ',
                    color: Color.fromRGBO(13, 71, 161, 0.5),
                    validator: _descriptionValidator,
                    textController: _descriptionController,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldWidget(
                          title: 'Price',
                          hintText: '9.9',
                          prefixText: '\$',
                          color: Color.fromRGBO(13, 71, 161, 0.5),
                          validator: _nullValidtor,
                          textController: _priceController,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<MenuCategory>(
                              initialValue: selectedCategory,
                              items: [
                                DropdownMenuItem(
                                  value: selectedCategory,
                                  child: Text(selectedCategory.categoryName),
                                ),
                              ],
                              onChanged: null,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0.5,
                                    color: Color.fromRGBO(13, 71, 161, 0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(13, 71, 161, 0.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFieldWidget(
                    title: 'Min preparation time',
                    color: Color.fromRGBO(13, 71, 161, 0.5),
                    validator: _preparationTimeValidator,
                    textController: _minTimeController,
                  ),
                  SizedBox(height: 10),
                  TextFieldWidget(
                    title: 'Max preparation time',
                    color: Color.fromRGBO(13, 71, 161, 0.5),
                    validator: _preparationTimeValidator,
                    textController: _maxTimeController,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          title: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.white,
                          textColor: Color.fromRGBO(13, 71, 161, 1),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 5,
                          ),
                        ),
                        ButtonWidget(
                          title: 'Save',
                          onPressed: onSave,
                          backgroundColor: Color.fromRGBO(255, 104, 53, 1),
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
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
      ),
    );
  }
}
