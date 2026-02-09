import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/widgets/custom_dialog.dart';
import 'package:queue_station_app/ui/widgets/search_bar.dart';
import 'package:queue_station_app/ui/widgets/table_chip_category.dart';
import 'package:queue_station_app/ui/widgets/table_search_result.dart';

enum FilterOption { available, occupied, clear }

class TableManagementScreen extends StatefulWidget {
  const TableManagementScreen({super.key, required this.tableCategory});

  final List<TableCategory> tableCategory;

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  late List<TableCategory> tableData;
  late TableCategory currentCategoryTable;
  late List<QueueTable> allCurrentTable;
  late List<String> category;

  @override
  void initState() {
    super.initState();
    tableData = List.from(widget.tableCategory);
    currentCategoryTable = tableData.first;
    allCurrentTable = currentCategoryTable.tables;
    category = tableData.map((c) => c.type).toSet().toList();
  }

  //Chip Category
  int selectedChipIndex = 0;
  void onSelectedChip(int chipIndex) {
    if (isEditMode && chipIndex == selectedChipIndex) {
      // Tap on current chip in edit mode → update
      showAddNewUpdateCategoryDialog(tableCategory: tableData[chipIndex].type);
      return;
    }

    setState(() {
      selectedChipIndex = chipIndex;
      currentCategoryTable = tableData[chipIndex];
      allCurrentTable = currentCategoryTable.tables;
    });
  }

  //Search state
  String searchQuery = "";
  void onSearch(String query) {
    setState(() {
      searchQuery = query;

      print(query);

      allCurrentTable = currentCategoryTable.tables
          .where(
            (t) => t.tableNum.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    });
  }

  //Editing State
  bool isEditMode = false;

  void onEditMode() {
    setState(() {
      isEditMode = !isEditMode;

      print(isEditMode);
    });
    _showSnackBar(isEditMode ? "Editing Mode" : "Normal Mode");
  }

  bool isFiltered = false;
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
          if (status != FilterOption.clear) {
            isFiltered = true;
            allCurrentTable = currentCategoryTable.tables
                .where((t) => t.tableStatus.name == status.name)
                .toList();
          } else {
            // Clear filter
            isFiltered = false;
            allCurrentTable = currentCategoryTable.tables;
          }
          print(isFiltered);
          print(status.name);
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

  //Select Table
  void onTable({required String tableNum, required TableStatus status}) {
    setState(() {
      if (isEditMode) {
        // Show edit/delete dialog in edit mode
        showEditTableDialog(tableNum: tableNum);
      } else {
        // Show status dialog in normal mode
        showTableStatusDialog(tableNum: tableNum, status: status);
      }
    });
  }

  //Dialog
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
                //Add new Category Dialog
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
                //Add new Table Dialog
                Navigator.pop(context);
                showAddNewUpdateTableDialog(categoryTable: category);
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
    Color getStatusColor() {
      return status == TableStatus.available
          ? AppTheme.secondaryColor
          : AppTheme.primaryColor;
    }

    String statusTitle = status.name;

    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Table Status",
        content: Column(
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
              statusTitle,
              style: TextStyle(
                fontSize: AppTheme.heading1,
                fontWeight: FontWeight.bold,
                color: getStatusColor(),
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
                      //todo go to order on behalf of customer screen
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  child: CustomRecButton(
                    title: "View order",
                    color: AppTheme.secondaryColor,
                    onPressed: () {
                      //todo go to View order screen
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

  void showDeleteCategoryDialog(bool isTable, String? tableNum) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Are you sure?",
        content: Text(
          isTable
              ? "Delete Table $tableNum"
              : "Every table under this category will be deleted too.",
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontSize: AppTheme.heading3,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              child: CustomRecButton(
                title: "No",
                color: AppTheme.naturalWhite,
                textColor: AppTheme.secondaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingS),
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
          ),
        ],
      ),
    );
  }

  String? selectedCategory;
  final _textController = TextEditingController();
  final _seatController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _seatController.dispose();
  }

