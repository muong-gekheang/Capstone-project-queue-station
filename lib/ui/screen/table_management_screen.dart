import 'package:flutter/material.dart';
import 'package:queue_station_app/model/table.dart';
import 'package:queue_station_app/model/table_category.dart';
import 'package:queue_station_app/ui/widgets/custom_dialog.dart';
import 'package:queue_station_app/ui/widgets/search_bar.dart';
import 'package:queue_station_app/ui/widgets/table_chip_category.dart';
import 'package:queue_station_app/ui/widgets/table_search_result.dart';

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
    setState(() {
      selectedChipIndex = chipIndex;

      currentCategoryTable = tableData[chipIndex];
      allCurrentTable = currentCategoryTable.tables;

      print(chipIndex.toString());
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

  //Select Table
  void onTable({required String tableNum, required bool status}) {
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
        content: SizedBox(height: 10),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomRecButton(
              title: "Table Category",
              onPressed: () {
                //Add new Category Dialog
                Navigator.pop(context);
                showAddNewUpdateCategoryDialog(tableCategory: null);
              },
              color: Color(0xFF0D47A1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomRecButton(
              title: "Table",
              onPressed: () {
                //Add new Table Dialog
                Navigator.pop(context);
                showAddNewUpdateTableDialog(categoryTable: category);
              },
              color: Color(0xFF0D47A1),
            ),
          ),
        ],
      ),
    );
  }

  //todo
  void showTableStatusDialog({required String tableNum, required bool status}) {
    //!testing Status parameter
    Color getStatusColor() {
      return status ? Color(0xFF0D47A1) : Color(0xFFFF6835);
    }

    String statusTitle = status ? "Available" : "Occupied";

    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Table Status",
        content: Column(
          children: [
            Text(
              tableNum,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              statusTitle,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: getStatusColor(),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.7).clamp(0.0, 310.0),
            child: Column(
              spacing: 0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  spacing: 0,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomRecButton(
                          title: "Available",
                          color: Color(0xFF0D47A1),
                          onPressed: () {
                            Navigator.pop(context);
                            _updateTableStatus(tableNum, true);
                          },
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomRecButton(
                          title: "Occupied",
                          color: Color(0xFFFF6835),
                          onPressed: () {
                            Navigator.pop(context);
                            _updateTableStatus(tableNum, false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomRecButton(
                    title: "Order on behalf",
                    color: Color(0xFF0D47A1),
                    onPressed: () {
                      //todo go to order on behalf of customer screen
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomRecButton(
                    title: "View order",
                    color: Color(0xFF0D47A1),
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

  //todo
  void showDeleteCategoryDialog(bool isTable, String? tableNum) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Are you sure?",
        content: Text(
          isTable
              ? "Delete Table $tableNum"
              : "Every table under this category will be deleted too.",
          style: TextStyle(color: Color(0xFFFF6835), fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomRecButton(
                title: "No",
                color: Colors.white,
                textColor: Color(0xFF0D47A1),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomRecButton(
                title: "Delete",
                color: Color(0xFFB22222),
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

  //todo showdialog add table and add categroy
  //todo
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
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: backgroundColor ?? Color(0xFF0D47A1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 50,
          left: 100,
          right: 100,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Category: ", style: TextStyle(fontSize: 15)),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    hint: Text("Select a category"),
                    decoration: InputDecoration(border: OutlineInputBorder()),
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
                Text("No.: ", style: TextStyle(fontSize: 15)),
                const SizedBox(width: 55),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Seats: ", style: TextStyle(fontSize: 15)),
                const SizedBox(width: 50),
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
            color: Color(0xFF0D47A1),
            onPressed: () {
              if (selectedCategory != null && _textController.text.isNotEmpty) {
                if (isUpdate) {
                  _updateTable(tableNum, _textController.text);
                } else {
                  _addNewTable(
                    _textController.text,
                    selectedCategory!,
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

  //todo
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

    //todo add update
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: title,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Category: ", style: TextStyle(fontSize: 15)),
                const SizedBox(width: 16),
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
          ],
        ),
        actions: [
          CustomRecButton(
            title: isUpdate ? "Update" : "Add new",
            color: Color(0xFF0D47A1),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (isUpdate) {
                  _updateCategory(tableCategory, _textController.text);
                } else {
                  _addNewCategory(_textController.text);
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
        title: Text("Table List"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onEditMode,
            icon: Icon(editIcon),
            iconSize: 30,
            color: Color(0xFF0D47A1),
          ),
          IconButton(
            onPressed: () => showDeleteCategoryDialog(false, null),
            icon: Icon(Icons.system_security_update_good_outlined),
            iconSize: 30,
            color: Color(0xFF0D47A1),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          children: [
            /*Search Bar */
            Row(
              children: [
                Expanded(child: SearchBox(onSearch: onSearch)),
                const SizedBox(width: 10),
                SizedBox(
                  width: 110,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: showAddNewDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                    ),
                    child: const Text(
                      "Add New",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
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
                  "Type: ${currentCategoryTable.type}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "Seat(s): ${currentCategoryTable.numofTable.toString()}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
  void _addNewTable(String tableNum, String categoryName, int seats) {
    setState(() {
      final categoryIndex = tableData.indexWhere((c) => c.type == categoryName);
      if (categoryIndex != -1) {
        final newTable = QueueTable(
          tableNum: tableNum,
          seat: seats,
          isTableStatus: true, // Default available
        );
        tableData[categoryIndex].tables.add(newTable);
        currentCategoryTable = tableData[selectedChipIndex];
        allCurrentTable = currentCategoryTable.tables;

        _showSnackBar(
          "Table $tableNum added successfully",
          backgroundColor: Colors.green,
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
          backgroundColor: Colors.green,
        );
      }
    });
  }

  // Update table status
  void _updateTableStatus(String tableNum, bool newStatus) {
    setState(() {
      final tableIndex = currentCategoryTable.tables.indexWhere(
        (t) => t.tableNum == tableNum,
      );
      if (tableIndex != -1) {
        currentCategoryTable.tables[tableIndex].isTableStatus = newStatus;

        _showSnackBar(
          "Table $tableNum is now ${newStatus ? 'Available' : 'Occupied'}",
          backgroundColor: newStatus ? Colors.green : Colors.orange,
        );
      }
    });
  }

  // Delete table
  void _deleteTable(String tableNum) {
    setState(() {
      currentCategoryTable.tables.removeWhere((t) => t.tableNum == tableNum);

      _showSnackBar("Table $tableNum deleted", backgroundColor: Colors.red);
    });
  }

  // Add new category
  void _addNewCategory(String categoryName) {
    setState(() {
      final newCategory = TableCategory(type: categoryName, tables: []);
      tableData.add(newCategory);
      category = tableData.map((c) => c.type).toSet().toList();

      _showSnackBar(
        "Category $categoryName added successfully",
        backgroundColor: Colors.green,
      );
    });
  }

  // Update category
  void _updateCategory(String oldCategoryName, String newCategoryName) {
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
        );

        category = tableData.map((c) => c.type).toSet().toList();
        currentCategoryTable = tableData[selectedChipIndex];

        _showSnackBar(
          "Category updated to $newCategoryName",
          backgroundColor: Colors.green,
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

      _showSnackBar("Category deleted", backgroundColor: Colors.red);
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomRecButton(
              title: "Edit",
              color: Color(0xFF0D47A1),
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
            padding: const EdgeInsets.all(8.0),
            child: CustomRecButton(
              title: "Delete",
              color: Color(0xFFB22222),
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
    this.textColor = Colors.white,
  });

  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 48),
        backgroundColor: color,
        // side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
