import 'package:queue_station_app/model/add_on.dart';
import 'package:queue_station_app/model/size_option.dart';

class MenuItem {
  final String id;
  final String? image;
  final String name;
  final String description;
  final int? prepTimeMinutes;
  final String categoryId;
  final double basePrice;
  final List<SizeOption> sizes;
  final List<AddOn> addOns;

  MenuItem({
    required this.id,
    this.image,
    required this.name,
    required this.description,
    this.prepTimeMinutes,
    required this.categoryId,
    required this.basePrice,
    this.sizes = const [],
    this.addOns = const [],
  });

  SizeOption? get defaultSize {
    if (sizes.isEmpty) return null;
    return sizes.firstWhere(
      (size) => size.isDefault,
      orElse: () => sizes.first,
    );
  }
}

// Common add-ons for burgers and other items
final commonAddOns = [
  AddOn(
    id: 'a1',
    name: 'Extra Cheese',
    price: 1.50,
    description: 'Additional cheese slice',
    image: "assets/images/cheese.png",
  ),
  AddOn(
    id: 'a2',
    name: 'Bacon Strips',
    price: 2.00,
    description: '2 strips of crispy bacon',
    image: "assets/images/bacon.png",
  ),
  AddOn(
    id: 'a3',
    name: 'Avocado',
    price: 1.75,
    description: 'Fresh avocado slices',
    image: "assets/images/avocado.png",
  ),
  AddOn(
    id: 'a4',
    name: 'Fried Egg',
    price: 1.50,
    description: 'Sunny side up egg',
    image: "assets/images/fried-egg.png",
  ),
  AddOn(
    id: 'a5',
    name: 'Guacamole',
    price: 2.50,
    description: 'Fresh guacamole spread',
    image: "assets/images/guacamole.png",
  ),
  AddOn(
    id: 'a6',
    name: 'Mushrooms',
    price: 1.25,
    description: 'Sautéed mushrooms',
    image: "assets/images/mushrooms.png",
  ),
];

