import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Contact Us", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white,),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF0D47A1), 
                  width: 2,           
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.question_mark_outlined,
                  color: Color(0xFF0D47A1),
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 24,       
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "Link to our contacts",
              style: TextStyle(
                fontSize: 16,      
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, size: 32,),
                title: const Text(
                  "Contact Number",
                  style: TextStyle(
                    fontSize: 16,       
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text("+855 13245427"),
                //trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.mail_outline, size: 32,),
                title: const Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: 16,       
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text("queue_station_co@gmail.com"),
                //trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            )
          ],
        ),
      )
    );
  }
}