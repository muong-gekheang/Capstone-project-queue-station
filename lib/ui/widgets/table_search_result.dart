import 'package:flutter/material.dart';
import 'package:queue_station_app/old_model/queue_table.dart';

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
  final void Function(String tableNum, bool status) onTable;
  final VoidCallback onAddTable;

  //   @override
  //   Widget build(BuildContext context) {
  //     return allTables.isNotEmpty
  //         ? SingleChildScrollView(
  //             child: Align(
  //               alignment: Alignment.topCenter,
  //               child: Wrap(
  //                 spacing: 10,
  //                 runSpacing: 10,
  //                 children: [
  //                   ...allTables.map((t) {
  //                     return Container(
  //                       // margin: EdgeInsets.all(10),
  //                       height: 120,
  //                       width: 150,
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(20),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.grey,
  //                             spreadRadius: 2,
  //                             blurRadius: 2,
  //                             offset: Offset(2, 2),
  //                           ),
  //                         ],
  //                       ),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             t.tableNum,
  //                             style: TextStyle(
  //                               color: Color(0xFF0D47A1),
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 30,
  //                             ),
  //                           ),
  //                           Text(
  //                             t.isTableStatus ? "Available" : "Occupied",
  //                             style: TextStyle(fontSize: 15),
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   }),
  //                 ],
  //               ),
  //             ),
  //           )
  //         : Center(
  //             child: Text(
  //               "No Tables have Found",
  //               style: TextStyle(
  //                 color: Color(0xFFFF6835),
  //                 fontSize: 40,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           );
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    if (allTables.isEmpty) {
      return Center(
        child: Text(
          "No Tables have Found",
          style: TextStyle(
            color: Color(0xFFFF6835),
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate number of columns: min 2, max 8
    int crossAxisCount = (screenWidth ~/ 170).clamp(2, 8);

    //todo fix index of items

    return Padding(
      padding: const EdgeInsets.all(0),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        itemCount: allTables.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio:
              150 / 120, // width / height of your previous container
        ),
        itemBuilder: (context, index) {
          // ADD BOX
          if (isEditMode && index == 0) {
            return GestureDetector(
              onTap: onAddTable,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 30),
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
  final void Function(String tableNum, bool status) onTable;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    String tableNum = table.tableNum;
    bool status = table.isTableStatus;

    Widget showEditIcon = isEditMode
        ? Icon(Icons.edit_square, color: Color(0xFFFF6835))
        : SizedBox.shrink();

    Color getStatusColor() {
      return status ? Color(0xFF0D47A1) : Color(0xFFFF6835);
    }

    return GestureDetector(
      onTap: () => onTable(tableNum, status),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
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
              style: TextStyle(
                color: Color(0xFF0D47A1),
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text(
              table.isTableStatus ? "Available" : "Occupied",
              style: TextStyle(fontSize: 15, color: getStatusColor()),
            ),

            showEditIcon,
          ],
        ),
      ),
    );
  }
}
