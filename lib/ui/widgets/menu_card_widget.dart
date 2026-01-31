import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:queue_station_app/domain/menu.dart';
import 'package:queue_station_app/domain/menu_category.dart';
import 'package:queue_station_app/ui/screens/menu_detail.dart';

class MenuCardWidget extends StatelessWidget {
  final Menu menu;
  const MenuCardWidget({super.key, required this.menu});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuDetail(menu: menu)));
      },
      child: Card(
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: Offset(0, 0), 
                blurRadius: 4,       
                spreadRadius: 0,      
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(menu.menuImage != null)
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: MemoryImage(menu.menuImage!)) 
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(menu.name, style: TextStyle(
                    fontWeight: FontWeight.w500, 
                    color: Colors.black,
                    fontSize: 18
                    ),),
                  Row(
                    children: [
                      Text("Dessert", style: TextStyle(color: Colors.grey, fontSize: 12),),
                      SizedBox(width: 5),
                      Text("•", style: TextStyle(color: Colors.grey, fontSize: 12),),
                      SizedBox(width: 5),
                      Text("\$${menu.price}", style: TextStyle(color: const Color.fromRGBO(255, 104, 53, 1), fontSize: 12),)
                    ],
                  ),
                  Text(menu.isAvailable ? "Available" : "Not Available", style: TextStyle(color: menu.isAvailable ? Color.fromRGBO(16, 185, 129, 1) : Color.fromRGBO(230, 57, 70, 1),
                  fontSize: 13,
                  ),)
                ],
              ),
              Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.create_outlined), color: Color.fromRGBO(13, 71, 161,1),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  ),
                  
                  SizedBox(width: 5),
                  IconButton(onPressed: (){}, icon: Icon(Icons.delete, 
                  color: Color.fromRGBO(230, 57, 70, 1),),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}