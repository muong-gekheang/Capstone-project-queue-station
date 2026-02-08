import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';

/// ----------------------------
/// GLOBAL SIZES
/// ----------------------------
final List<SizeOption> globalSizes = [
  SizeOption(name: 'Small'),
  SizeOption(name: 'Medium'),
  SizeOption(name: 'Large'),
];

/// ----------------------------
/// GLOBAL SIZES
/// ----------------------------
final List<AddOn> globalAddOns = [
  AddOn(name: 'Extra Cheese', price: 1.50, image: ""),
  AddOn(name: 'Bacon', price: 2.00, image: ""),
  AddOn(name: 'Avocado', price: 2.50, image: ""),
  AddOn(name: 'Extra Sauce', price: 0.75, image: ""),
  AddOn(name: 'Fried Egg', price: 1.25, image: ""),
];

/// ----------------------------
/// MENU-SIZE RELATIONS (PRICE PER MENU)
/// ----------------------------
final List<MenuSize> burgerSizes = [
  MenuSize(sizeOption: globalSizes[0], price: 0.0), // Small
  MenuSize(sizeOption: globalSizes[1], price: 1.0), // Medium
  MenuSize(sizeOption: globalSizes[2], price: 1.25), // Large
];

final List<MenuSize> burgerMediumLarge = [
  MenuSize(sizeOption: globalSizes[1], price: 1.0), // Medium
  MenuSize(sizeOption: globalSizes[2], price: 1.25), // Large
];

final List<MenuSize> pizzaSizes = [
  MenuSize(sizeOption: globalSizes[0], price: 0.0), // Small
  MenuSize(sizeOption: globalSizes[1], price: 2.0), // Medium
];

/// ----------------------------
/// CATEGORIES
/// ----------------------------
final List<MenuItemCategory> mockMenuCategories = [
  MenuItemCategory(name: "Burger"),
  MenuItemCategory(name: "Pizza"),
  MenuItemCategory(name: "Drinks"),
];

/// ----------------------------
/// ADD-ONS
/// ----------------------------
final List<AddOn> mockMenuAddOns = [
  AddOn(name: 'Extra Cheese', price: 0.99, image: ""),
  AddOn(name: 'Bacon Strips', price: 1.49, image: ""),
  AddOn(name: 'Avocado', price: 1.29, image: ""),
  AddOn(name: 'Extra Sauce', price: 0.59, image: ""),
  AddOn(name: 'Onion Rings', price: 1.99, image: ""),
];

/// ----------------------------
/// MENUS
/// ----------------------------

// 1. Classic Burger
final MenuItem classicBurger =
    MenuItem(
        name: "Classic Burger",
        description:
            "Classic burger with fresh lettuce, tomato, and beef patty.",
        minPrepTimeMinutes: 10,
        maxPrepTimeMinutes: 15,
        category: mockMenuCategories[0], // Burger category
        image: "assets/images/burger.jpg",
      )
      ..sizes.addAll(burgerSizes)
      ..addOns.addAll([
        globalAddOns[0], // Extra Cheese
        globalAddOns[1], // Bacon
        globalAddOns[4], // Fried Egg
      ]);

// 2. Cheese Burger
final MenuItem cheeseBurger =
    MenuItem(
        name: "Cheese Burger",
        description:
            "Beef patty with melted cheddar cheese, pickles, and special sauce.",
        minPrepTimeMinutes: 9,
        maxPrepTimeMinutes: 12,
        category: mockMenuCategories[0], // Burger category
        image: "assets/images/cheese_burger.jpg",
      )
      ..sizes.addAll(burgerMediumLarge)
      ..addOns.addAll([
        globalAddOns[0], // Extra Cheese
        globalAddOns[1], // Bacon
        globalAddOns[2], // Avocado
        globalAddOns[4], // Fried Egg
      ]);

// 3. Pepperoni Pizza
final MenuItem pepperoniPizza =
    MenuItem(
        name: "Pepperoni Pizza",
        description:
            "Classic pepperoni with mozzarella cheese on tomato sauce base.",
        minPrepTimeMinutes: 20,
        maxPrepTimeMinutes: 25,
        category: mockMenuCategories[1], // Pizza category
        image: "assets/images/pizza.jpg",
      )
      ..sizes.addAll(pizzaSizes)
      ..addOns.addAll([
        globalAddOns[0], // Extra Cheese
        globalAddOns[1], // Bacon
        globalAddOns[2], // Avocado
        globalAddOns[3], // Extra Sauce
      ]);

// 4. Margherita Pizza
final MenuItem margheritaPizza =
    MenuItem(
        name: "Margherita Pizza",
        description:
            "Simple yet delicious with fresh mozzarella, tomatoes, and basil.",
        minPrepTimeMinutes: 20,
        maxPrepTimeMinutes: 25,
        category: mockMenuCategories[1], // Pizza category
        image: "assets/images/margherita_pizza.jpg",
      )
      ..sizes.addAll([
        MenuSize(sizeOption: globalSizes[1], price: 1.0), // Medium
        MenuSize(sizeOption: globalSizes[2], price: 2.0), // Large
      ])
      ..addOns.addAll([
        globalAddOns[0], // Extra Cheese
        globalAddOns[3], // Extra Sauce
      ]);

// 5. Cola
final MenuItem cola =
    MenuItem(
        name: "Cola",
        description: "Chilled soft drink, perfect with any meal.",
        minPrepTimeMinutes: 2,
        maxPrepTimeMinutes: 5,
        category: mockMenuCategories[2], // Drinks category
        image: "assets/images/cola.jpg",
      )
      ..addOns.addAll([
        AddOn(name: 'Extra Ice', price: 0.25, image: ""),
        AddOn(name: 'Lemon Slice', price: 0.10, image: ""),
      ]);
final MenuItem veggieWrap =
    MenuItem(
        name: "Veggie Wrap",
        description:
            "A healthy wrap with fresh vegetables, hummus, and whole wheat tortilla.",
        minPrepTimeMinutes: 10,
        maxPrepTimeMinutes: 15,
        category:
            mockMenuCategories[0], // Burger category (or you can create a new category 'Wraps')
        image: "assets/images/veggie_wrap.jpg",
      )
      ..sizes.addAll(burgerMediumLarge)
      ..addOns.addAll([
        globalAddOns[0], // Extra Cheese
        globalAddOns[2], // Avocado
        globalAddOns[3], // Extra Sauce
      ]);

// List of all menu items
final List<MenuItem> allMenuItems = [
  classicBurger,
  cheeseBurger,
  pepperoniPizza,
  margheritaPizza,
  cola,
  veggieWrap,
];
