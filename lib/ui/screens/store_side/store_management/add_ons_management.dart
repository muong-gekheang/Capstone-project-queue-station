import 'package:flutter/material.dart';
import 'package:queue_station_app/data/mock/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/add_new_add_on_menu.dart';

import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';

class AddOnsManagement extends StatefulWidget {
  final MenuItem? existingMenu;
  const AddOnsManagement({super.key, required this.existingMenu});

  @override
  State<AddOnsManagement> createState() => _AddOnsManagementState();
}

class _AddOnsManagementState extends State<AddOnsManagement> {
  String searchValue = '';
  List<AddOn> selectedAddOns = [];

  @override
  void initState() {
    super.initState();
    selectedAddOns = widget.existingMenu?.addOns.toList() ?? [];
  }

  bool get isAddDisabled {
    return selectedAddOns.isEmpty;
  }

  Widget existingAddOns() {
    // Filter add-ons: if search is not empty, filter; else show all
    final filteredAddOns = searchValue.trim().isEmpty
        ? globalAddOns
        : globalAddOns
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
                  setState(() {
                    if (value == true) {
                      if (!selectedAddOns.any((s) => s.id == addOn.id)) {
                        selectedAddOns.add(addOn);
                      }
                    } else {
                      selectedAddOns.removeWhere((s) => s.id == addOn.id);
                    }
                  });
                }, // checkbox also triggers parent
              ),
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
    final existingAddOnIds =
        widget.existingMenu?.addOns.map((a) => a.id).toSet() ?? {};

    // Keep only the new add-ons that aren't already in the existing menu
    final List<AddOn> addOnsToAdd = selectedAddOns
        .where((addOn) => !existingAddOnIds.contains(addOn.id))
        .toList();

    Navigator.pop(context, addOnsToAdd);
  }

  void onCreate() async {
    final AddOn? newAddOn = await Navigator.push<AddOn>(
      context,
      MaterialPageRoute(builder: (context) => const AddNewAddOnMenu()),
    );

    if (newAddOn != null) {
      setState(() {
        globalAddOns.add(newAddOn);
        selectedAddOns.add(newAddOn);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: isAddDisabled ? null : onAdd,
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
