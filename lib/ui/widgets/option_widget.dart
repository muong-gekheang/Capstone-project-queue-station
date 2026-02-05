import 'package:flutter/material.dart';
import 'package:queue_station_app/model/entities/add_on.dart';
import 'package:queue_station_app/model/entities/menu.dart';
import 'package:queue_station_app/model/entities/menu_item.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu.dart';

class OptionWidget<T> extends StatefulWidget {
  final T optionModel;
  
  const OptionWidget({
    super.key,
    required this.optionModel,
  });

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (){
          setState(() {
            isSelected = !isSelected;
          });
        }, 
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value){
                  setState(() {
                    isSelected = !isSelected;
                  });
                }, // checkbox also triggers parent
              ),
              const SizedBox(width: 4),
              if (widget.optionModel is Menu && (widget.optionModel as Menu).menuImage != null)
                CircleAvatar(
                  radius: 30,
                  backgroundImage: MemoryImage(widget.optionModel.menuImage!),
                ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(widget.optionModel.name, style: const TextStyle(fontSize: 14)),
              ),
              Text('\$${widget.optionModel.price}'),
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditMenuScreen(existingMenu: widget.optionModel)));
                }, 
                icon: const Icon(Icons.edit)),
            ],
          ),
        ),
      ),
    );
  }
}
