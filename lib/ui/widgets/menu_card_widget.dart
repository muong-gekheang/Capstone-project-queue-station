import 'package:flutter/material.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_detail.dart';
import 'package:queue_station_app/ui/widgets/delete-menu-pop-up.dart';

class MenuCardWidget extends StatelessWidget {
  final MenuItem menu;
  final VoidCallback? onDelete;
  const MenuCardWidget({super.key, required this.menu, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuDetail(menu: menu)),
        );
      },
      child: Card(
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.naturalBlack.withAlpha(64),
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      image: menu.image != null
                          ? DecorationImage(image: AssetImage(menu.image!))
                          : DecorationImage(
                              image: AssetImage(
                                'assets/images/default_menu.jpg',
                              ),
                            ), // - will implement later
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            menu.category.name,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "•",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "\$${menu.cheapestPrice().toStringAsFixed(2)}",
                            style: TextStyle(
                              color: const Color.fromRGBO(255, 104, 53, 1),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        menu.isAvailable ? "Available" : "Not Available",
                        style: TextStyle(
                          color: menu.isAvailable
                              ? Color.fromRGBO(16, 185, 129, 1)
                              : Color.fromRGBO(230, 57, 70, 1),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditMenuScreen(existingMenu: menu),
                        ),
                      );
                    },
                    icon: Icon(Icons.create_outlined),
                    color: Color.fromRGBO(13, 71, 161, 1),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  SizedBox(width: 5),
                  IconButton(
                    onPressed: () async {
                      final deleteConfirmation = await showDialog<bool>(
                        context: context,
                        builder: (context) => DeleteMenuPopUp(
                          message: 'Are you sure you want to delete ',
                          menu: menu,
                        ),
                      );
                      if (deleteConfirmation == true && onDelete != null) {
                        onDelete!();
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromRGBO(230, 57, 70, 1),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
