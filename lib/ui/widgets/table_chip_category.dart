import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:queue_station_app/ui/app_theme.dart';

class CategoryChips extends StatelessWidget {
  final List<TableCategory> tableData;
  final int selectedChipIndex;
  final Function(int) onSelectedChip;
  final bool isEditMode;
  final Function(String?) onAddChip;

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
      return isSelected ? AppTheme.naturalWhite : AppTheme.naturalBlack;
    }
    return isSelected ? AppTheme.primaryColor : AppTheme.naturalGrey;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppTheme.spacingXL,
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
                  padding: EdgeInsetsGeometry.only(right: AppTheme.spacingS),
                  child: IconButton(
                    onPressed: () => onAddChip(null),
                    icon: const Icon(Icons.add),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: ChoiceChip(
                    side: BorderSide(color: AppTheme.naturalGrey),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingS,
                    ),
                    label: Text(
                      tableData[index].type,
                      style: TextStyle(
                        color: getChipColor(isSelected: isPicked, isText: true),
                      ),
                    ),
                    selectedColor: AppTheme.primaryColor,
                    backgroundColor: AppTheme.naturalGrey,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusL,
                      ),
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
              padding: const EdgeInsets.only(right: AppTheme.spacingS),
              child: ChoiceChip(
                side: BorderSide(color: AppTheme.naturalGrey),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                ),
                label: Text(
                  tableData[index].type,
                  style: TextStyle(
                    color: getChipColor(isSelected: isPicked, isText: true),
                  ),
                ),
                selectedColor: AppTheme.primaryColor,
                backgroundColor: AppTheme.naturalGrey,
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
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
