import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, 
      icon: Icon(Icons.arrow_back)),
      title: Text(title, style: TextStyle(color: Color.fromRGBO(255, 104, 53, 1),  fontWeight: FontWeight.bold, fontSize: 22),),
      centerTitle: true,
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}