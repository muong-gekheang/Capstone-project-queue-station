import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/profile_editor_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';
import 'package:uuid/uuid.dart';

class AddNewCategory extends StatefulWidget {
  const AddNewCategory({super.key});

  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();
  Uint8List? pickedLogoBytes;
  String? _nullValidtor(String? value) {
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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final categoryName = _categoryNameController.text;
    final newCategory = MenuItemCategory(id: Uuid().v4(), name: categoryName);

    Navigator.pop(context, (newCategory, pickedLogoBytes));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Add New Category",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ProfileEditorWidget(
            image: pickedLogoBytes != null
                ? MemoryImage(pickedLogoBytes!)
                : null,
            onPickImage: onPickImage,
          ),
          Form(
            key: _formKey,
            child: TextFieldWidget(
              title: 'Category Name',
              hintText: 'e.g. Soup',
              color: Color.fromRGBO(13, 71, 161, 0.5),
              validator: _nullValidtor,
              textController: _categoryNameController,
            ),
          ),
          SizedBox(height: 10),
          ButtonWidget(
            title: 'Save',
            onPressed: onSave,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
        ],
      ),
    );
  }
}
