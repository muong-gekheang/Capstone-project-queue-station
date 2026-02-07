import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/size.dart';
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
  AddOn(id: "1", name: 'Extra Cheese', price: 1.50, image: ""),
  AddOn(id: "1", name: 'Bacon', price: 2.00, image: ""),
  AddOn(id: "1", name: 'Avocado', price: 2.50, image: ""),
  AddOn(id: "1", name: 'Extra Sauce', price: 0.75, image: ""),
  AddOn(id: "1", name: 'Fried Egg', price: 1.25, image: ""),
];

/// ----------------------------
/// MENU-SIZE RELATIONS (PRICE PER MENU)
/// ----------------------------
final List<Size> burgerSizes = [
  Size(sizeOption: globalSizes[0], price: 0.0), // Small
  Size(sizeOption: globalSizes[1], price: 1.0), // Medium
  Size(sizeOption: globalSizes[2], price: 1.25), // Large
];

final List<Size> burgerMediumLarge = [
  Size(sizeOption: globalSizes[1], price: 1.0), // Medium
  Size(sizeOption: globalSizes[2], price: 1.25), // Large
];

final List<Size> pizzaSizes = [
  Size(sizeOption: globalSizes[0], price: 0.0), // Small
  Size(sizeOption: globalSizes[1], price: 2.0), // Medium
];

/// ----------------------------
/// CATEGORIES
/// ----------------------------
final List<MenuItemCategory> mockMenuCategories = [
  MenuItemCategory(id: "1", name: "Burger"),
  MenuItemCategory(id: "2", name: "Pizza"),
  MenuItemCategory(id: "3", name: "Drinks"),
];

/// ----------------------------
/// ADD-ONS
/// ----------------------------
final List<AddOn> mockMenuAddOns = [
  AddOn(id: "1", name: 'Extra Cheese', price: 0.99, image: ""),
  AddOn(id: "2", name: 'Bacon Strips', price: 1.49, image: ""),
  AddOn(id: "3", name: 'Avocado', price: 1.29, image: ""),
  AddOn(id: "4", name: 'Extra Sauce', price: 0.59, image: ""),
  AddOn(id: "5", name: 'Onion Rings', price: 1.99, image: ""),
];

/// ----------------------------
/// MENUS
/// ----------------------------

// 1. Classic Burger
final MenuItem classicBurger =
    MenuItem(
        id: "1",
        name: "Classic Burger",
        description:
            "Classic burger with fresh lettuce, tomato, and beef patty.",
        prepTimeMinutes: 15,
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
        id: "2",
        name: "Cheese Burger",
        description:
            "Beef patty with melted cheddar cheese, pickles, and special sauce.",
        prepTimeMinutes: 12,
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
        id: "3",
        name: "Pepperoni Pizza",
        description:
            "Classic pepperoni with mozzarella cheese on tomato sauce base.",
        prepTimeMinutes: 20,
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
        id: "4",
        name: "Margherita Pizza",
        description:
            "Simple yet delicious with fresh mozzarella, tomatoes, and basil.",
        prepTimeMinutes: 18,
        category: mockMenuCategories[1], // Pizza category
        image: "assets/images/margherita_pizza.jpg",
      )
      ..sizes.addAll([
        Size(sizeOption: globalSizes[1], price: 1.0), // Medium
        Size(sizeOption: globalSizes[2], price: 2.0), // Large
      ])
      ..addOns.addAll([
        globalAddOns[0], // Extra Cheese
        globalAddOns[3], // Extra Sauce
      ]);

// 5. Cola
final MenuItem cola =
    MenuItem(
        id: "5",
        name: "Cola",
        description: "Chilled soft drink, perfect with any meal.",
        prepTimeMinutes: 2,
        category: mockMenuCategories[2], // Drinks category
        image: "assets/images/cola.jpg",
      )
      ..addOns.addAll([
        AddOn(id: "6", name: 'Extra Ice', price: 0.25, image: ""),
        AddOn(id: "7", name: 'Lemon Slice', price: 0.10, image: ""),
      ]);
final MenuItem veggieWrap =
    MenuItem(
        id: "6",
        name: "Veggie Wrap",
        description:
            "A healthy wrap with fresh vegetables, hummus, and whole wheat tortilla.",
        prepTimeMinutes: 10,
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
