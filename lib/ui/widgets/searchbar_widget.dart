import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchbarWidget extends StatefulWidget {
  final String hintText;
  final Color color;
  final ValueChanged<String> onChanged; // searchValue

  const SearchbarWidget({super.key, required this.hintText, this.color = const Color.fromRGBO(255, 104, 53, 1), required this.onChanged});

  @override
  State<SearchbarWidget> createState() => _SearchbarWidgetState();
}

class _SearchbarWidgetState extends State<SearchbarWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _searchController,
      focusNode: _focusNode,
      maxLines: 1,
      onChanged: (value){
        widget.onChanged(value);
        print(widget.onChanged);
      },
      decoration: InputDecoration(
        isDense: true,
        fillColor: Colors.white,
        hintText: _focusNode.hasFocus ? '' : widget.hintText,
        suffixIcon: IconButton(onPressed: (){
          _focusNode.requestFocus();
        }, 
        icon: Icon(Icons.search), color: widget.color, iconSize: 25,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: widget.color,
            width: 1,
          ),
        )
      ),

    );
  }
}