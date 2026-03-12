import 'dart:io';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';

class MenuDetail extends StatefulWidget {
  final MenuItem menu;
  final VoidCallback? onDelete;
  const MenuDetail({super.key, required this.menu, this.onDelete});

  @override
  State<MenuDetail> createState() => _MenuDetailState(); // Fixed: changed <tail> to <MenuDetail>
}

class _MenuDetailState extends State<MenuDetail> {
  late MenuItem menu;

  @override
  void initState() {
    super.initState();
    menu = widget.menu;
  }

  String _getCategoryName() {
    try {
      return mockMenuCategories.firstWhere((c) => c.id == menu.categoryId).name;
    } catch (e) {
      return 'Unknown';
    }
  }

  double defaultPrice() {
    if (menu.sizes.isEmpty) return 0.0;
    double cheapest = menu.sizes.first.price;
    for (var size in menu.sizes) {
      if (size.price < cheapest) cheapest = size.price;
    }
    return cheapest;
  }

  ImageProvider? getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    if (imagePath.startsWith('http')) return NetworkImage(imagePath);
    if (imagePath.startsWith('assets/')) return AssetImage(imagePath);
    final file = File(imagePath);
    if (file.existsSync()) return FileImage(file);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: menu.name, color: Colors.black),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 120,
                  backgroundImage:
                      getImageProvider(menu.image) ??
                      const AssetImage('assets/images/default.png'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu Availability',
                      style: TextStyle(fontSize: AppTheme.heading3),
                    ),
                    Switch(
                      value: menu.isAvailable,
                      onChanged: (bool value) {
                        setState(() {
                          menu.isAvailable = value; // Fixed: was menu = value
                          final index = allMenuItems.indexWhere(
                            (m) => m.id == menu.id,
                          );
                          if (index != -1) {
                            allMenuItems[index] = menu;
                          }
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menu.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(_getCategoryName()),
                      ],
                    ),
                    Text(
                      menu.isAvailable ? 'Available' : 'Not Available',
                      style: TextStyle(
                        color: menu.isAvailable
                            ? const Color.fromRGBO(16, 185, 129, 1)
                            : const Color.fromRGBO(230, 57, 70, 1),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                    const SizedBox(width: 80),
                    Text(
                      '\$${defaultPrice().toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 104, 53, 1),
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 5),
                    Text(
                      '${menu.minPrepTimeMinutes ?? 0} - ${menu.maxPrepTimeMinutes ?? 0} min',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (menu.sizes.isNotEmpty) ...[
                  const Text(
                    "Size Options",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...menu.sizes.map((size) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text(size.sizeOption.name)),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '\$${size.price.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ] else
                  const Text('This menu has no size options'),
                const SizedBox(height: 10),
                if (menu.addOns.isNotEmpty) ...[
                  const Text(
                    "Add-On Options",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...menu.addOns.map((addOn) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text(addOn.name)),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '+ \$${addOn.price.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ] else
                  const Text('This menu has no add-on options'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWidget(
                        leadingIcon: Icons.delete,
                        title: 'Delete',
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Menu'),
                              content: Text(
                                'Are you sure you want to delete ${menu.name}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(
                                      230,
                                      57,
                                      70,
                                      1,
                                    ),
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            allMenuItems.removeWhere(
                              (item) => item.id == menu.id,
                            );
                            if (widget.onDelete != null) widget.onDelete!();
                            Navigator.pop(context);
                          }
                        },
                        backgroundColor: const Color.fromRGBO(230, 57, 70, 1),
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 5,
                        ),
                      ),
                      ButtonWidget(
                        leadingIcon: Icons.create_outlined,
                        title: 'Edit',
                        onPressed: () async {
                          final editedMenu = await Navigator.push<MenuItem>(
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
                        backgroundColor: const Color.fromRGBO(13, 71, 161, 1),
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
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
