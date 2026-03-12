import 'package:flutter/material.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/add_new_menu.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/category_card_widget.dart';
import 'package:queue_station_app/ui/widgets/menu_card_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';

class MenuManagement extends StatefulWidget {
  const MenuManagement({super.key});

  @override
  State<MenuManagement> createState() => _MenuManagementState();
}

class _MenuManagementState extends State<MenuManagement> {
  int selectedIndex = 0;
  String selectedCategoryId = '';
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    if (mockMenuCategories.isNotEmpty) {
      selectedCategoryId = mockMenuCategories[selectedIndex].id;
    }
  }

  List<MenuItem> get filteredMenuItems {
    return allMenuItems.where((item) {
      if (searchValue.isNotEmpty) {
        return item.name.toLowerCase().contains(searchValue.toLowerCase());
      }
      return item.categoryId == selectedCategoryId;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Menu Management",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: SearchbarWidget(
                      hintText: "search...",
                      onChanged: (String value) {
                        setState(() => searchValue = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ButtonWidget(
                    leadingIcon: Icons.add,
                    title: "Add Item",
                    onPressed: () async {
                      final newMenu = await Navigator.push<MenuItem>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNewMenu(),
                        ),
                      );
                      if (newMenu != null) {
                        setState(() {
                          allMenuItems.add(newMenu);
                        });
                      }
                    },
                    backgroundColor: const Color.fromRGBO(255, 104, 53, 1),
                    textColor: Colors.white,
                    borderRadius: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(mockMenuCategories.length, (index) {
                  return Row(
                    children: [
                      CategoryCardWidget(
                        name: mockMenuCategories[index].name,
                        isSelected: selectedIndex == index,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            selectedCategoryId = mockMenuCategories[index].id;
                          });
                        },
                      ),
                      if (index != mockMenuCategories.length - 1)
                        const SizedBox(width: 10),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Menu List",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredMenuItems.isEmpty
                  ? const Center(child: Text('No menu items found'))
                  : ListView.builder(
                      itemCount: filteredMenuItems.length,
                      itemBuilder: (context, index) {
                        final menu = filteredMenuItems[index];
                        return MenuCardWidget(
                          menu: menu,
                          onDelete: () {
                            setState(() {
                              allMenuItems.removeWhere(
                                (item) => item.id == menu.id,
                              );
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
