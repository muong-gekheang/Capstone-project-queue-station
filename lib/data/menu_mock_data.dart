import 'dart:typed_data';
import 'package:queue_station_app/domain/menu.dart';
import 'package:queue_station_app/domain/menu_category.dart';

final List<MenuCategory> mockMenuCategories = [
  MenuCategory(categoryId: 1, categoryName: "Burger"),
  MenuCategory(categoryId: 2, categoryName: "Pizza"),
  MenuCategory(categoryId: 3, categoryName: "Drinks"),
];

final List<Menu> mockMenus = [
  Menu(
    menuId: 1,
    name: "Classic Burger",
    description: "Classic Italian pizza topped with fresh mozzarella, tomato sauce, and basil leaves.",
    price: 5.99,
    preparationTime: 10,
    isAvailable: true,
    categoryId: 1,
  ),
  Menu(
    menuId: 2,
    name: "Cheese Burger",
    description: "Beef patty with extra cheese",
    price: 6.49,
    preparationTime: 12,
    isAvailable: true,
    categoryId: 1,
  ),
  Menu(
    menuId: 3,
    name: "Pepperoni Pizza",
    description: "Classic pepperoni with mozzarella",
    price: 8.99,
    preparationTime: 15,
    isAvailable: true,
    categoryId: 2,
  ),
  Menu(
    menuId: 4,
    name: "Cola",
    description: "Chilled soft drink",
    price: 1.99,
    preparationTime: 2,
    isAvailable: true,
    categoryId: 3,
  ),
];

