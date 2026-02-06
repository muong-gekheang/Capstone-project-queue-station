import 'package:flutter/material.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/model//menu.dart';
import 'package:queue_station_app/model//menu_add_on.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/add_new_add_on_menu.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/add_new_menu.dart';

import 'package:queue_station_app/ui/widgets/option_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';

class AddOnsManagement extends StatefulWidget {

  const AddOnsManagement({super.key});

  @override
  State<AddOnsManagement> createState() => _AddOnsManagementState();
}

class _AddOnsManagementState extends State<AddOnsManagement> {
  String searchValue = '';

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
      return Center(child: Text("No Add-Ons yet"));
    }

    return ListView.builder(
      itemCount: filteredAddOns.length,
      itemBuilder: (context, index) => OptionWidget(optionModel: filteredAddOns[index]),
    );
  
  
}
      

  void onCreate() async {
    Menu? newAddOn = await Navigator.push<Menu>(
      context,
      MaterialPageRoute(builder: (context) => AddNewAddOnMenu()),
    );

    if (newAddOn != null) {
      mockMenus.add(newAddOn);
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
