import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/domain/menu.dart';
import 'package:queue_station_app/ui/screens/add_new_menu.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/category_card_widget.dart';
import 'package:queue_station_app/ui/widgets/menu_card_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';
import 'package:flutter/services.dart';


class MenuManagement extends StatefulWidget {
  const MenuManagement({super.key});

  @override
  State<MenuManagement> createState() => _MenuManagementState();
}

class _MenuManagementState extends State<MenuManagement> {
  int selectedIndex = 0;
  int selectedCategoryId = -1;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = mockMenuCategories[selectedIndex].categoryId!;
  }

  Widget filteredMenuList() {
    final result = mockMenus.where((m) => m.categoryId == selectedCategoryId).toList();
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (context, index) => MenuCardWidget(menu: result[index])
      );
  }

  void onAddItem(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewMenu()));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, 
        icon: Icon(Icons.arrow_back)),
        title: Text("Menu Management", style: TextStyle(color: Color.fromRGBO(255, 104, 53, 1),  fontWeight: FontWeight.bold, fontSize: 22),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: SearchbarWidget(hintText: "search...",),
                  ),
                  SizedBox(width: 10),
                  ButtonWidget(
                    leadingIcon: Icons.add, 
                    title: "Add Item", 
                    onPressed: onAddItem, 
                    backgroundColor: Color.fromRGBO(255, 104, 53, 1), 
                    textColor: Colors.white, 
                    borderRadius: 50, 
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),),
                ],
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(mockMenuCategories.length, (index) => CategoryCardWidget(name: mockMenuCategories[index].categoryName, isSelected: selectedIndex == index, onTap: (){
                    setState(() {
                      selectedIndex = index;
                      selectedCategoryId = mockMenuCategories[index].categoryId!;
                      print("The selectedCategoryId is ${selectedCategoryId}");
                    });
                  }))
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("Menu List", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(child: filteredMenuList())
          ],
        )),
      
    );
  }
}

