import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String title;
  String? prefixText;
  String? hintText;
  Color? color;
  final String? Function(String?)? validator;
  final TextEditingController textController;
  final String? initialValue;
  final void Function(String)? onChanged;

  TextFieldWidget({
    super.key,
    required this.title,
    this.prefixText,
    this.hintText,
    this.color,
    this.validator,
    required this.textController,
    this.initialValue,
    this.onChanged
  }) {
    if (initialValue != null) {
      textController.text = initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextFormField(
          validator: validator,
          controller: textController,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText != null ? hintText : null,
            prefix: prefixText != null
                ? Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Text(prefixText!),
                  )
                : null,
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0.5,
                color: color == null ? Color.fromRGBO(0, 0, 0, 0.5) : color!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: color == null ? Color.fromRGBO(0, 0, 0, 0.5) : color!,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
