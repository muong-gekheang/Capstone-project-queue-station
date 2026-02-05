import 'package:queue_station_app/model//menu.dart';
import 'package:queue_station_app/model//menu_add_on.dart';
import 'package:queue_station_app/model//menu_size.dart';
import 'package:queue_station_app/model//size.dart';
import 'package:queue_station_app/model/menu.dart' hide Menu;
import 'package:queue_station_app/model/menu_category.dart';

/// ----------------------------
/// GLOBAL SIZES
/// ----------------------------
final List<MenuSizeOption> globalSizes = [
  MenuSizeOption(id: 1, name: 'Small'),
  MenuSizeOption(id: 2, name: 'Medium'),
  MenuSizeOption(id: 3, name: 'Large'),
];

/// ----------------------------
/// GLOBAL SIZES
/// ----------------------------
final List<MenuAddOn> globalAddOns = [
  MenuAddOn(
    id: 1,
    name: 'Extra Cheese',
    price: 1.50,
    image: null,
  ),
  MenuAddOn(
    id: 2,
    name: 'Bacon',
    price: 2.00,
    image: null,
  ),
  MenuAddOn(
    id: 3,
    name: 'Avocado',
    price: 2.50,
    image: null,
  ),
  MenuAddOn(
    id: 4,
    name: 'Extra Sauce',
    price: 0.75,
    image: null,
  ),
  MenuAddOn(
    id: 5,
    name: 'Fried Egg',
    price: 1.25,
    image: null,
  ),
];


/// ----------------------------
/// MENU-SIZE RELATIONS (PRICE PER MENU)
/// ----------------------------
final List<MenuSize> burgerSizes = [
  MenuSize(size: globalSizes[0], price: 0.0), // Small
  MenuSize(size: globalSizes[1], price: 1.0), // Medium
  MenuSize(size: globalSizes[2], price: 1.25), // Large
];

final List<MenuSize> burgerMediumLarge = [
  MenuSize(size: globalSizes[1], price: 1.0), // Medium
  MenuSize(size: globalSizes[2], price: 1.25), // Large
];

final List<MenuSize> pizzaSizes = [
  MenuSize(size: globalSizes[0], price: 0.0), // Small
  MenuSize(size: globalSizes[1], price: 2.0), // Medium
];

/// ----------------------------
/// CATEGORIES
/// ----------------------------
final List<MenuCategory> mockMenuCategories = [
  MenuCategory(categoryId: 1, categoryName: "Burger"),
  MenuCategory(categoryId: 2, categoryName: "Pizza"),
  MenuCategory(categoryId: 3, categoryName: "Drinks"),
];

/// ----------------------------
/// ADD-ONS
/// ----------------------------
final List<MenuAddOn> mockMenuAddOns = [
  MenuAddOn(id: 1, name: 'Extra Cheese', price: 0.99),
  MenuAddOn(id: 2, name: 'Bacon Strips', price: 1.49),
  MenuAddOn(id: 3, name: 'Avocado', price: 1.29),
  MenuAddOn(id: 4, name: 'Extra Sauce', price: 0.59),
  MenuAddOn(id: 5, name: 'Onion Rings', price: 1.99),
];

/// ----------------------------
/// MENUS
/// ----------------------------
final List<Menu> mockMenus = [
  Menu(
    menuId: 1,
    name: "Classic Burger",
    description: "Classic burger with fresh lettuce, tomato, and beef patty.",
    price: 5.99,
    minPreparationTime: 10,
    maxPreparationTime: 15,
    isAvailable: true,
    categoryId: 1,
    sizes: burgerSizes,
    addOnIds: [],
  ),
  Menu(
    menuId: 2,
    name: "Cheese Burger",
    description: "Beef patty with extra cheese",
    price: 6.49,
    minPreparationTime: 12,
    maxPreparationTime: 20,
    isAvailable: true,
    categoryId: 1,
    sizes: burgerMediumLarge,
    addOnIds: [1, 4], 
  ),
  Menu(
    menuId: 3,
    name: "Pepperoni Pizza",
    description: "Classic pepperoni with mozzarella",
    price: 8.99,
    minPreparationTime: 15,
    maxPreparationTime: 20,
    isAvailable: true,
    categoryId: 2,
    sizes: pizzaSizes,
    addOnIds: [2,3],
  ),
  Menu(
    menuId: 4,
    name: "Cola",
    description: "Chilled soft drink",
    price: 1.99,
    minPreparationTime: 2,
    maxPreparationTime: 5,
    isAvailable: true,
    categoryId: 3,
    sizes: [], // drinks have no size
  ),
];


