import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart'; // for mockMenuCategories
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_detail.dart';
import 'package:queue_station_app/ui/widgets/delete-menu-pop-up.dart';

class MenuCardWidget extends StatefulWidget {
  final MenuItem menu;
  final VoidCallback? onDelete;
  const MenuCardWidget({super.key, required this.menu, this.onDelete});

  @override
  State<MenuCardWidget> createState() => _MenuCardWidgetState();
}

class _MenuCardWidgetState extends State<MenuCardWidget> {
  String _getCategoryName() {
    try {
      return mockMenuCategories
          .firstWhere((c) => c.id == widget.menu.categoryId)
          .name;
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.menu.isAvailable
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuDetail(menu: widget.menu),
                ),
              );
              // No need for .then or setState here
            }
          : null,
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.naturalBlack.withAlpha(64),
                    offset: const Offset(0, 0),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          image: widget.menu.image != null
                              ? DecorationImage(
                                  image: AssetImage(widget.menu.image!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/default_menu.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.menu.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _getCategoryName(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "•",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "\$${widget.menu.cheapestPrice(widget.menu.sizes).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Color.fromRGBO(255, 104, 53, 1),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.menu.isAvailable
                                ? "Available"
                                : "Not Available",
                            style: TextStyle(
                              color: widget.menu.isAvailable
                                  ? const Color.fromRGBO(16, 185, 129, 1)
                                  : const Color.fromRGBO(230, 57, 70, 1),
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
                                  EditMenuScreen(existingMenu: widget.menu),
                            ),
                          );
                        },
                        icon: const Icon(Icons.create_outlined),
                        color: const Color.fromRGBO(13, 71, 161, 1),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: () async {
                          final deleteConfirmation = await showDialog<bool>(
                            context: context,
                            builder: (context) => DeleteMenuPopUp(
                              message: 'Are you sure you want to delete ',
                              menu: widget.menu,
                            ),
                          );
                          if (deleteConfirmation == true &&
                              widget.onDelete != null) {
                            widget.onDelete!();
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromRGBO(230, 57, 70, 1),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!widget.menu.isAvailable)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.naturalBlack.withAlpha(127),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
