import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/ui/screens/user_side/cart/cart_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/menu_item/menu_item_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/order_screen.dart';
import 'package:queue_station_app/ui/widgets/menu_item_card.dart';
import 'package:queue_station_app/ui/screens/user_side/menu/view_models/menu_view_model.dart';

class MenuContent extends StatefulWidget {
  const MenuContent({super.key});

  @override
  State<MenuContent> createState() => _MenuContentState();
}

class _MenuContentState extends State<MenuContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch(MenuViewModel vm) {
    _searchController.clear();
    vm.searchMenuItems('');
  }

  @override
  Widget build(BuildContext context) {
    final menuVM = context.watch<MenuViewModel>();
    print(menuVM.currentOrder.id);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child:
                  menuVM.restaurant?.logoLink != null &&
                      menuVM.restaurant!.logoLink.isNotEmpty
                  ? Image.network(
                      menuVM.restaurant!.logoLink,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.store,
                          color: Color(0xFFFF6835),
                        );
                      },
                    )
                  : const Icon(Icons.store, color: Color(0xFFFF6835)),
            ),
            const SizedBox(width: 12),
            Text(
              menuVM.restaurantName.isEmpty
                  ? "Restaurant"
                  : menuVM.restaurantName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${menuVM.userName}",
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 16),

            // SEARCH + VIEW ORDER
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: menuVM.searchMenuItems,
                    decoration: InputDecoration(
                      hintText: "Search menu...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _clearSearch(menuVM),
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrderScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "View Order",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // CATEGORY FILTER
            if (menuVM.menuCategories.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: menuVM.menuCategories.length,
                  itemBuilder: (context, index) {
                    final category = menuVM.menuCategories[index];
                    final isSelected = category.id == menuVM.selectedCategory;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => menuVM.filterByCategory(category.id),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFF6835)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            // MENU GRID
            Expanded(
              child: menuVM.isMenuLoading
                  ? const Center(child: CircularProgressIndicator())
                  : menuVM.menuItems.isEmpty
                  ? _buildEmptyMenu()
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: menuVM.menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuVM.menuItems[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MenuItemScreen(item: item),
                            ),
                          ),
                          child: MenuItemCard(item: item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // FLOATING CART BUTTON
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFFFF6835),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Provider.value(
                  value: context.read<UserRepository<Customer>>(),
                  child: CartScreen(),
                ),
              ),
            ),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          if (menuVM.totalCartItemsCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFF6835), width: 1),
                ),
                child: Center(
                  child: Text(
                    menuVM.totalCartItemsCount.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyMenu() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No items found",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
