import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/ui/screens/user_side/menu_item/view_models/menu_item_view_model.dart' show MenuItemViewModel;

class MenuItemContent extends StatelessWidget {
  const MenuItemContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MenuItemViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.grey[200]),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE
                Container(
                  width: double.infinity,
                  height: 250,
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: vm.menuItem.image != null
                      ? Image.network(
                          vm.menuItem.image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 120,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.restaurant,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: double.infinity,
                              height: 120,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: const Color(0xFFFF6835),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: 120,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.restaurant,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAME + START PRICE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              vm.menuItem.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6835),
                              ),
                            ),
                          ),
                          const Text("From"),
                          Text(
                            '\$${vm.startingPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// DESCRIPTION
                      Text(
                        vm.menuItem.description,
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 20),

                      /// SIZES
                      if (vm.menuItem.sizes.isNotEmpty) ...[
                        const Text(
                          "Sizes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Column(
                          children: vm.menuItem.sizes.map((size) {
                            return RadioListTile(
                              value: size,
                              groupValue: vm.selectedSize,
                              onChanged: (value) {
                                vm.selectSize(value!);
                              },
                              title: Row(
                                children: [
                                  Expanded(child: Text(size.sizeOption?.name ?? "" )),
                                  Text("\$${size.price}"),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),
                      ],

                      /// ADDONS
                      if (vm.menuItem.addOns.isNotEmpty) ...[
                        const Text(
                          "Add-ons",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Column(
                          children: vm.menuItem.addOns.map((addOn) {
                            return CheckboxListTile(
                              value: vm.selectedAddOns[addOn.id] ?? false,
                              onChanged: (value) {
                                vm.toggleAddOn(addOn.id, value!);
                              },
                              title: Row(
                                children: [
                                  Expanded(child: Text(addOn.name)),
                                  Text("+\$${addOn.price}"),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),
                      ],

                      /// NOTE
                      const Text(
                        "Note",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: vm.noteController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: "Special instruction",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// BOTTOM CART BAR
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  /// QUANTITY
                  Row(
                    children: [
                      IconButton(
                        onPressed: vm.decrement,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),

                      Text(
                        "${vm.quantity}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: vm.increment,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  /// ADD BUTTON
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        vm.saveItem();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6835),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            vm.cartItem == null ? "Add" : "Update",
                            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "\$${vm.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 18, color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
