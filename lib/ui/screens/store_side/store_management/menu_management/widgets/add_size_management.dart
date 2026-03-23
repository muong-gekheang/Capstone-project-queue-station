import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository_mock.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/view_model/menu_management_view_model.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';

class AddSizeScreen extends StatefulWidget {
  final List<MenuSize> selectedMenuSizes;
  const AddSizeScreen({super.key, required this.selectedMenuSizes});

  @override
  State<AddSizeScreen> createState() => _AddSizeScreenState();
}

class _AddSizeScreenState extends State<AddSizeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _sizeController = TextEditingController();
  List<SizeOption> selectedSizes = [];

  @override
  void initState() {
    super.initState();
    for (var menuSize in widget.selectedMenuSizes) {
      if (menuSize.sizeOption != null) selectedSizes.add(menuSize.sizeOption!);
    }
  }

  String? _nullValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return 'this field cannot be null';
    } else {
      return null;
    }
  }

  void onSave() {
    var vm = context.read<MenuManagementViewModel>();
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields correctly"),
        ),
      );

      return;
    }
    final sizeName = _sizeController.text.trim();

    for (var sizeOption in vm.sizeOptions) {
      if (sizeOption.name == sizeName) return;
    }
    vm.addNewSizeOption(
      SizeOption(name: sizeName, id: uuid.v4(), restaurantId: ''),
    );
    _sizeController.clear();
  }

  Widget existingSize() {
    var vm = context.read<MenuManagementViewModel>();

    return ListView.builder(
      itemCount: vm.sizeOptions.length,
      itemBuilder: (context, index) {
        final globalMenuSize = vm.sizeOptions[index];
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

  bool get isAddDisabled {
    return (selectedSizes.isEmpty);
  }

  void onAdd() {
    Navigator.pop(
      context,
      selectedSizes
          .map(
            (e) => MenuSize(
              price: 0,
              sizeOption: e,
              id: uuid.v4(),
              sizeOptionId: e.id,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MenuManagementViewModel>();
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
                      validator: _nullValidator,
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
