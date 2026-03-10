import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/menu_management_view_model.dart';
import 'package:queue_station_app/data/repositories/menu/menu_mock_data.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchbarWidget(
              hintText: "Search menu...",
              onChanged: (value) => vm.updateSearchQuery(value),
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
                  final item = filteredList[index];
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
        children: List.generate(mockMenuCategories.length, (index) {
          final category = mockMenuCategories[index];
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
