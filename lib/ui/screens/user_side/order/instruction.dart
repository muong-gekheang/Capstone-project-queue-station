import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/screens/user_side/order/menu_screen.dart';

class Instruction extends StatefulWidget {
  const Instruction({super.key});

  @override
  State<Instruction> createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  final TextEditingController _tableNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _tableNumberController.dispose();
    super.dispose();
  }

  void _handleNextPressed() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    }
  }

  String? _validateTableNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the table number!';
    }

    if (value.trim().isEmpty) {
      return 'Please enter a valid table number!';
    }

    return null;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Food Ordering",
              style: TextStyle(color: Color(0xFFFF6835), fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12,),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Center(
                    child: Text(
                      "Instruction",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Step 1: Find the number",
                    style: TextStyle(color: Color(0xFFFF6835), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text("Look at the table above and locate the number."),
                  SizedBox(height: 22),

                  Text(
                    "Step 2: Enter the number",
                    style: TextStyle(
                      color: Color(0xFFFF6835),
                      fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text("Type the number you found into the input field below."),
                  SizedBox(height: 22),

                  Text(
                    "Step 3: Next",
                    style: TextStyle(
                      color: Color(0xFFFF6835),
                      fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text("Tap Next to continue."),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter the table number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _tableNumberController,
                    decoration: InputDecoration(
                      hintText: 'e.g., D21',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      
                    ),
                    validator: _validateTableNumber,
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _handleNextPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Color(0xFFFF6835),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ), 
              child: Text(
                "Next",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              )
            )
          ],
        ),
      )
    );
  }
}