import 'package:flutter/material.dart';
import 'package:queue_station_app/old_model/table_category.dart';

class CategoryChips extends StatelessWidget {
  final List<TableCategory> tableData;
  final int selectedChipIndex;
  final Function(int) onSelectedChip;
  final bool isEditMode;
  final VoidCallback onAddChip;

  const CategoryChips({
    super.key,
    required this.tableData,
    required this.selectedChipIndex,
    required this.onSelectedChip,
    required this.isEditMode,
    required this.onAddChip,
  });

  Color getChipColor({required bool isSelected, required bool isText}) {
    if (isText) {
      return isSelected ? Colors.white : Colors.black;
    }
    return isSelected ? Color(0xFFFF6835) : Color(0xFFF1F1F1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tableData.length,
        itemBuilder: (context, index) {
          // ADD BOX
          if (isEditMode && index == 0) {
            bool isPicked = selectedChipIndex == index;

            return Row(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 8),
                  child: IconButton(
                    onPressed: onAddChip,
                    icon: Icon(Icons.add),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    label: Text(
                      tableData[index].type,
                      style: TextStyle(
                        color: getChipColor(isSelected: isPicked, isText: true),
                      ),
                    ),
                    selectedColor: const Color(0xFFFF6835),
                    backgroundColor: const Color(0xFFF1F1F1),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    selected: isPicked,
                    onSelected: (_) => onSelectedChip(index),
                    chipAnimationStyle: ChipAnimationStyle(
                      enableAnimation: AnimationStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            bool isPicked = selectedChipIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                label: Text(
                  tableData[index].type,
                  style: TextStyle(
                    color: getChipColor(isSelected: isPicked, isText: true),
                  ),
                ),
                selectedColor: const Color(0xFFFF6835),
                backgroundColor: const Color(0xFFF1F1F1),
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                selected: isPicked,
                onSelected: (_) => onSelectedChip(index),
                chipAnimationStyle: ChipAnimationStyle(
                  enableAnimation: AnimationStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
