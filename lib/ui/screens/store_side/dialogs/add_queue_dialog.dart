import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/widgets/table_type_widget.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/guests_counter_widget.dart';

class AddQueueDialog extends StatefulWidget {
  final Function(String, String, int) onJoin;

  const AddQueueDialog({super.key, required this.onJoin});
  @override
  State<AddQueueDialog> createState() => _AddQueueDialogState();
}

class _AddQueueDialogState extends State<AddQueueDialog> {
  int _selectedTable = 1;
  int _guestCount = 1;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String? nullValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void incrPeople() {
    setState(() {
      _guestCount++;
      if (_guestCount <= 4 && _selectedTable < _guestCount) {
        _selectedTable = _guestCount;
      } else {
        _selectedTable = 0;
      }
    });
  }

  void decrPeople() {
    if (_guestCount >= 0) {
      setState(() {
        _guestCount--;
        if (_guestCount <= 4 && _selectedTable < _guestCount) {
          _selectedTable = _guestCount;
        } else {
          _selectedTable = 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Add Queue",
                style: TextStyle(
                  color: Color(0xFFFF6835),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Basic info:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _field("Customer name:", nameController, nullValidator),
                  _field("Phone number:", phoneController, nullValidator),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Table type:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [1, 2]
                      .map(
                        (i) => TableTypeWidget(
                          value: i,
                          selectedType: _selectedTable,
                          onTap: (val) => setState(() => _selectedTable = val),
                        ),
                      )
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [3, 4]
                      .map(
                        (i) => TableTypeWidget(
                          value: i,
                          selectedType: _selectedTable,
                          onTap: (val) => setState(() => _selectedTable = val),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Number of guests:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            GuestsCounterWidget(
              numPeople: _guestCount,
              incrPeople: incrPeople,
              decrPeople: decrPeople,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    title: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: AppTheme.naturalGrey,
                    textColor: AppTheme.naturalBlack,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    borderRadius: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ButtonWidget(
                    title: "Join Queue",
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        widget.onJoin(
                          nameController.text,
                          phoneController.text,
                          _guestCount,
                        );
                        Navigator.pop(context);
                      }
                    },
                    backgroundColor: AppTheme.primaryColor,
                    textColor: AppTheme.naturalWhite,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    borderRadius: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    ),
  );
}
