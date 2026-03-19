import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/profile_editor_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';
import 'package:uuid/uuid.dart';

class AddNewAddOnMenu extends StatefulWidget {
  const AddNewAddOnMenu({super.key});

  @override
  State<AddNewAddOnMenu> createState() => _AddNewAddOnMenuState();
}

class _AddNewAddOnMenuState extends State<AddNewAddOnMenu> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImage;
  Uint8List? pickedLogoBytes;
  // MenuItemCategory _selectedCategory = mockMenuCategories.firstWhere(
  //   (c) => c.name.toLowerCase().contains('Add-Ons'.toLowerCase()),
  // );

  String? _nullvalidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return 'this field cannot be null';
    } else {
      return null;
    }
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

  void onSave() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      double parsedPrice = double.tryParse(_priceController.text)!;
      print('All fields are valid!');

      AddOn newAddOn = AddOn(
        id: Uuid().v4(),
        name: name,
        price: parsedPrice,
        image: _selectedImage,
        restaurantId: '',
      );

      Navigator.pop(context, newAddOn);
    } else {
      print('Please fix the errors in the form');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Add New Add-On", color: Colors.black),
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
                  Container(
                    alignment: Alignment.center,
                    child: ProfileEditorWidget(
                      image: pickedLogoBytes != null
                          ? MemoryImage(pickedLogoBytes!)
                          : null,
                      onPickImage: onPickImage,
                    ),
                  ),
                  TextFieldWidget(
                    title: 'Name',
                    hintText: 'e.g. Item name',
                    color: Color.fromRGBO(13, 71, 161, 0.5),
                    validator: _nullvalidator,
                    textController: _nameController,
                  ),
                  SizedBox(height: 10),
                  TextFieldWidget(
                    title: 'Price',
                    hintText: 'price',
                    prefixText: '\$',
                    color: Color.fromRGBO(13, 71, 161, 0.5),
                    validator: _nullvalidator,
                    textController: _priceController,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          title: 'Cancel',
                          borderColor: AppTheme.secondaryColor,
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
