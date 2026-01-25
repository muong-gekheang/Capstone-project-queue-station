import 'package:flutter/material.dart';

class SearchWidget<T> extends StatefulWidget {
  const SearchWidget({super.key, required this.filterLogic});

  final List<Widget> Function(String) filterLogic;

  @override
  State<SearchWidget<T>> createState() => _SearchWidgetState<T>();
}

class _SearchWidgetState<T> extends State<SearchWidget<T>> {
  SearchController searchController = SearchController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      viewBackgroundColor: Colors.white,
      isFullScreen: true,
      barHintText: "Search",
      searchController: searchController,
      onClose: () {
        searchController.clear();
      },
      constraints: BoxConstraints(maxHeight: 36, minHeight: 36),
      barShape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      barBackgroundColor: WidgetStatePropertyAll(Color(0xFFEEEEEE)),
      suggestionsBuilder: (context, controller) {
        return widget.filterLogic(controller.text);
      },
    );
  }
}
