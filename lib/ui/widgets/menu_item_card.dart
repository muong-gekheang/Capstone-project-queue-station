import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const MenuItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: item.image != null
                  ? Image.network(
                      item.image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 120,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.restaurant,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: 120,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: const Color(0xFFFF6835),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.restaurant,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    ),
            ),
            const SizedBox(height: 12),

            Text(
              item.name,
              style: const TextStyle(fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              item.sizes.isNotEmpty
                  ? '\$${item.sizes.first.price.toStringAsFixed(2)}'
                  : '\$0.00',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
