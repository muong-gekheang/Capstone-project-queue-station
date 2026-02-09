import 'package:flutter/material.dart';

class FoodItemCard extends StatelessWidget {
  final String name;
  final String? image;
  final String? size;
  final Map<String, double> addons;
  final double price;
  final int quantity;
  final String? note;
  final bool isEditable;
  final VoidCallback? onEdit;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const FoodItemCard({
    super.key,
    required this.name,
    required this.addons,
    required this.price,
    required this.quantity,
    required this.isEditable,
    this.image,
    this.size,
    this.note,
    this.onEdit,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(Icons.restaurant, color: Colors.grey[400]),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6835),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (size != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Size:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${size!} ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Quantity:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (isEditable)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: quantity > 1
                                  ? const Color(0xFFFF6835)
                                  : Colors.grey.shade300,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.remove_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: onDecrease,
                            ),
                          ),

                          const SizedBox(width: 2),

                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6835),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.add_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: onIncrease,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),

          if (addons.isNotEmpty || (note != null && note!.isNotEmpty)) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (addons.isNotEmpty) ...[
                    Text(
                      "Add-ons:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: addons.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final addon = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${index + 1}. ${addon.key}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+\$${addon.value.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFF6835),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  if (note != null && note!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      "Note:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    Text(
                      "$note",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
