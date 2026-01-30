import 'package:flutter/material.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/domain/menu.dart';
import 'package:queue_station_app/domain/menu_category.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';

class EditMenuScreen extends StatefulWidget {
  final Menu existingMenu;
  const EditMenuScreen({super.key, required this.existingMenu});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _minTimeController;
  late TextEditingController _maxTimeController;
  // late int? selectedCategoryId;




  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingMenu.name);
    _descriptionController = TextEditingController(text: widget.existingMenu.description);
    _priceController = TextEditingController(text: widget.existingMenu.price.toString());
    _minTimeController = TextEditingController(text: widget.existingMenu.minPreparationTime.toString());
    _maxTimeController = TextEditingController(text: widget.existingMenu.maxPreparationTime.toString());
    // selectedCategoryId = widget.existingMenu.categoryId;
  }

  String? _nullValidtor(String? value){
    if(value != null && value.trim().isEmpty){
      return 'this field cannot be null';
    }
    else{
      return null;
    }
  }

  String? _descriptionValidator(String? value){
    if(value != null && value.length > 200){
      return 'The description should be less than 200';
    }
    else{
      return null;
    }
  }

  String? _preparationTimeValidator(String? value){
    if(value == null || value.trim().isEmpty){
      return null;
    }
    final int? minutes = int.tryParse(value);
    if(minutes == null){
      return 'preparation time must be a number';
    }
    if(minutes < 0 || minutes > 60){
      return 'preparation must be in the range of 0 and 60';
    }

    return null;
  }

  void onSaved(){
    Menu newMenu = Menu(
      name: _nameController.text, 
      description: _descriptionController.text, 
      price: double.tryParse(_priceController.text)!, 
      isAvailable: true,  // default value first cuz there is no data yet
      categoryId: 1,  // default value first cuz there is no data yet
      minPreparationTime: int.tryParse(_minTimeController.text)!, 
      maxPreparationTime: int.tryParse(_maxTimeController.text)!
    );

    Navigator.pop(context, newMenu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Edit Item', color: Colors.black,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldWidget(
                title: 'Name',
                textController: _nameController,
                validator: _nullValidtor,
              ),
              SizedBox(height: 10),
              TextFieldWidget(
                title: 'Description',
                textController: _descriptionController,
                validator: _descriptionValidator,
              ),
              SizedBox(height: 10),
              Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // DropdownButtonFormField<MenuCategory>(
              //   value: selectedCategory,
              //   items: mockMenuCategories.map((cat) => DropdownMenuItem(
              //     value: cat,
              //     child: Text(cat.categoryName),
              //   )).toList(),
              //   onChanged: (value){
              //     setState(() {
              //       selectedCategory = value!;
              //     });
              //   },
              //   decoration: InputDecoration(border: OutlineInputBorder()),
              // ),
              // SizedBox(height: 10),
              TextFieldWidget(
                title: 'Price',
                textController: _priceController,
                prefixText: '\$',
              ),
              SizedBox(height: 10),
              TextFieldWidget(
                title: 'Min preparation time',
                textController: _minTimeController,
                validator: _preparationTimeValidator,
              ),
              SizedBox(height: 10),
              TextFieldWidget(
                title: 'Max preparation time',
                textController: _maxTimeController,
                validator: _preparationTimeValidator,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonWidget(
                    title: 'Cancel', 
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    backgroundColor: Colors.white, 
                    textColor: Color.fromRGBO(13, 71, 161, 1),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5)
                  ),
                  ButtonWidget(
                    title: 'Save', 
                    onPressed: onSaved, 
                    backgroundColor: Color.fromRGBO(255, 104, 53, 1), 
                    textColor: Colors.white, 
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5)),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}