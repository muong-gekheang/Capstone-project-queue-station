import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/services/order_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_item/view_models/menu_item_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_item/widgets/menu_item_content.dart';
import '../../../../../../data/repositories/queue_entry/queue_entry_repository.dart';

class MenuItemScreen extends StatelessWidget {
  final MenuItem? item;
  final OrderItem? cartItem;

  const MenuItemScreen({super.key, this.item, this.cartItem});

  MenuItem get menuItem => item ?? cartItem!.item;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuItemViewModel(
        menuItem: menuItem,
        cartItem: cartItem,
        orderProvider: context.read<OrderProvider>(),
        queueEntryRepository: context.read<QueueEntryRepository>()
      ),
      child: const MenuItemContent(),
    );
  }
}
