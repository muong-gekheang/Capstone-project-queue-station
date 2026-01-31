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
    return SearchAnchor(
      searchController: searchController,
      viewOnClose: () => searchController.clear(),
      builder: (context, controller) {
        return SearchBar(
          hintText: "Search",
          hintStyle: WidgetStatePropertyAll(
            TextStyle(color: Colors.black.withAlpha((255 * 0.5).toInt())),
          ),
          leading: Icon(
            Icons.search,
            color: Colors.black.withAlpha((255 * 0.5).toInt()),
          ),
          constraints: BoxConstraints(maxHeight: 36, minHeight: 36),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          backgroundColor: WidgetStatePropertyAll(Color(0xFFEEEEEE)),
          onTap: () {
            controller.openView();
          },
        );
      },
      viewBackgroundColor: Colors.white,
      isFullScreen: true,

      suggestionsBuilder: (context, controller) {
        return widget.filterLogic(controller.text);
      },
    );
  }
}
