import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/custom_dialog.dart';
import 'package:queue_station_app/ui/widgets/search_bar.dart';
import 'package:queue_station_app/ui/widgets/table_chip_category.dart';
import 'package:queue_station_app/ui/widgets/table_search_result.dart';

enum FilterOption { available, occupied, clear }

class TableManagementScreen extends StatefulWidget {
  const TableManagementScreen({super.key, required this.initialTables});
  final List<QueueTable> initialTables;

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  // Master Data
  late List<TableCategory> tableCategories;
  late List<QueueTable> allTables;

  // State for currently viewed data
  late TableCategory currentCategoryTable;
  late List<QueueTable> filteredTables;

  late List<String> categoryNames;
  int selectedChipIndex = 0;
  String searchQuery = "";
  FilterOption currentFilter = FilterOption.clear;
  bool isFiltered = false;
  bool isEditMode = false;

  // Controllers
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    allTables = List.from(widget.initialTables);
    tableCategories = List.from(
      widget.initialTables.map((t) => t.tableCategory).toSet().toList(),
    );

    if (tableCategories.isNotEmpty) {
      currentCategoryTable = tableCategories.first;
      categoryNames = tableCategories.map((c) => c.type).toList();
    } else {
      // Create default category if none exists
      final defaultCategory = TableCategory(type: 'Standard', seatAmount: 4);
      tableCategories = [defaultCategory];
      currentCategoryTable = defaultCategory;
      categoryNames = [defaultCategory.type];
    }

