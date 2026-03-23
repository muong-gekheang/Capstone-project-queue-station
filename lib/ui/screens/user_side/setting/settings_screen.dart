import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/auth/auth_repository.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/settings_content.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/view_models/settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

// <<<<<<< HEAD
// =======
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           "Are you sure you want to log out?",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         content: const Text(
//           "You will need to enter your password to sign back in",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 16),
//         ),
//         actionsAlignment: MainAxisAlignment.center,
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey.shade300,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               overlayColor: const Color.fromARGB(255, 111, 110, 110),
//             ),
//             child: const Text(
//               "Cancel",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               UserProvider userProvider = context.read<UserProvider>();
//               userProvider.updateUser(null);
//               Navigator.pop(context);
//               context.go("/");
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF0D47A1),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               overlayColor: const Color.fromARGB(255, 8, 45, 101),
//             ),
//             child: const Text(
//               "Log Out",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteAccountDialog(BuildContext context) {
//     final TextEditingController passwordController = TextEditingController();
//     bool isEnabled = false;

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: const Text(
//                 "Are you sure?",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Color(0xFFB22222),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Deleting your account is permanent. All your data, history, and settings will be lost. To confirm, please type your password below.',
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: passwordController,
//                     obscureText: true,
//                     textAlign: TextAlign.start,
//                     onChanged: (value) {
//                       setState(() {
//                         isEnabled = value.trim().isNotEmpty;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(
//                           color: Color(0xFFB22222),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               actionsAlignment: MainAxisAlignment.center,
//               actions: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey.shade300,
//                     overlayColor: const Color.fromARGB(255, 111, 110, 110),
//                   ),
//                   child: const Text(
//                     "No, Don't",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),

//                 ElevatedButton(
//                   onPressed: isEnabled
//                       ? () {
//                           passwordController.dispose();
//                           Navigator.pop(context);
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFB22222),
//                     disabledBackgroundColor: const Color.fromARGB(
//                       255,
//                       200,
//                       200,
//                       200,
//                     ),
//                     overlayColor: const Color.fromARGB(255, 109, 20, 20),
//                   ),
//                   child: const Text(
//                     "Yes, Delete",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

// >>>>>>> origin/store-side_mvvm
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(
        authRepository: context.read<AuthRepository>(), 
        userProvider: context.read<UserProvider>()
      ),
      child: SettingsContent(),
    );
  }
}