  // Helper method to show consistent snackbars
  void _showSnackBar(String message, {Color? backgroundColor}) {
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
          bottom: MediaQuery.of(context).size.height - 50,
          left: AppTheme.spacingXL,
          right: AppTheme.spacingXL,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
        ),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  String? validateTableNum(String? tableNum) {
    if (tableNum == null || tableNum.isEmpty) {
      return "Please input table number";
    }
    return null;
  }

  void showAddNewUpdateTableDialog({
    required List<String> categoryTable,
    String? tableNum,
    String? tableCategory,
  }) {
    bool isUpdate = tableNum != null && tableCategory != null;
    String title = isUpdate ? "Update table" : "Add new table";
    selectedCategory = isUpdate ? tableCategory : null;
    _textController.text = isUpdate ? tableNum : "";
    _seatController.text = "2"; // Default seat count
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppTheme.spacingS,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Category: ",
                  style: TextStyle(fontSize: AppTheme.bodyText),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    hint: const Text("Category"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    isDense: true,
                    isExpanded: true,
                    items: categoryTable
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    initialValue: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "No.: ",
                  style: TextStyle(fontSize: AppTheme.bodyText),
                ),
                const SizedBox(width: AppTheme.spacingXL),
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    validator: validateTableNum,
                    decoration: const InputDecoration(
                      hintText: 'eg. A101',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          CustomRecButton(
            title: isUpdate ? "Update" : "Add new",
            color: AppTheme.secondaryColor,
            onPressed: () {
              if (selectedCategory != null && _textController.text.isNotEmpty) {
                if (isUpdate) {
                  _updateTable(tableNum, _textController.text);
                } else {
                  _addNewTable(_textController.text, selectedCategory!);
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  String? validateCategoryName(String? category) {
    if (category == null || category.isEmpty) {
      return "Please input table number";
    }
    return null;
  }

  void showAddNewUpdateCategoryDialog({String? tableCategory}) {
    bool isUpdate = tableCategory != null;
    _textController.text = isUpdate ? tableCategory : "";
    String title = isUpdate ? "Update category" : "Add new category";

    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppTheme.spacingS,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Category: ",
                  style: TextStyle(fontSize: AppTheme.bodyText),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    validator: validateCategoryName,
                    decoration: const InputDecoration(
                      hintText: 'eg. A',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Seats: ",
                  style: TextStyle(fontSize: AppTheme.bodyText),
                ),
                const SizedBox(width: AppTheme.spacingXL),
                Expanded(
                  child: TextFormField(
                    controller: _seatController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'eg. 4',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
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

  IconData get editIcon =>
      isEditMode ? Icons.cancel_presentation : Icons.edit_note_rounded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Table List"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onEditMode,
            icon: Icon(editIcon),
            iconSize: AppTheme.iconSizeXl,
            color: AppTheme.secondaryColor,
          ),
          onFilterBy(),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          spacing: AppTheme.spacingL,
          children: [
            /*Search Bar */
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
            /*chip*/
            CategoryChips(
              tableData: tableData,
              selectedChipIndex: selectedChipIndex,
              onSelectedChip: onSelectedChip,
              isEditMode: isEditMode,
              onAddChip: showAddNewUpdateCategoryDialog,
            ),
            /*Table type info*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category: ${currentCategoryTable.type}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppTheme.heading2,
                  ),
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.table_restaurant_rounded,
                      size: AppTheme.iconSizeL,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: AppTheme.spacingXS),
                    Text(
                      ": ${allCurrentTable.length}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppTheme.heading2,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    const Icon(
                      Icons.chair,
                      size: AppTheme.iconSizeL,
                      color: AppTheme.secondaryColor,
                    ),
                    const SizedBox(width: AppTheme.spacingXS),
                    Text(
                      ": ${currentCategoryTable.seatAmount}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppTheme.heading2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            /*List of Tables*/
            Expanded(
              child: TableSearchResult(
                allTables: allCurrentTable,
                isEditMode: isEditMode,
                onTable: (tableNum, status) =>
                    onTable(tableNum: tableNum, status: status),
                onAddTable: () =>
                    showAddNewUpdateTableDialog(categoryTable: category),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods for CRUD Operations

  // Add new table
  void _addNewTable(String tableNum, String categoryName) {
    setState(() {
      final categoryIndex = tableData.indexWhere((c) => c.type == categoryName);
      if (categoryIndex != -1) {
        final newTable = QueueTable(
          tableNum: tableNum,
          tableStatus: TableStatus.available, // Default available
        );
        tableData[categoryIndex].tables.add(newTable);
        currentCategoryTable = tableData[selectedChipIndex];
        allCurrentTable = currentCategoryTable.tables;

        _showSnackBar(
          "Table $tableNum added successfully",
          backgroundColor: AppTheme.secondaryColor,
        );
      }
    });
  }

  // Update table
  void _updateTable(String oldTableNum, String newTableNum) {
    setState(() {
      final tableIndex = currentCategoryTable.tables.indexWhere(
        (t) => t.tableNum == oldTableNum,
      );
      if (tableIndex != -1) {
        currentCategoryTable.tables[tableIndex] = currentCategoryTable
            .tables[tableIndex]
            .copyWith(tableNum: newTableNum);

        _showSnackBar(
          "Table updated to $newTableNum",
          backgroundColor: AppTheme.secondaryColor,
        );
      }
    });
  }

  // Update table status
  void _updateTableStatus(String tableNum, TableStatus newStatus) {
    setState(() {
      final tableIndex = currentCategoryTable.tables.indexWhere(
        (t) => t.tableNum == tableNum,
      );
      if (tableIndex != -1) {
        currentCategoryTable.tables[tableIndex].tableStatus = newStatus;

        _showSnackBar(
          "Table $tableNum is now ${newStatus.name}",
          backgroundColor: newStatus == TableStatus.available
              ? AppTheme.secondaryColor
              : AppTheme.primaryColor,
        );
      }
    });
  }

  // Delete table
  void _deleteTable(String tableNum) {
    setState(() {
      currentCategoryTable.tables.removeWhere((t) => t.tableNum == tableNum);

      _showSnackBar(
        "Table $tableNum deleted",
        backgroundColor: AppTheme.accentRed,
      );
    });
  }

  // Add new category
  void _addNewCategory(String categoryName, int amountOfSeat) {
    setState(() {
      final newCategory = TableCategory(
        type: categoryName,
        tables: [],
        seatAmount: amountOfSeat,
      );
      tableData.add(newCategory);
      category = tableData.map((c) => c.type).toSet().toList();

      _showSnackBar(
        "Category $categoryName added successfully",
        backgroundColor: AppTheme.secondaryColor,
      );
    });
  }

  // Update category
  void _updateCategory(
    String oldCategoryName,
    String newCategoryName,
    int amountOfSeat,
  ) {
    setState(() {
      final categoryIndex = tableData.indexWhere(
        (c) => c.type == oldCategoryName,
      );
      if (categoryIndex != -1) {
        // Update category type
        tableData[categoryIndex] = TableCategory(
          categoryId: tableData[categoryIndex].id,
          type: newCategoryName,
          tables: tableData[categoryIndex].tables,
          seatAmount: amountOfSeat,
        );

        category = tableData.map((c) => c.type).toSet().toList();
        currentCategoryTable = tableData[selectedChipIndex];

        _showSnackBar(
          "Category updated to $newCategoryName",
          backgroundColor: AppTheme.secondaryColor,
        );
      }
    });
  }

  // Delete category
  void _deleteCategory(String categoryId) {
    setState(() {
      tableData.removeWhere((c) => c.id == categoryId);
      category = tableData.map((c) => c.type).toSet().toList();

      // Reset to first category
      if (tableData.isNotEmpty) {
        selectedChipIndex = 0;
        currentCategoryTable = tableData[0];
        allCurrentTable = currentCategoryTable.tables;
      }

      _showSnackBar("Category deleted", backgroundColor: AppTheme.accentRed);
    });
  }

  // Show edit dialog for table
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
                  categoryTable: category,
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
                showDeleteCategoryDialog(true, tableNum);
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
        textScaler: MediaQuery.textScalerOf(context),
      ),
    );
  }
}
