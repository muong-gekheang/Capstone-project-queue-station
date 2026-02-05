import 'package:flutter/material.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/model/entities/add_on.dart';
import 'package:queue_station_app/model/entities/menu.dart';
import 'package:queue_station_app/model/entities/menu_category.dart';

import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/delete-menu-pop-up.dart';

class MenuDetail extends StatefulWidget {
  final Menu menu;
  final VoidCallback? onDelete;
  const MenuDetail({super.key, required this.menu, this.onDelete});

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  late Menu menu;
  @override
  void initState() {
    super.initState();
    menu = widget.menu; // initialize once
  }
  @override
  Widget build(BuildContext context) {
    final MenuCategory = mockMenuCategories.firstWhere(
      (c) => c.categoryId == menu.categoryId,
    );

    void onEdit() async {
      Menu? newMenu = await Navigator.push<Menu>(
        context,
        MaterialPageRoute(
          builder: (context) => EditMenuScreen(existingMenu: menu),
        ),
      );

      if (newMenu != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Updated Sucessfully",
              style: TextStyle(color: Color.fromRGBO(16, 185, 129, 1)),
            ),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          ),
        );
      }
    }

    final menuAddOns = globalAddOns
        .where((addOn) => menu.addOnIds.contains(addOn.id))
        .toList();

    return Scaffold(
      appBar: AppBarWidget(title: menu.name, color: Colors.black),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                if (menu.menuImage == null)
                  CircleAvatar(radius: 120, backgroundColor: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menu.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(MenuCategory.categoryName),
                      ],
                    ),
                    Text(
                      menu.isAvailable ? 'Available' : 'Not Available',
                      style: TextStyle(
                        color: menu.isAvailable
                            ? Color.fromRGBO(16, 185, 129, 1)
                            : Color.fromRGBO(230, 57, 70, 1),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        menu.description,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(width: 80),
                    Text(
                      '\$${menu.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 104, 53, 1),
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 5),
                    Text(
                      '${menu.minPreparationTime} - ${menu.maxPreparationTime} min',
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    const Text(
                      "Size Options",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (menu.sizes.isEmpty)
                      Text('This menu has no size'),
                    SizedBox(height: 10),
                    ...menu.sizes.map((size) {
                      final totalPrice = menu.price + size.price;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2, // more space for name
                              child: Text(size.size.name),
                            ),
                            Expanded(
                              flex: 1, // smaller space for extra price
                              child: Text(
                                '+ \$${size.price.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 1, // smaller space for total price
                              child: Text(
                                '\$${totalPrice.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    const Text(
                      "Add-On Options",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (menu.addOnIds.isEmpty)
                      Text('This menu has no add-on option'),
                    SizedBox(height: 10),
                    ...menu.addOnIds.map((addOnId) {
                      // Find the actual add-on object
                      final addOn = globalAddOns.firstWhere(
                        (a) => a.id == addOnId,
                      );

                      final totalPrice = menu.price + addOn.price;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2, // more space for name
                              child: Text(addOn.name),
                            ),
                            Expanded(
                              flex: 1, // smaller space for extra price
                              child: Text(
                                '+ \$${addOn.price.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 1, // smaller space for total price
                              child: Text(
                                '\$${totalPrice.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWidget(
                        leadingIcon: Icons.delete,
                        title: 'Delete',
                        onPressed: () async {
                          // will implement later
                        },
                        backgroundColor: Color.fromRGBO(230, 57, 70, 1),
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 5,
                        ),
                      ),


                      ButtonWidget(
                        leadingIcon: Icons.create_outlined,
                        title: 'Edit',
                        onPressed: () async {
                          final editedMenu = await Navigator.push<Menu>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditMenuScreen(existingMenu: menu),
                            ),
                          );
                          if (editedMenu != null) {
                            setState(() {
                              menu = editedMenu;
                            });
                          }
                        },
                        backgroundColor: Color.fromRGBO(13, 71, 161, 1),
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
        ),
      ),
    );
  }
}
