import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/data/repositories/order/order_repository.dart';
import 'package:queue_station_app/data/repositories/restaurants/menu_item_repository.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/order/order_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/services/cart_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/order/cart_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu/view_models/menu_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu/widgets/menu_content.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_item_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/order/order_screen.dart';
import '../../../../widgets/menu_item_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuViewModel(
        menuItemRepository: context.read<MenuItemRepository>(),
        orderRepository: context.read<OrderRepository>(),
        //orderRepository: context.read<OrderRepository>(),
        //userRepository: context.read<UserRepository>(),
      )..loadMenuItems(),
      child: MenuContent(),
    );
  }
}

