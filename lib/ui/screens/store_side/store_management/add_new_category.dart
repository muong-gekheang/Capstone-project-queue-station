import 'package:flutter/material.dart';
import 'package:queue_station_app/old_model/menu_category.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';

class AddNewCategory extends StatefulWidget {
  const AddNewCategory({super.key});

  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();

  String? _nullValidtor(String? value) {
    if (value != null && value.trim().isEmpty) {
      return 'this field cannot be null';
    } else {
      return null;
    }
  }

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final categoryName = _categoryNameController.text;
    final newCategory = MenuCategory(categoryName: categoryName);

    Navigator.pop(context, newCategory);
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
