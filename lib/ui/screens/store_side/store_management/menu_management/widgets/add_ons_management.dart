import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/view_model/menu_management_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/add_new_add_on_menu.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';

class AddOnsManagement extends StatefulWidget {
  final List<AddOn> selectedAddOns;
  const AddOnsManagement({super.key, required this.selectedAddOns});

  @override
  State<AddOnsManagement> createState() => _AddOnsManagementState();
}

class _AddOnsManagementState extends State<AddOnsManagement> {
  String searchValue = '';
  List<AddOn> selectedAddOns = [];

  @override
  void initState() {
    super.initState();
    selectedAddOns = [...widget.selectedAddOns];
  }

  bool get isAddDisabled {
    return selectedAddOns.isEmpty;
  }

  Widget existingAddOns() {
    var vm = context.read<MenuManagementViewModel>();
    final filteredAddOns = searchValue.trim().isEmpty
        ? vm.allAddOns
        : vm.allAddOns
              .where(
                (addOn) => addOn.name.toLowerCase().contains(
                  searchValue.toLowerCase(),
                ),
              )
              .toList();

    if (filteredAddOns.isEmpty) {
      return const Center(child: Text("No Add-Ons yet"));
    }

    return ListView.builder(
      itemCount: filteredAddOns.length,
      itemBuilder: (context, index) {
        final globalMenuAddOns = filteredAddOns[index];
        final addOn = filteredAddOns[index];
        final isSelected = selectedAddOns.any((s) => s.id == addOn.id);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  if (value == true) {
                    if (!selectedAddOns.any((s) => s.id == addOn.id)) {
                      setState(() {
                        selectedAddOns.add(addOn);
                      });
                    }
                  } else {
                    setState(() {
                      selectedAddOns.removeWhere((s) => s.id == addOn.id);
                    });
                  }
                }, // checkbox also triggers parent
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: addOn.image != null 
                      ? NetworkImage(addOn.image!)
                      : AssetImage('assets/images/default_menu_profile.jpg'),
                  fit: BoxFit.cover)
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  globalMenuAddOns.name,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text('\$${globalMenuAddOns.price.toStringAsFixed(2)}'),
            ],
          ),
        );
      },
    );
  }

  void onAdd() {
    Navigator.pop(context, selectedAddOns);
  }

  void onCreate() async {
    var vm = context.read<MenuManagementViewModel>();
    final createdAddOn = await Navigator.push<(AddOn, Uint8List?)>(
      context,
      MaterialPageRoute(builder: (context) => const AddNewAddOnMenu()),
    );

    if (createdAddOn != null) {
      final addOn = createdAddOn.$1;
      final selectedImageBytes = createdAddOn.$2;
      vm.addNewAddOn(addOn, selectedImageBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MenuManagementViewModel>();
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Existing Add-Ons",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          SearchbarWidget(
            hintText: 'search...',
            onChanged: (value) {
              setState(() {
                searchValue = value;
              });
            },
          ),
          SizedBox(height: 10),
          Expanded(child: existingAddOns()),
          ButtonWidget(
            title: 'Add',
            onPressed: onAdd,
            backgroundColor: AppTheme.primaryColor,
            textColor: AppTheme.naturalWhite,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            borderRadius: 50,
          ),
          ButtonWidget(
            leadingIcon: Icons.add,
            title: 'Create new one',
            onPressed: onCreate,
            backgroundColor: Color.fromRGBO(13, 71, 161, 0.5),
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            borderRadius: 50,
          ),
        ],
      ),
    );
  }
}
