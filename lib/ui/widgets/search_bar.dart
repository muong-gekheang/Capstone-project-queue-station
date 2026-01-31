import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key, required this.onSearch});

  final Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFF1F1F1),
      ),
      child: SearchBar(
        onChanged: onSearch,
        leading: Icon(Icons.search),
        hintText: "Search",
        elevation: WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }
}
