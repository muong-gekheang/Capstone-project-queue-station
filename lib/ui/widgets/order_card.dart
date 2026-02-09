import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String name;
  final String? image;
  final String? size;
  final List<String> addons;
  final double price;
  final int quantity;
  final String? note;
  final bool isEditable;
  final VoidCallback? onEdit;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const OrderCard({
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
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                          child: Image.asset(image!, fit: BoxFit.cover),
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
                              style: TextStyle(fontSize: 16),
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
                        color: Color(0xFFFF6835),
                      ),
                    ),

                    const SizedBox(height: 8),

                    isEditable
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  size: 24,
                                  color: quantity <= 1
                                      ? Colors.grey
                                      : Color(0xFFFF6835),
                                ),
                                onPressed: onDecrease,
                              ),
                              Container(
                                width: 15,
                                alignment: Alignment.center,
                                child: Text(
                                  '$quantity',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  size: 24,
                                  color: Color(0xFFFF6835),
                                ),
                                onPressed: onIncrease,
                              ),
                            ],
                          )
                        : Text(
                            'x $quantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),

          if (addons.isNotEmpty || (note != null && note!.isNotEmpty)) ...[
            const Divider(height: 1),

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
                    Text(
                      " ${addons.join(', ')}",
                      style: TextStyle(fontSize: 14),
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
                    Text("$note", style: TextStyle(fontSize: 14)),
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
