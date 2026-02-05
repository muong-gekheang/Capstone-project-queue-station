import 'package:flutter/material.dart';
import 'package:queue_station_app/model//menu_size.dart';
import 'package:queue_station_app/ui/widgets/text_field_widget.dart';

class PriceList<T> extends StatelessWidget {
  final List<T> items;
  final Map<T, TextEditingController> controllers;
  final String Function(T item) getName;
  final double Function(T item) getPrice;
  final void Function(T item, double newPrice)? onPriceChanged;
  final void Function(T item)? onDelete;

  const PriceList({
    super.key,
    required this.items,
    required this.controllers,
    required this.getName,
    required this.getPrice,
    this.onPriceChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: Center(child: Text("No items added yet")),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        final name = getName(item);
        final initialPrice = getPrice(item);

        final controller = controllers.putIfAbsent(
          item,
          () => TextEditingController(text: initialPrice.toString()),
        );

        return Dismissible(
          key: ValueKey(name + index.toString()),
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
            if (onDelete != null) onDelete!(item);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(name, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TextFieldWidget(
                    title: '',
                    textController: controller,
                    hintText: 'Price',
                    validator: (value) {
                      final newPrice = double.tryParse(value ?? '');
                      if (newPrice == null) return 'Invalid number';
                      return null;
                    },
                    onChanged: (value) {
                      final newPrice = double.tryParse(value);
                      if (newPrice != null && onPriceChanged != null) {
                        onPriceChanged!(item, newPrice);
                      }
                    },
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withAlpha(127),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
