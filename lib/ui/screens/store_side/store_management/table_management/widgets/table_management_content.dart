import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/queue_table.dart';
import 'package:queue_station_app/models/restaurant/table_category.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/table_management/view_model/table_management_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/custom_dialog.dart';
import 'package:queue_station_app/ui/widgets/search_bar.dart';
import 'package:queue_station_app/ui/widgets/table_chip_category.dart';
import 'package:queue_station_app/ui/widgets/table_search_result.dart';

enum FilterOption { available, occupied, clear }

class TableManagementContent extends StatefulWidget {
  const TableManagementContent({super.key});

  @override
  State<TableManagementContent> createState() => _TableManagementContentState();
}

class _TableManagementContentState extends State<TableManagementContent> {
  // Controllers
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final TextEditingController _minSeatController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _minSeatController.dispose();
    _seatController.dispose();
    super.dispose();
  }

  // Chip Category
  void onSelectedChip(TableCategory category) {
    TableManagementViewModel vm = context.read<TableManagementViewModel>();
    vm.updateCurrentSelectedCategory(category);
    if (vm.isEditMode) {
      showEditCategoryDialog(category: category);
    }
  }

  // Edit Mode
  void onEditMode() {
    TableManagementViewModel vm = context.read<TableManagementViewModel>();
    vm.updateIsEditMode(!vm.isEditMode);
    _showSnackBar(vm.isEditMode ? "Editing Mode" : "Normal Mode");
  }

  // Filter Popup
  Widget onFilterBy() {
    TableManagementViewModel vm = context.read<TableManagementViewModel>();
    return PopupMenuButton<FilterOption>(
      tooltip: "Filter by status",
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
      icon: Icon(
        Icons.filter_list,
        color: vm.isFiltered ? AppTheme.primaryColor : AppTheme.secondaryColor,
      ),
      onSelected: (status) {
        vm.setFilter(status);
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

  void onTable({required QueueTable table, required TableStatus status}) {
    var vm = context.read<TableManagementViewModel>();
    if (vm.isEditMode) {
      showEditTableDialog(table: table);
    } else {
      showTableStatusDialog(table: table, status: status);
    }
  }

  // --- CRUD Operations ---

  void _addNewTable(String tableNum, TableCategory tableCategory) {
    var vm = context.read<TableManagementViewModel>();
    final newTable = QueueTable(
      tableNum: tableNum,
      tableStatus: TableStatus.available,
      tableCategoryId: tableCategory.id,
      queueEntryIds: [],
    );
    vm.addNewTable(newTable);

    _showSnackBar("Table $tableNum added to ${tableCategory.type}");
  }

  void _updateTable(QueueTable newTable) {
    var vm = context.read<TableManagementViewModel>();
    vm.updateTable(newTable);
  }

  void _updateTableStatus(QueueTable table, TableStatus newStatus) {
    var vm = context.read<TableManagementViewModel>();
    QueueTable newTable = table.copyWith(tableStatus: newStatus);
    vm.updateTable(newTable);
    _showSnackBar("Table ${newTable.tableNum} is ${newStatus.name}");
  }

  void _deleteTable(QueueTable table) {
    var vm = context.read<TableManagementViewModel>();
    vm.deleteTable(table);
    _showSnackBar(
      "Table ${table.tableNum} deleted",
      backgroundColor: AppTheme.accentRed,
    );
  }

  void _addNewCategory(TableCategory newCategory) {
    var vm = context.read<TableManagementViewModel>();
    vm.addNewCategory(newCategory);
    _showSnackBar("Category ${newCategory.type} added");
  }

  void _updateCategory(TableCategory newCategory) {
    var vm = context.read<TableManagementViewModel>();
    vm.updateTableCategory(newCategory);
    _showSnackBar("Category updated: ${newCategory.type}");
  }

  void _deleteCategory(TableCategory tableCategory) {
    var vm = context.read<TableManagementViewModel>();
    vm.deleteTableCategory(tableCategory);
    _showSnackBar(
      "Category ${tableCategory.type} and its tables deleted",
      backgroundColor: AppTheme.accentRed,
    );
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
    var vm = context.watch<TableManagementViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Table List"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onEditMode,
            icon: Icon(
              vm.isEditMode
                  ? Icons.cancel_presentation
                  : Icons.edit_note_rounded,
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
                Expanded(child: SearchBox(onSearch: vm.onSearch)),
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
            if (vm.tableCategories.isNotEmpty &&
                vm.currentSelectedCategory != null)
              CategoryChips(
                tableData: vm.tableCategories,
                selectedCat: vm.currentSelectedCategory!,
                onSelectedChip: onSelectedChip,
                isEditMode: vm.isEditMode,
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
                    "Category: ${vm.currentSelectedCategory?.type ?? ""}",
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
                        ": ${vm.filteredTable.length} table(s)  |",
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
                        ": ${vm.currentSelectedCategory?.seatAmount ?? ""} seat(s)",
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
              child: Selector<TableManagementViewModel, List<QueueTable>>(
                selector: (_, vm) => vm.filteredTable,
                builder: (context, filteredTables, child) {
                  return TableSearchResult(
                    allTables: filteredTables,
                    isEditMode: context
                        .read<TableManagementViewModel>()
                        .isEditMode,
                    onTable: (table, status) =>
                        onTable(table: table, status: status),
                    onAddTable: () => showAddNewUpdateTableDialog(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddNewDialog() {
    _clearControllers();
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
                showAddNewUpdateTableDialog();
              },
              color: AppTheme.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void showTableStatusDialog({
    required QueueTable table,
    required TableStatus status,
  }) {
    _clearControllers();
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Table Status",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              table.tableNum,
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
                            _updateTableStatus(table, TableStatus.available);
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
                            _updateTableStatus(table, TableStatus.occupied);
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

  void showEditTableDialog({required QueueTable table}) {
    _clearControllers();
    var vm = context.read<TableManagementViewModel>();
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Table Options",
        content: Text(
          "Table: ${table.tableNum}",
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
                  table: table,
                  tableCategory: vm.currentSelectedCategory,
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
                showDeleteCategoryTableDialog(true, table);
              },
            ),
          ),
        ],
      ),
    );
  }

  void showEditCategoryDialog({required TableCategory category}) {
    _clearControllers();
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
                showAddNewUpdateCategoryDialog(tableCategory: category);
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
                showDeleteCategoryTableDialog(false, null);
              },
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteCategoryTableDialog(bool isTable, QueueTable? table) {
    _clearControllers();
    var vm = context.read<TableManagementViewModel>();
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: "Are you sure?",
        content: Text(
          isTable && table != null
              ? "Delete Table (${table.tableNum})"
              : "This action will delete every table in the (${vm.currentSelectedCategory?.type ?? ""}) category",
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
                if (isTable && table != null) {
                  _deleteTable(table);
                } else if (vm.currentSelectedCategory != null) {
                  _deleteCategory(vm.currentSelectedCategory!);
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
    QueueTable? table,
    TableCategory? tableCategory,
  }) {
    _clearControllers();
    var vm = context.read<TableManagementViewModel>();
    final bool isUpdate = table != null && tableCategory != null;
    if (isUpdate) {
      vm.updateCurrentSelectedCategory(tableCategory);
    } else if (vm.tableCategories.isNotEmpty) {
      vm.updateCurrentSelectedCategory(vm.tableCategories.first);
    }

    _textController.text = isUpdate ? table.tableNum : "";

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => CustomDialog(
          title: isUpdate ? "Update table" : "Add new table",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<TableCategory>(
                initialValue: vm.currentSelectedCategory,
                items: vm.tableCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.type)))
                    .toList(),
                onChanged: (v) => setDialogState(() {
                  if (v != null) {
                    vm.updateCurrentSelectedCategory(v);
                  }
                }),
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
                if (isUpdate) {
                  _updateTable(table.copyWith(tableNum: _textController.text));
                } else if (vm.currentSelectedCategory != null) {
                  _addNewTable(
                    _textController.text,
                    vm.currentSelectedCategory!,
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAddNewUpdateCategoryDialog({TableCategory? tableCategory}) {
    _clearControllers();
    final bool isUpdate = tableCategory != null;
    _textController.text = isUpdate ? tableCategory.type : "";
    _seatController.text = isUpdate ? tableCategory.seatAmount.toString() : "2";

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
            const SizedBox(height: AppTheme.spacingS),
            TextFormField(
              controller: _minSeatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Min Seats",
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
                  TableCategory newCategory = tableCategory.copyWith(
                    type: _textController.text.isNotEmpty
                        ? _textController.text
                        : null,
                    minSeat: int.tryParse(_minSeatController.text) ?? 1,
                    seatAmount: int.tryParse(_seatController.text) ?? 2,
                  );
                  _updateCategory(newCategory);
                } else {
                  TableCategory newCategory = TableCategory(
                    type: _textController.text,
                    minSeat: int.tryParse(_minSeatController.text) ?? 1,
                    seatAmount: int.tryParse(_seatController.text) ?? 2,
                  );
                  _addNewCategory(newCategory);
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    _minSeatController.clear();
    _textController.clear();
    _seatController.clear();
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