final menuItems = [
  // 🍔 BURGERS (c1)
  MenuItem(
    id: 'm1',
    image: "assets/images/burger.png",
    name: 'Classic Beef Burger',
    description:
        '100% Angus beef patty with lettuce, tomato, onion, and special house sauce on a toasted brioche bun.',
    prepTimeMinutes: 10,
    categoryId: "c1",
    basePrice: 8.99,
    sizes: [
      SizeOption(
        id: 'b1_s',
        name: 'Regular',
        price: 8.99,
        isDefault: true,
        description: 'Single patty',
      ),
      SizeOption(
        id: 'b1_m',
        name: 'Large',
        price: 10.99,
        description: 'Extra patty + toppings',
      ),
      SizeOption(
        id: 'b1_l',
        name: 'Mega',
        price: 12.49,
        description: 'Double patty + extra cheese',
      ),
    ],
    addOns: commonAddOns,
  ),
  MenuItem(
    id: 'm2',
    image: "assets/images/burger(1).png",
    name: 'Grilled Chicken Burger',
    description:
        'Juicy grilled chicken breast with avocado, crisp lettuce, tomato, and garlic aioli on a whole wheat bun.',
    prepTimeMinutes: 12,
    categoryId: "c1",
    basePrice: 9.50,
    sizes: [
      SizeOption(id: 'b2_s', name: 'Regular', price: 9.50, isDefault: true),
      SizeOption(id: 'b2_m', name: 'Large', price: 11.50),
      SizeOption(id: 'b2_l', name: 'Mega', price: 13.00),
    ],
    addOns: commonAddOns,
  ),
  MenuItem(
    id: 'm3',
    image: "assets/images/burger(2).png",
    name: 'Bacon Cheese Burger',
    description:
        'Beef patty topped with crispy bacon, melted cheddar cheese, caramelized onions, and BBQ sauce.',
    prepTimeMinutes: 12,
    categoryId: "c1",
    basePrice: 10.99,
    sizes: [
      SizeOption(id: 'b3_s', name: 'Regular', price: 10.99, isDefault: true),
      SizeOption(id: 'b3_m', name: 'Large', price: 12.99),
      SizeOption(id: 'b3_l', name: 'Mega', price: 14.49),
    ],
    addOns: commonAddOns,
  ),
  MenuItem(
    id: 'm4',
    image: "assets/images/cheeseburger.png",
    name: 'Veggie Garden Burger',
    description:
        'Plant-based patty made with black beans, quinoa, and vegetables, served with fresh greens and tahini sauce.',
    prepTimeMinutes: 8,
    categoryId: "c1",
    basePrice: 8.50,
    sizes: [
      SizeOption(id: 'b4_s', name: 'Regular', price: 8.50, isDefault: true),
      SizeOption(id: 'b4_m', name: 'Large', price: 10.50),
    ],
    addOns: commonAddOns,
  ),

  // 🍕 PIZZA (c2)
  MenuItem(
    id: 'm5',
    image: "assets/images/pizza.png",
    name: 'Margherita Pizza',
    description:
        'Classic Neapolitan pizza with San Marzano tomatoes, fresh mozzarella, basil, and extra virgin olive oil.',
    prepTimeMinutes: 15,
    categoryId: "c2",
    basePrice: 12.99,
    sizes: [
      SizeOption(
        id: 'p1_s',
        name: 'Small (10")',
        price: 12.99,
        isDefault: true,
      ),
      SizeOption(id: 'p1_m', name: 'Medium (12")', price: 15.99),
      SizeOption(id: 'p1_l', name: 'Large (14")', price: 18.49),
      SizeOption(id: 'p1_xl', name: 'Family (16")', price: 20.99),
    ],
    addOns: [
      AddOn(
        id: 'p_a1',
        name: 'Extra Cheese',
        price: 2.00,
        image: "assets/images/cheese.png",
      ),
      AddOn(
        id: 'p_a2',
        name: 'Garlic Sauce',
        price: 0.75,
        image: "assets/images/sauces.png",
      ),
    ],
  ),
  MenuItem(
    id: 'm6',
    image: "assets/images/pizza(1).png",
    name: 'Pepperoni Pizza',
    description:
        'Traditional pizza topped with spicy pepperoni slices, mozzarella cheese, and tomato sauce.',
    prepTimeMinutes: 15,
    categoryId: "c2",
    basePrice: 14.99,
    sizes: [
      SizeOption(
        id: 'p2_s',
        name: 'Small (10")',
        price: 14.99,
        isDefault: true,
      ),
      SizeOption(id: 'p2_m', name: 'Medium (12")', price: 17.99),
      SizeOption(id: 'p2_l', name: 'Large (14")', price: 20.49),
    ],
  ),
  MenuItem(
    id: 'm7',
    image: "assets/images/pizza(2).png",
    name: 'BBQ Chicken Pizza',
    description:
        'Grilled chicken, red onions, cilantro, and mozzarella cheese on a smoky BBQ sauce base.',
    prepTimeMinutes: 18,
    categoryId: "c2",
    basePrice: 16.99,
    sizes: [
      SizeOption(
        id: 'p3_s',
        name: 'Small (10")',
        price: 16.99,
        isDefault: true,
      ),
      SizeOption(id: 'p3_m', name: 'Medium (12")', price: 19.99),
      SizeOption(id: 'p3_l', name: 'Large (14")', price: 22.49),
    ],
  ),
  MenuItem(
    id: 'm8',
    image: "assets/images/pizza(3).png",
    name: 'Mediterranean Veggie Pizza',
    description:
        'Artichokes, sun-dried tomatoes, olives, feta cheese, and spinach on tomato sauce.',
    prepTimeMinutes: 15,
    categoryId: "c2",
    basePrice: 15.50,
    sizes: [
      SizeOption(
        id: 'p4_s',
        name: 'Small (10")',
        price: 15.50,
        isDefault: true,
      ),
      SizeOption(id: 'p4_m', name: 'Medium (12")', price: 18.50),
      SizeOption(id: 'p4_l', name: 'Large (14")', price: 21.00),
    ],
  ),

  // 🥤 DRINKS (c3)
  MenuItem(
    id: 'm9',
    image: "assets/images/energy-drink.png",
    name: 'Sprite',
    description:
        'Crisp, refreshing lemon-lime soda. Caffeine-free and served ice cold.',
    prepTimeMinutes: 2,
    categoryId: "c3",
    basePrice: 2.50,
    sizes: [
      SizeOption(
        id: 'd1_s',
        name: 'Small (12oz)',
        price: 2.50,
        isDefault: true,
      ),
      SizeOption(id: 'd1_m', name: 'Medium (16oz)', price: 3.00),
      SizeOption(id: 'd1_l', name: 'Large (20oz)', price: 3.50),
    ],
  ),
  MenuItem(
    id: 'm10',
    image: "assets/images/energy-drink(1).png",
    name: 'Mountain Dew',
    description: 'High-energy citrus soda with a bold, unique flavor kick.',
    prepTimeMinutes: 2,
    categoryId: "c3",
    basePrice: 3.19,
    sizes: [
      SizeOption(
        id: 'd2_s',
        name: 'Small (12oz)',
        price: 3.19,
        isDefault: true,
      ),
      SizeOption(id: 'd2_m', name: 'Medium (16oz)', price: 3.69),
      SizeOption(id: 'd2_l', name: 'Large (20oz)', price: 4.19),
    ],
  ),
  MenuItem(
    id: 'm11',
    image: "assets/images/soft-drink.png",
    name: 'Coca Cola',
    description:
        'The world\'s favorite sparkling soft drink. Available in Original or Zero Sugar.',
    prepTimeMinutes: 2,
    categoryId: "c3",
    basePrice: 2.99,
    sizes: [
      SizeOption(
        id: 'd3_s',
        name: 'Small (12oz)',
        price: 2.99,
        isDefault: true,
      ),
      SizeOption(id: 'd3_m', name: 'Medium (16oz)', price: 3.49),
      SizeOption(id: 'd3_l', name: 'Large (20oz)', price: 3.99),
    ],
  ),
  MenuItem(
    id: 'm12',
    image: "assets/images/water-bottle.png",
    name: 'Mineral Water',
    description:
        'Pure, natural mineral water sourced from underground springs.',
    prepTimeMinutes: 1,
    categoryId: "c3",
    basePrice: 1.50,
    sizes: [
      SizeOption(
        id: 'd4_s',
        name: '500ml Bottle',
        price: 1.50,
        isDefault: true,
      ),
      SizeOption(id: 'd4_l', name: '1L Bottle', price: 2.50),
    ],
  ),

  // 🍰 DESSERTS (c4)
  MenuItem(
    id: 'm13',
    image: "assets/images/cake.png",
    name: 'Chocolate Lava Cake',
    description:
        'Warm chocolate cake with a molten chocolate center, served with vanilla ice cream.',
    prepTimeMinutes: 8,
    categoryId: "c4",
    basePrice: 7.99,
    sizes: [
      SizeOption(id: 'ds1_s', name: 'Single', price: 7.99, isDefault: true),
      SizeOption(id: 'ds1_m', name: 'Sharing', price: 12.99),
    ],
  ),
  MenuItem(
    id: 'm14',
    image: "assets/images/cupcake.png",
    name: 'New York Cheesecake',
    description:
        'Classic creamy cheesecake with graham cracker crust and berry compote topping.',
    prepTimeMinutes: 5,
    categoryId: "c4",
    basePrice: 6.50,
    sizes: [
      SizeOption(
        id: 'ds2_s',
        name: 'Single Slice',
        price: 6.50,
        isDefault: true,
      ),
      SizeOption(id: 'ds2_m', name: 'Double Pack', price: 11.50),
    ],
  ),
  MenuItem(
    id: 'm15',
    image: "assets/images/pancakes.png",
    name: 'Belgian Waffle',
    description:
        'Crispy Belgian waffle served with maple syrup, fresh berries, and whipped cream.',
    prepTimeMinutes: 10,
    categoryId: "c4",
    basePrice: 8.50,
    sizes: [
      SizeOption(id: 'ds3_s', name: 'Single', price: 8.50, isDefault: true),
      SizeOption(id: 'ds3_m', name: 'Double', price: 11.50),
    ],
  ),
  MenuItem(
    id: 'm16',
    image: "assets/images/panna-cotta.png",
    name: 'Tiramisu',
    description:
        'Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cream.',
    prepTimeMinutes: 5,
    categoryId: "c4",
    basePrice: 7.50,
    sizes: [
      SizeOption(
        id: 'ds4_s',
        name: 'Standard Cup',
        price: 7.50,
        isDefault: true,
      ),
      SizeOption(id: 'ds4_l', name: 'Family Bowl', price: 18.00),
    ],
  ),
];
