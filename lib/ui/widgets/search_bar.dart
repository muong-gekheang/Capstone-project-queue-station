import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/app_theme.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key, required this.onSearch});

  final Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTheme.spacingXL,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        color: AppTheme.naturalGrey,
        border: Border.all(color: AppTheme.naturalGrey),
      ),
      child: SearchBar(
        onChanged: onSearch,
        leading: const Icon(Icons.search),
        hintText: "Search",
        elevation: WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }
}
