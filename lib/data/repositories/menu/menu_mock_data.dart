import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/models/restaurant/menu_item_category.dart';
import 'package:queue_station_app/models/restaurant/menu_size.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

/// ----------------------------
/// GLOBAL SIZE OPTIONS
/// ----------------------------
final List<SizeOption> globalSizeOptions = [
  SizeOption(id: _uuid.v4(), name: 'Small'),
  SizeOption(id: _uuid.v4(), name: 'Medium'),
  SizeOption(id: _uuid.v4(), name: 'Large'),
];

/// ----------------------------
/// GLOBAL ADD-ONS
/// ----------------------------
final List<AddOn> globalAddOns = [
  AddOn(id: _uuid.v4(), name: 'Extra Cheese', price: 1.50, image: null),
  AddOn(id: _uuid.v4(), name: 'Bacon', price: 2.00, image: null),
  AddOn(id: _uuid.v4(), name: 'Avocado', price: 2.50, image: null),
  AddOn(id: _uuid.v4(), name: 'Extra Sauce', price: 0.75, image: null),
  AddOn(id: _uuid.v4(), name: 'Fried Egg', price: 1.25, image: null),
];

/// ----------------------------
/// CATEGORIES
/// ----------------------------
final List<MenuItemCategory> mockMenuCategories = [
  MenuItemCategory(id: _uuid.v4(), name: 'Burger'),
  MenuItemCategory(id: _uuid.v4(), name: 'Pizza'),
  MenuItemCategory(id: _uuid.v4(), name: 'Drinks'),
  MenuItemCategory(id: _uuid.v4(), name: 'Desserts'),
];

/// ----------------------------
/// MENU-SIZE RELATIONS (PRICE PER MENU)
/// ----------------------------
final List<MenuSize> burgerSizes = [
  MenuSize(price: 3.0, sizeOption: globalSizeOptions[0]),
  MenuSize(price: 4.0, sizeOption: globalSizeOptions[1]),
  MenuSize(price: 4.75, sizeOption: globalSizeOptions[2]),
];

final List<MenuSize> burgerMediumLarge = [
  MenuSize(price: 1.0, sizeOption: globalSizeOptions[1]),
  MenuSize(price: 1.25, sizeOption: globalSizeOptions[2]),
];

final List<MenuSize> pizzaSizes = [
  MenuSize(price: 0.0, sizeOption: globalSizeOptions[0]),
  MenuSize(price: 2.0, sizeOption: globalSizeOptions[1]),
];

/// ----------------------------
/// MENU ITEMS
/// ----------------------------
final List<MenuItem> mockMenuItems = [
  MenuItem(
      id: _uuid.v4(),
      name: 'Classic Burger',
      description: 'Classic burger with fresh lettuce, tomato, and beef patty.',
      image: 'assets/images/burger.png',
      categoryId: mockMenuCategories[0].id,
      sizeOptionIds: [
        globalSizeOptions[0].id,
        globalSizeOptions[1].id,
        globalSizeOptions[2].id,
      ],
      addOnIds: [globalAddOns[0].id, globalAddOns[1].id, globalAddOns[4].id],
      minPrepTimeMinutes: 10,
      maxPrepTimeMinutes: 15,
      isAvailable: true,
    )
    ..sizes = burgerSizes
    ..addOns = [globalAddOns[0], globalAddOns[1], globalAddOns[4]],
  MenuItem(
      id: _uuid.v4(),
      name: 'Cheese Burger',
      description:
          'Beef patty with melted cheddar cheese, pickles, and special sauce.',
      image: 'assets/images/cheeseburger.png',
      categoryId: mockMenuCategories[0].id,
      sizeOptionIds: [globalSizeOptions[1].id, globalSizeOptions[2].id],
      addOnIds: [
        globalAddOns[0].id,
        globalAddOns[1].id,
        globalAddOns[2].id,
        globalAddOns[4].id,
      ],
      minPrepTimeMinutes: 8,
      maxPrepTimeMinutes: 12,
      isAvailable: true,
    )
    ..sizes = burgerMediumLarge
    ..addOns = [
      globalAddOns[0],
      globalAddOns[1],
      globalAddOns[2],
      globalAddOns[4],
    ],
  MenuItem(
      id: _uuid.v4(),
      name: 'Pepperoni Pizza',
      description:
          'Classic pepperoni with mozzarella cheese on tomato sauce base.',
      image: 'assets/images/pizza.png',
      categoryId: mockMenuCategories[1].id,
      sizeOptionIds: [globalSizeOptions[0].id, globalSizeOptions[1].id],
      addOnIds: [
        globalAddOns[0].id,
        globalAddOns[1].id,
        globalAddOns[2].id,
        globalAddOns[3].id,
      ],
      minPrepTimeMinutes: 15,
      maxPrepTimeMinutes: 20,
      isAvailable: true,
    )
    ..sizes = pizzaSizes
    ..addOns = [
      globalAddOns[0],
      globalAddOns[1],
      globalAddOns[2],
      globalAddOns[3],
    ],
  MenuItem(
      id: _uuid.v4(),
      name: 'Margherita Pizza',
      description:
          'Simple yet delicious with fresh mozzarella, tomatoes, and basil.',
      image: 'assets/images/pizza(1).png',
      categoryId: mockMenuCategories[1].id,
      sizeOptionIds: [globalSizeOptions[1].id, globalSizeOptions[2].id],
      addOnIds: [globalAddOns[0].id, globalAddOns[3].id],
      minPrepTimeMinutes: 12,
      maxPrepTimeMinutes: 18,
      isAvailable: true,
    )
    ..sizes = [
      MenuSize(price: 2.0, sizeOption: globalSizeOptions[1]),
      MenuSize(price: 3.5, sizeOption: globalSizeOptions[2]),
    ]
    ..addOns = [globalAddOns[0], globalAddOns[3]],
  MenuItem(
    id: _uuid.v4(),
    name: 'Cola',
    description: 'Chilled soft drink, perfect with any meal.',
    image: 'assets/images/energy-drink.png',
    categoryId: mockMenuCategories[2].id,
    sizeOptionIds: [],
    addOnIds: [],
    minPrepTimeMinutes: 2,
    maxPrepTimeMinutes: 5,
    isAvailable: true,
  ),
  MenuItem(
      id: _uuid.v4(),
      name: 'Veggie Wrap',
      description:
          'A healthy wrap with fresh vegetables, hummus, and whole wheat tortilla.',
      image: 'assets/images/burger.png',
      categoryId: mockMenuCategories[0].id,
      sizeOptionIds: [globalSizeOptions[1].id, globalSizeOptions[2].id],
      addOnIds: [globalAddOns[0].id, globalAddOns[2].id, globalAddOns[3].id],
      minPrepTimeMinutes: 8,
      maxPrepTimeMinutes: 10,
      isAvailable: true,
    )
    ..sizes = burgerMediumLarge
    ..addOns = [globalAddOns[0], globalAddOns[2], globalAddOns[3]],
];

/// Legacy alias used by various UI screens.
final List<MenuItem> allMenuItems = mockMenuItems;
