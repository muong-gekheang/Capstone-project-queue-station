import 'package:flutter/material.dart';
import 'package:queue_station_app/domain/menu.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';

class MenuDetail extends StatelessWidget {
  final Menu menu;
  const MenuDetail({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: menu.name),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                if(menu.menuImage == null)
                  CircleAvatar(
                    radius: 120,
                    backgroundColor: Colors.white,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(menu.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                        Text('to be changed later'),
                      ],
                    ),
                    Text(menu.isAvailable ? 'Available' : 'Not Available', style: TextStyle(color: menu.isAvailable ? Color.fromRGBO(16, 185, 129, 1) : Color.fromRGBO(230, 57, 70, 1),
                    fontSize: 15,))
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: Text(menu.description, 
                      style: 
                        TextStyle(color: Colors.black.withOpacity(0.5),  fontSize: 13),
                      ),
                    ),
                    SizedBox(width: 80),
                    Text('\$${menu.price.toStringAsFixed(2)}', style: TextStyle(color: Color.fromRGBO(255, 104, 53, 1),
                    fontSize: 25),)
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 5,),
                    Text('${menu.preparationTime} min'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,10,20,10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWidget(leadingIcon: Icons.delete, title: 'Delete', onPressed: (){}, backgroundColor: Color.fromRGBO(230, 57, 70, 1), textColor: Colors.white, padding:  EdgeInsets.symmetric(horizontal: 40, vertical: 5)),
                  
                      ButtonWidget(leadingIcon: Icons.create_outlined, title: 'Edit', onPressed: (){}, backgroundColor:  Color.fromRGBO(13, 71, 161,1), textColor: Colors.white, padding:  EdgeInsets.symmetric(horizontal: 40, vertical: 5)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}