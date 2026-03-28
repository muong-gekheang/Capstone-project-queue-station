import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';

class TableSearchResult extends StatelessWidget {
  const TableSearchResult({
    super.key,
    required this.allTables,
    required this.isEditMode,
    required this.onTable,
    required this.onAddTable,
  });

  final List<QueueTable> allTables;
  final bool isEditMode;
  final void Function(QueueTable table, TableStatus status) onTable;
  final VoidCallback onAddTable;

  @override
  Widget build(BuildContext context) {
    if (allTables.isEmpty && !isEditMode) {
      return const Center(
        child: Text(
          "No Tables have Found",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: AppTheme.displayText2,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate number of columns: min 2, max 8
    int crossAxisCount = (screenWidth ~/ 180).clamp(2, 8);

    return Padding(
      padding: const EdgeInsets.all(0),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
        shrinkWrap: true,
        itemCount: isEditMode ? allTables.length + 1 : allTables.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppTheme.spacingL,
          mainAxisSpacing: AppTheme.spacingL,
          childAspectRatio: 150 / 120,
        ),
        itemBuilder: (context, index) {
          // ADD BOX
          if (isEditMode && index == 0) {
            return GestureDetector(
              onTap: onAddTable,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.naturalWhite,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.naturalGrey,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, size: AppTheme.iconSizeXl),
              ),
            );
          } else {
            final QueueTable table = isEditMode
                ? allTables[index - 1]
                : allTables[index];
            return TableBox(
              table: table,
              onTable: (tableNum, status) => onTable(tableNum, status),
              isEditMode: isEditMode,
            );
          }
        },
      ),
    );
  }
}

class TableBox extends StatelessWidget {
  const TableBox({
    super.key,
    required this.table,
    required this.onTable,
    required this.isEditMode,
  });

  final QueueTable table;
  final void Function(QueueTable table, TableStatus status) onTable;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    TableStatus status = table.tableStatus;

    Widget showEditIcon = isEditMode
        ? const Icon(Icons.edit_square, color: AppTheme.primaryColor)
        : const SizedBox.shrink();

    Color getStatusColor() {
      return status == TableStatus.available
          ? AppTheme.secondaryColor
          : AppTheme.primaryColor;
    }

    return GestureDetector(
      onTap: () => onTable(table, status),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.naturalWhite,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
          boxShadow: [
            const BoxShadow(
              color: AppTheme.naturalGrey,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              table.tableNum,
              style: const TextStyle(
                color: AppTheme.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: AppTheme.heading1,
              ),
            ),
            Text(
              table.tableStatus.name,
              style: TextStyle(
                fontSize: AppTheme.bodyText,
                color: getStatusColor(),
              ),
            ),

            showEditIcon,
          ],
        ),
      ),
    );
  }
}
