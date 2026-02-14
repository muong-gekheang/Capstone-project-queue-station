import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:flutter_svg/svg.dart';
>>>>>>> main
import 'package:queue_station_app/model/user.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/change_password_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/contact_us_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/edit_account_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/setting_card.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/terms_of_service_screen.dart';

class SettingsScreen extends StatelessWidget {
  User user = User(
    name: "Monica",
    email: "monica@gmail.com",
    phone: "0987654321",
    userType: UserType.normal,
  );
  SettingsScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
<<<<<<< HEAD
          "Log Out",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const Text(
          "Are you sure you want to log out?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 16, color: Colors.grey),
=======
          "Are you sure you want to log out?",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const Text(
          "You will need to enter your password to sign back in",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              overlayColor: const Color.fromARGB(255, 111, 110, 110),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
>>>>>>> main
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
<<<<<<< HEAD
              backgroundColor: const Color(0xFFFF6835),
=======
              backgroundColor: Color(0xFF0D47A1),
>>>>>>> main
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
<<<<<<< HEAD
=======
              overlayColor: const Color.fromARGB(255, 8, 45, 101),
>>>>>>> main
            ),
            child: const Text(
              "Log Out",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
<<<<<<< HEAD
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Delete Account",
          style: TextStyle(
            color: Color(0xFFB22222),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Are you sure you want to delete your account?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              "This action is permanent. All your data, history, and settings will be lost.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              "To confirm, please enter your password below:",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFB22222),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              passwordController.dispose();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB22222),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final password = passwordController.text.trim();

              if (password.isEmpty) {
                return;
              }
              passwordController.dispose();
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
=======
    bool isEnabled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Are you sure?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFB22222),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Deleting your account is permanent. All your data, history, and settings will be lost. To confirm, please type your password below.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        isEnabled = value.trim().isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFB22222),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    overlayColor: const Color.fromARGB(255, 111, 110, 110),
                  ),
                  child: const Text(
                    "No, Don't",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: isEnabled
                      ? () {
                          passwordController.dispose();
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB22222),
                    disabledBackgroundColor: const Color.fromARGB(
                      255,
                      200,
                      200,
                      200,
                    ),
                    overlayColor: const Color.fromARGB(255, 109, 20, 20),
                  ),
                  child: const Text(
                    "Yes, Delete",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
>>>>>>> main
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
<<<<<<< HEAD
=======
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(thickness: 5, height: 5, color: Colors.grey.shade400),
        ),
>>>>>>> main
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SettingCard(
                title: "Account",
                children: [
                  ListTile(
<<<<<<< HEAD
                    leading: const Icon(Icons.person),
=======
                    leading: SvgPicture.asset(
                      "assets/images/home_icon.svg",
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),

>>>>>>> main
                    title: const Text(
                      "Edit Account",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAccountScreen(user: user),
                        ),
                      );
                    },
                  ),
                  ListTile(
<<<<<<< HEAD
                    leading: const Icon(Icons.lock),
=======
                    leading: const Icon(Icons.shield_outlined),
>>>>>>> main
                    title: const Text(
                      "Change Password",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SettingCard(
                title: "Support & About",
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text(
                      "App Version",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      "1.0.0",
                      style: const TextStyle(
                        fontSize: 18,
<<<<<<< HEAD
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
=======
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
>>>>>>> main
                      ),
                    ),
                    //onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text(
                      "Contact Us",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactUsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
<<<<<<< HEAD
                    leading: const Icon(Icons.description_outlined),
=======
                    leading: const Icon(Icons.error_outline),
>>>>>>> main
                    title: const Text(
                      "Terms of Services",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsOfServiceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SettingCard(
                title: "Actions",
                children: [
                  ListTile(
                    leading: const Icon(Icons.flag_outlined),
                    title: const Text(
                      "Report a Problem",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text(
                      "Log Out",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showLogoutDialog(context),
                  ),
                  ListTile(
                    leading: const Icon(
<<<<<<< HEAD
                      Icons.delete_outline,
=======
                      Icons.delete_outlined,
>>>>>>> main
                      color: Color(0xFFB22222),
                    ),
                    title: Text(
                      "Delete Account",
                      style: TextStyle(
                        color: Color(0xFFB22222),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showDeleteAccountDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
