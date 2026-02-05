import 'package:flutter/material.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/model/entities/menu.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/menu_form_widget.dart';

class AddNewMenu extends StatelessWidget {
  const AddNewMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Add Menu Item", color: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MenuForm(
          initialMenu: null, // null = we are adding
          onSubmit: (Menu newMenu) {
            Navigator.pop(context, newMenu); // close the page
          },
        ),
      ),
    );
  }
}
