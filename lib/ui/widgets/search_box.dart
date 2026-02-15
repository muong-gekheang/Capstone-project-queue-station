import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final Function(String) onSearch;
  const SearchBox({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF1F1F1),
      ),
      child: TextField(
        onChanged: onSearch,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          hintText: "Search customer name or queue ID",
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