    _applyFilters();
  }

  @override
  void dispose() {
    _textController.dispose();
    _seatController.dispose();
    super.dispose();
  }

  // Central logic to update what is shown on screen
  void _applyFilters() {
    setState(() {
      // 1. Filter by the selected Category
      var result = allTables
          .where((t) => t.tableCategory.id == currentCategoryTable.id)
          .toList();

      // 2. Filter by Search Query
      if (searchQuery.isNotEmpty) {
        result = result
            .where(
              (t) =>
                  t.tableNum.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
      }

      // 3. Filter by Status
      if (isFiltered && currentFilter != FilterOption.clear) {
        result = result.where((t) {
          if (currentFilter == FilterOption.available) {
            return t.tableStatus == TableStatus.available;
          } else if (currentFilter == FilterOption.occupied) {
            return t.tableStatus == TableStatus.occupied;
          }
          return true;
        }).toList();
      }

      filteredTables = result;
    });
  }

  // Chip Category
  void onSelectedChip(int chipIndex) {
    if (isEditMode && chipIndex == selectedChipIndex) {
      setState(() {
        selectedChipIndex = chipIndex;
        currentCategoryTable = tableCategories[chipIndex];
        _applyFilters();
      });

      showEditCategoryDialog(category: tableCategories[chipIndex]);
      return;
    }

    setState(() {
      selectedChipIndex = chipIndex;
      currentCategoryTable = tableCategories[chipIndex];
      _applyFilters();
    });
  }

  // Search
  void onSearch(String query) {
    searchQuery = query;
    _applyFilters();
  }

  // Edit Mode
  void onEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
    _showSnackBar(isEditMode ? "Editing Mode" : "Normal Mode");
  }

  // Filter Popup
  Widget onFilterBy() {
    return PopupMenuButton<FilterOption>(
      tooltip: "Filter by status",
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      icon: Icon(
        Icons.filter_list,
        color: isFiltered ? AppTheme.primaryColor : AppTheme.secondaryColor,
      ),
      onSelected: (status) {
        setState(() {
          currentFilter = status;
          isFiltered = status != FilterOption.clear;
          _applyFilters();
        });
      },
      itemBuilder: (context) => const [
        PopupMenuItem<FilterOption>(
          value: FilterOption.available,
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppTheme.secondaryColor),
              SizedBox(width: AppTheme.spacingS),
              Text("Available"),
            ],
          ),
        ),
        PopupMenuItem<FilterOption>(
          value: FilterOption.occupied,
          child: Row(
            children: [
              Icon(Icons.cancel_outlined, color: AppTheme.primaryColor),
              SizedBox(width: AppTheme.spacingS),
              Text("Occupied"),
            ],
          ),
        ),
        PopupMenuItem<FilterOption>(
          value: FilterOption.clear,
          child: Row(
            children: [
              Icon(Icons.clear, color: AppTheme.naturalTextGrey),
              SizedBox(width: AppTheme.spacingS),
              Text("Clear filter"),
            ],
          ),
        ),
      ],
    );
  }

  void onTable({required String tableNum, required TableStatus status}) {
    if (isEditMode) {
      showEditTableDialog(tableNum: tableNum);
    } else {
      showTableStatusDialog(tableNum: tableNum, status: status);
    }
  }

  // --- CRUD Operations ---

  void _addNewTable(String tableNum, String categoryName) {
    setState(() {
      final categoryObj = tableCategories.firstWhere(
        (c) => c.type == categoryName,
      );
      final newTable = QueueTable(
        tableNum: tableNum,
        tableStatus: TableStatus.available,
        tableCategory: categoryObj,
        currentQueueEntryId: null,
        occupiedSince: null,
      );
      allTables.add(newTable);
      _applyFilters();
      _showSnackBar("Table $tableNum added to $categoryName");
    });
  }

  void _updateTable(
    String oldTableNum,
    String newTableNum,
    String newCategoryName,
  ) {
    setState(() {
      final index = allTables.indexWhere(
        (t) =>
            t.tableNum == oldTableNum &&
            t.tableCategory.id == currentCategoryTable.id,
      );

      if (index != -1) {
        final newCategoryObj = tableCategories.firstWhere(
          (c) => c.type == newCategoryName,
        );

        allTables[index] = allTables[index].copyWith(
          tableNum: newTableNum,
          tableCategory: newCategoryObj,
        );

        _applyFilters();
        _showSnackBar("Table updated and moved to $newCategoryName");
      }
    });
  }

  void _updateTableStatus(String tableNum, TableStatus newStatus) {
    setState(() {
      final index = allTables.indexWhere(
        (t) =>
            t.tableNum == tableNum &&
            t.tableCategory.id == currentCategoryTable.id,
      );

      if (index != -1) {
        allTables[index] = allTables[index].copyWith(
          tableStatus: newStatus,
          currentQueueEntryId: newStatus == TableStatus.occupied
              ? allTables[index].currentQueueEntryId
              : null,
          occupiedSince: newStatus == TableStatus.occupied
              ? DateTime.now()
              : null,
        );
        _applyFilters();
        _showSnackBar("Table $tableNum is ${newStatus.name}");
      }
    });
  }

  void _deleteTable(String tableNum) {
    setState(() {
      allTables.removeWhere(
        (t) =>
            t.tableNum == tableNum &&
            t.tableCategory.id == currentCategoryTable.id,
      );
      _applyFilters();
      _showSnackBar(
        "Table $tableNum deleted",
        backgroundColor: AppTheme.accentRed,
      );
    });
  }

  void _addNewCategory(String categoryName, int amountOfSeat) {
    setState(() {
      final newCategory = TableCategory(
        type: categoryName,
        seatAmount: amountOfSeat,
      );
      tableCategories.add(newCategory);
      categoryNames = tableCategories.map((c) => c.type).toList();
      _showSnackBar("Category $categoryName added");
    });
  }

  void _updateCategory(
    String oldCategoryName,
    String newCategoryName,
    int amountOfSeat,
  ) {
    setState(() {
      final index = tableCategories.indexWhere(
        (c) => c.type == oldCategoryName,
      );

      if (index != -1) {
        final updatedCategory = TableCategory(
          categoryId: tableCategories[index].id,
          type: newCategoryName,
          seatAmount: amountOfSeat,
        );

        tableCategories[index] = updatedCategory;

        // Update all tables with this category
        for (int i = 0; i < allTables.length; i++) {
          if (allTables[i].tableCategory.id == tableCategories[index].id) {
            allTables[i] = allTables[i].copyWith(
              tableCategory: updatedCategory,
            );
          }
        }

        categoryNames = tableCategories.map((c) => c.type).toList();

        if (selectedChipIndex == index) {
          currentCategoryTable = updatedCategory;
        }

        _applyFilters();
        _showSnackBar("Category updated: $newCategoryName");
      }
    });
  }

  void _deleteCategory(String categoryId) {
    setState(() {
      tableCategories.removeWhere((c) => c.id == categoryId);
      allTables.removeWhere((t) => t.tableCategory.id == categoryId);
      categoryNames = tableCategories.map((c) => c.type).toList();

      if (tableCategories.isNotEmpty) {
        selectedChipIndex = 0;
        currentCategoryTable = tableCategories[0];
        _applyFilters();
      } else {
        // Create default category if all are deleted
        final defaultCategory = TableCategory(type: 'Standard', seatAmount: 4);
        tableCategories = [defaultCategory];
        currentCategoryTable = defaultCategory;
        categoryNames = [defaultCategory.type];
        filteredTables = [];
      }

      _showSnackBar(
        "Category and its tables deleted",
        backgroundColor: AppTheme.accentRed,
      );
    });
  }

  // --- Dialogs & UI Helpers ---

  void _showSnackBar(String message, {Color? backgroundColor}) {
    double screenHeight = MediaQuery.of(context).size.height;
    double snackBarEstimatedHeight = AppTheme.spacingXL;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: AppTheme.naturalWhite,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: backgroundColor ?? AppTheme.secondaryColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: (screenHeight - 150).clamp(
            0.0,
            screenHeight - snackBarEstimatedHeight,
          ),
          left: AppTheme.spacingXL,
          right: AppTheme.spacingXL,
        ),
        // margin: const EdgeInsets.all(AppTheme.spacingXL),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Table List"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onEditMode,
            icon: Icon(
              isEditMode ? Icons.cancel_presentation : Icons.edit_note_rounded,
            ),
            iconSize: AppTheme.iconSizeXl,
            color: AppTheme.secondaryColor,
          ),
          onFilterBy(),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          spacing: AppTheme.spacingL,
          children: [
            Row(
              children: [
                Expanded(child: SearchBox(onSearch: onSearch)),
                const SizedBox(width: AppTheme.spacingS),
                SizedBox(
                  width: 110,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: showAddNewDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                    ),
                    child: const Text(
                      "Add New",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppTheme.smallText,
                        color: AppTheme.naturalWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CategoryChips(
              tableData: tableCategories,
              selectedChipIndex: selectedChipIndex,
              onSelectedChip: onSelectedChip,
              isEditMode: isEditMode,
              onAddChip: (name) =>
                  showAddNewUpdateCategoryDialog(tableCategory: name),
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 10,
                children: [
                  Text(
                    "Category: ${currentCategoryTable.type}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppTheme.heading2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.table_restaurant_rounded,
                        size: AppTheme.iconSizeL,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: AppTheme.spacingXS),
                      Text(
                        ": ${filteredTables.length} table(s)  |",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppTheme.heading2,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      const Icon(
                        Icons.chair,
                        size: AppTheme.iconSizeL,
                        color: AppTheme.secondaryColor,
                      ),
                      const SizedBox(width: AppTheme.spacingXS),
                      Text(
                        ": ${currentCategoryTable.seatAmount} seat(s)",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppTheme.heading2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TableSearchResult(
                allTables: filteredTables,
                isEditMode: isEditMode,
                onTable: (tableNum, status) =>
                    onTable(tableNum: tableNum, status: status),
                onAddTable: () =>
                    showAddNewUpdateTableDialog(categoryTable: categoryNames),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddNewDialog() {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "What do you want to add new?",
        content: const SizedBox(height: AppTheme.spacingM),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            child: CustomRecButton(
              title: "Table Category",
              onPressed: () {
                Navigator.pop(context);
                showAddNewUpdateCategoryDialog(tableCategory: null);
              },
              color: AppTheme.secondaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: CustomRecButton(
              title: "Table",
              onPressed: () {
                Navigator.pop(context);
                showAddNewUpdateTableDialog(categoryTable: categoryNames);
              },
              color: AppTheme.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void showTableStatusDialog({
    required String tableNum,
    required TableStatus status,
  }) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Table Status",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tableNum,
              style: const TextStyle(
                fontSize: AppTheme.displayText2,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              status.name,
              style: TextStyle(
                fontSize: AppTheme.heading1,
                fontWeight: FontWeight.bold,
                color: status == TableStatus.available
                    ? AppTheme.secondaryColor
                    : AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.6).clamp(0.0, 450.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingXS),
                        child: CustomRecButton(
                          title: "Available",
                          color: AppTheme.secondaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                            _updateTableStatus(tableNum, TableStatus.available);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingXS),
                        child: CustomRecButton(
                          title: "Occupied",
                          color: AppTheme.primaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                            _updateTableStatus(tableNum, TableStatus.occupied);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  child: CustomRecButton(
                    title: "Order on behalf",
                    color: AppTheme.secondaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implement order on behalf
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  child: CustomRecButton(
                    title: "View order",
                    color: AppTheme.secondaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implement view order
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showEditTableDialog({required String tableNum}) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Table Options",
        content: Text(
          "Table: $tableNum",
          style: const TextStyle(
            fontSize: AppTheme.heading3,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            child: CustomRecButton(
              title: "Edit",
              color: AppTheme.secondaryColor,
              onPressed: () {
                Navigator.pop(context);
                showAddNewUpdateTableDialog(
                  categoryTable: categoryNames,
                  tableNum: tableNum,
                  tableCategory: currentCategoryTable.type,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            child: CustomRecButton(
              title: "Delete",
              color: AppTheme.accentRed,
              onPressed: () {
                Navigator.pop(context);
                showDeleteCategoryTableDialog(true, tableNum, null);
              },
            ),
          ),
        ],
      ),
    );
  }

  void showEditCategoryDialog({required TableCategory category}) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Category Options",
        content: Text(
          "Category: ${category.type}",
          style: const TextStyle(
            fontSize: AppTheme.heading3,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            child: CustomRecButton(
              title: "Edit",
              color: AppTheme.secondaryColor,
              onPressed: () {
                Navigator.pop(context);
                showAddNewUpdateCategoryDialog(tableCategory: category.type);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            child: CustomRecButton(
              title: "Delete",
              color: AppTheme.accentRed,
              onPressed: () {
                Navigator.pop(context);
                showDeleteCategoryTableDialog(false, null, category.type);
              },
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteCategoryTableDialog(
    bool isTable,
    String? tableNum,
    String? categoryName,
  ) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Are you sure?",
        content: Text(
          isTable
              ? "Delete Table ($tableNum)"
              : "This action will delete every table in the ($categoryName) category",
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontSize: AppTheme.heading3,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Expanded(
            child: CustomRecButton(
              title: "No",
              color: AppTheme.naturalWhite,
              textColor: AppTheme.secondaryColor,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: CustomRecButton(
              title: "Delete",
              color: AppTheme.accentRed,
              onPressed: () {
                if (isTable) {
                  _deleteTable(tableNum!);
                } else {
                  _deleteCategory(currentCategoryTable.id);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void showAddNewUpdateTableDialog({
    required List<String> categoryTable,
    String? tableNum,
    String? tableCategory,
  }) {
    final bool isUpdate = tableNum != null && tableCategory != null;
    selectedCategory = isUpdate
        ? tableCategory
        : (categoryTable.isNotEmpty ? categoryTable.first : null);
    _textController.text = isUpdate ? tableNum : "";

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => CustomDialog(
          title: isUpdate ? "Update table" : "Add new table",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                items: categoryTable
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setDialogState(() => selectedCategory = v),
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: "Table No.",
                  hintText: 'eg. A101',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            CustomRecButton(
              title: isUpdate ? "Update" : "Add new",
              color: AppTheme.secondaryColor,
              onPressed: () {
                if (selectedCategory != null &&
                    _textController.text.isNotEmpty) {
                  if (isUpdate) {
                    _updateTable(
                      tableNum,
                      _textController.text,
                      selectedCategory!,
                    );
                  } else {
                    _addNewTable(_textController.text, selectedCategory!);
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAddNewUpdateCategoryDialog({String? tableCategory}) {
    final bool isUpdate = tableCategory != null;
    _textController.text = isUpdate ? tableCategory : "";
    _seatController.text = isUpdate
        ? currentCategoryTable.seatAmount.toString()
        : "2";

    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: isUpdate ? "Update category" : "Add new category",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "Category Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            TextFormField(
              controller: _seatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Seats",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          CustomRecButton(
            title: isUpdate ? "Update" : "Add new",
            color: AppTheme.secondaryColor,
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (isUpdate) {
                  _updateCategory(
                    tableCategory,
                    _textController.text,
                    int.tryParse(_seatController.text) ?? 2,
                  );
                } else {
                  _addNewCategory(
                    _textController.text,
                    int.tryParse(_seatController.text) ?? 2,
                  );
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

// CustomRecButton
class CustomRecButton extends StatelessWidget {
  const CustomRecButton({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed,
    this.textColor = AppTheme.naturalWhite,
  });

  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(AppTheme.spacingS),
        backgroundColor: color,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusS),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: AppTheme.smallText,
        ),
      ),
    );
  }
}
