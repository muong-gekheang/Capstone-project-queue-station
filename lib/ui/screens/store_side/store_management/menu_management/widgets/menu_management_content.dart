import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/add_new_menu.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import '../view_model/menu_management_view_model.dart';
import 'package:queue_station_app/ui/widgets/category_card_widget.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/menu_card_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';

class MenuManagementContent extends StatelessWidget {
  const MenuManagementContent({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MenuManagementViewModel>();
    final filteredList = vm.getFilteredMenuList();

    return Scaffold(
      appBar: AppBar(title: Text("Menu Management"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: SearchbarWidget(
                      hintText: "Search...",
                      onChanged: (value) => vm.updateSearchQuery(value),
                    ),
                  ),
                  SizedBox(width: 10),
                  ButtonWidget(
                    leadingIcon: Icons.add,
                    title: "Add Item",
                    onPressed: () async {
                      await Navigator.push<MenuItem>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: vm,
                            child: AddNewMenu(),
                          ),
                        ),
                      );
                    },
                    backgroundColor: Color.fromRGBO(255, 104, 53, 1),
                    textColor: Colors.white,
                    borderRadius: 50,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildCategoryList(vm),
            const SizedBox(height: 20),
            const Text(
              "Menu List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index].copyWith(
                    category: vm.allCategories.firstWhere(
                      (e) => e.id == filteredList[index].categoryId,
                    ),
                  );
                  return MenuCardWidget(
                    menu: item,
                    onDelete: () => vm.removeMenuItem(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(MenuManagementViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(vm.allCategories.length, (index) {
          final category = vm.allCategories[index];
          if (vm.selectedCategory == null) {
            vm.updateSelectedIndex(0);
          }
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CategoryCardWidget(
              name: category.name,
              isSelected: vm.selectedIndex == index,
              onTap: () => vm.updateSelectedIndex(index),
            ),
          );
        }),
      ),
    );
  }
}
