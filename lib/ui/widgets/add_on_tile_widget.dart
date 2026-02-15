import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/add_on.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';

class AddOnTileWidget extends StatelessWidget {
  final List<AddOn> addOns;
  final void Function(AddOn addOn)? onDelete;

  const AddOnTileWidget({
    super.key,
    required this.addOns,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (addOns.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: Center(child: Text("No add on added yet")),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: addOns.length,
      itemBuilder: (context, index) {
        final addOn = addOns[index];

        return Dismissible(
          key: ValueKey(addOn.name + index.toString()),
          direction: onDelete != null
              ? DismissDirection.endToStart
              : DismissDirection.none,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            if (onDelete != null) onDelete!(addOn);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(addOn.name, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                Text('\$${addOn.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                
              ],
            ),
          ),
        );
      },
    );
  }
}
