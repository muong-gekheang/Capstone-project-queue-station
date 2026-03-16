import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:uuid/uuid.dart';

/// ----------------------------
/// GLOBAL SIZES
/// ----------------------------
final List<SizeOption> globalSizes = [
  SizeOption(name: 'Small', id: '', restaurantId: ''),
  SizeOption(name: 'Medium', id: '', restaurantId: ''),
  SizeOption(name: 'Large', id: '', restaurantId: ''),
];

/// ----------------------------
/// GLOBAL SIZES
/// ----------------------------
final List<AddOn> globalAddOns = [
  AddOn(
    name: 'Extra Cheese',
    price: 1.50,
    image: "",
    id: Uuid().v4(),
    restaurantId: '',
  ),
  AddOn(
    name: 'Bacon',
    price: 2.00,
    image: "",
    id: Uuid().v4(),
    restaurantId: '',
  ),
  AddOn(
    name: 'Avocado',
    price: 2.50,
    image: "",
    id: Uuid().v4(),
    restaurantId: '',
  ),
  AddOn(
    name: 'Extra Sauce',
    price: 0.75,
    image: "",
    id: Uuid().v4(),
    restaurantId: '',
  ),
  AddOn(
    name: 'Fried Egg',
    price: 1.25,
    image: "",
    id: Uuid().v4(),
    restaurantId: '',
  ),
];

/// ----------------------------
/// MENU-SIZE RELATIONS (PRICE PER MENU)
/// ----------------------------
final List<MenuSize> burgerSizes = [
  MenuSize(sizeOption: globalSizes[0], price: 3.0), // Small
  MenuSize(sizeOption: globalSizes[1], price: 4.0), // Medium
  MenuSize(sizeOption: globalSizes[2], price: 4.75), // Large
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
  MenuItemCategory(name: "Burger", id: Uuid().v4()),
  MenuItemCategory(name: "Pizza", id: Uuid().v4()),
  MenuItemCategory(name: "Drinks", id: Uuid().v4()),
];

/// ----------------------------
/// ADD-ONS
/// ----------------------------
final List<AddOn> mockMenuAddOns = [
  AddOn(
    name: 'Extra Cheese',
    price: 0.99,
    image: "assets/images/cheese.png",
    id: Uuid().v4(),
    restaurantId: '',
  ),
  AddOn(
    name: 'Bacon Strips',
    price: 1.49,
    image: "assets/images/bacon.png",
    id: Uuid().v4(),
    restaurantId: '',
  ),
  AddOn(
    name: 'Avocado',
    price: 1.29,
    image: "assets/images/avocado.png",
    id: Uuid().v4(),
    restaurantId: '',
  ),
  AddOn(
    name: 'Extra Sauce',
    price: 0.59,
    image: "assets/images/sauces.png",
    id: Uuid().v4(),
    restaurantId: '',
  ),
  AddOn(
    name: 'Onion Rings',
    price: 1.99,
    image: "",
    id: Uuid().v4(),
    restaurantId: '',
  ),
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
        maxPrepTimeMinutes: 15,
        category: mockMenuCategories[0], // Burger category
        image: "assets/images/burger.png",
        isAvailable: true,
        id: Uuid().v4(),
        restaurantId: '',
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
        id: Uuid().v4(),
        name: "Cheese Burger",
        description:
            "Beef patty with melted cheddar cheese, pickles, and special sauce.",
        maxPrepTimeMinutes: 12,
        category: mockMenuCategories[0], // Burger category
        image: "assets/images/cheeseburger.png",
        isAvailable: true,
        restaurantId: '',
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
        id: Uuid().v4(),
        name: "Pepperoni Pizza",
        description:
            "Classic pepperoni with mozzarella cheese on tomato sauce base.",
        maxPrepTimeMinutes: 20,
        category: mockMenuCategories[1], // Pizza category
        image: "assets/images/pizza.png",
        isAvailable: true,
        restaurantId: '',
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
        id: Uuid().v4(),
        name: "Margherita Pizza",
        description:
            "Simple yet delicious with fresh mozzarella, tomatoes, and basil.",
        maxPrepTimeMinutes: 18,
        category: mockMenuCategories[1], // Pizza category
        image: "assets/images/pizza(1).png",
        isAvailable: true,
        restaurantId: '',
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
        id: Uuid().v4(),
        name: "Cola",
        description: "Chilled soft drink, perfect with any meal.",
        maxPrepTimeMinutes: 2,
        category: mockMenuCategories[2], // Drinks category
        image: "assets/images/energy-drink.png",
        isAvailable: true,
        restaurantId: '',
      )
      ..addOns.addAll([
        AddOn(
          name: 'Extra Ice',
          price: 0.25,
          image: "",
          id: Uuid().v4(),
          restaurantId: '',
        ),
        AddOn(
          name: 'Lemon Slice',
          price: 0.10,
          image: "",
          id: Uuid().v4(),
          restaurantId: '',
        ),
      ]);
final MenuItem veggieWrap =
    MenuItem(
        id: Uuid().v4(),
        name: "Veggie Wrap",
        description:
            "A healthy wrap with fresh vegetables, hummus, and whole wheat tortilla.",
        maxPrepTimeMinutes: 10,
        category:
            mockMenuCategories[0], // Burger category (or you can create a new category 'Wraps')
        image: "assets/images/burger.png",
        isAvailable: true,
        restaurantId: '',
      )
      ..sizes.addAll(burgerMediumLarge)
      ..addOns.addAll([
        globalAddOns[0], // Extra Cheese
        globalAddOns[2], // Avocado
        globalAddOns[3], // Extra Sauce
      ]);

// List of all menu items
final List<MenuItem> mockMenuItems = [
  classicBurger,
  cheeseBurger,
  pepperoniPizza,
  margheritaPizza,
  cola,
  veggieWrap,
];
