import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/view_model/menu_management_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu/edit_menu_screen.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/custom_success_snackbar.dart';

class MenuDetail extends StatefulWidget {
  final MenuItem menu;
  const MenuDetail({super.key, required this.menu});

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MenuManagementViewModel>();
    MenuItem menu = vm.allMenuItems.firstWhere(
      (element) => element.id == widget.menu.id,
    );
    return Scaffold(
      appBar: AppBarWidget(title: menu.name, color: Colors.black),
      body: FutureBuilder(
        future: vm.getMenuitemDetails(menu),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading details"));
          }

          // 1. Capture the data in a local variable
          final menuItem = snapshot.data;

          // 2. Check if the variable itself is null
          if (menuItem == null) {
            return const Center(child: Text("No data found"));
          }

          // Now 'menuItem' is safely treated as non-nullable
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  _buildImageHeader(menuItem.image),
                  const SizedBox(height: 10),
                  _buildAvailabilityToggle(context, vm, menuItem),
                  _buildMenuInfo(menuItem, vm),
                  const SizedBox(height: 10),
                  _buildDetailsList(menuItem),
                  const SizedBox(height: 20),
                  _buildActionButtons(context, vm, menuItem),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailabilityToggle(
    BuildContext context,
    MenuManagementViewModel vm,
    MenuItem menu,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Menu Availability',
          style: TextStyle(fontSize: AppTheme.heading3),
        ),
        Switch(
          value: menu.isAvailable,
          onChanged: (value) => vm.toggleMenuAvailability(menu, value),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    MenuManagementViewModel vm,
    MenuItem menu,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ButtonWidget(
          leadingIcon: Icons.delete,
          title: 'Delete',
          onPressed: () {
            vm.removeMenuItem(menu);
            Navigator.pop(context);
          },
          backgroundColor: const Color.fromRGBO(230, 57, 70, 1),
          textColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        ),
        ButtonWidget(
          leadingIcon: Icons.create_outlined,
          title: 'Edit',
          onPressed: () => _navigateToEdit(context, menu),
          backgroundColor: const Color.fromRGBO(13, 71, 161, 1),
          textColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        ),
      ],
    );
  }

  void _navigateToEdit(BuildContext context, MenuItem menu) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<MenuManagementViewModel>(),
          child: EditMenuScreen(existingMenu: menu),
        ),
      ),
    );
    if (context.mounted) {
      Navigator.pop(context);
      CustomSuccessSnackbar.show(context, "Update Successfully");
    }
  }

  // --- Helper Widgets (Piping only) ---
  Widget _buildImageHeader(String? image) {
    return CircleAvatar(
      radius: 120, 
      backgroundColor: Colors.transparent,
      backgroundImage: _getImageProvider(image));
  }

  Widget _buildMenuInfo(MenuItem menu, MenuManagementViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menu.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text(menu.category.name),
          ],
        ),
        Text(
          '\$${menu.minPrice}',
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsList(MenuItem menu) {
    return Column(
      children: [
        Text(
          'Sizes',
          style: TextStyle(
            fontSize: AppTheme.heading2,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 10),

        ...menu.sizes.map(
          (s) => _buildDataRow(
            s.sizeOption?.name ?? "",
            '\$${s.price.toStringAsFixed(2)}',
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Add Ons',
          style: TextStyle(
            fontSize: AppTheme.heading2,
            color: AppTheme.primaryColor,
          ),
        ),

        const SizedBox(height: 10),
        ...menu.addOns.map((a) => _buildAddOnRow(a)),
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }

  Widget _buildAddOnRow(AddOn addOn) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: addOn.image != null && addOn.image!.isNotEmpty
                        ? NetworkImage(addOn.image!) as ImageProvider
                        : AssetImage('assets/images/default_menu_profile.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(addOn.name),
            ],
          ),
          Text('+ \$${addOn.price.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String? path) {
    // TODO: Insert your ImageProvider logic here
    if (path != null && path.isNotEmpty) {
      return NetworkImage(path);
    }
    return const AssetImage('assets/images/default_menu_profile.jpg');
  }
}
