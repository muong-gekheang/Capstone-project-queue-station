import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store/auth_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/services/store/store_profile_service.dart';
import 'package:queue_station_app/ui/screens/store_side/settings/subscreens/store_subscription_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/settings/view_model/store_settings_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_store/edit_store_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/widgets/change_password/change_password_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/widgets/contact_us/contact_us_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/widgets/terms_of_service/terms_of_service_screen.dart';
import 'package:queue_station_app/ui/widgets/custom_success_snackbar.dart';
import 'package:queue_station_app/ui/widgets/setting_card.dart';

class StoreSettingsContent extends StatefulWidget {
  const StoreSettingsContent({super.key});

  @override
  State<StoreSettingsContent> createState() => _StoreSettingsContentState();
}

class _StoreSettingsContentState extends State<StoreSettingsContent> {
  void _showLogoutDialog(BuildContext context) {
    var vm = context.read<StoreSettingsViewModel>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
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
            ),
          ),
          ElevatedButton(
            onPressed: () {
              vm.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6835),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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

  void onChangePassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<StoreSettingsViewModel>(),
          child: ChangePasswordScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<StoreSettingsViewModel>();
    var restaurantService = context.read<RestaurantService>();
    var storeProfileService = context.read<StoreProfileService>();
    var authService = context.read<AuthService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: const Icon(Icons.settings, size: 32),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Account Section
              SettingCard(
                title: "Account",
                children: [
                  ListTile(
                    leading: const Icon(Icons.storefront, color: Colors.black),
                    title: const Text(
                      "Edit Store",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditStoreScreen(
                            restaurantService: restaurantService,
                            storeProfileService: storeProfileService,
                            authService: authService,
                          ),
                        ),
                      ).then((result) {
                        if (result == true) {
                          CustomSuccessSnackbar.show(
                            context,
                            "Added Successfully",
                          );
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.shield_outlined,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Change Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: onChangePassword,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Manage Store Location",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.go('/map'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Support & About Section
              SettingCard(
                title: "Support & About",
                children: [
                  ListTile(
                    leading: const Icon(Icons.credit_card, color: Colors.black),
                    title: const Text(
                      "My subscription",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StoreSubscriptionScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.help_outline,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Contact Us",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactUsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Terms and Policies",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsOfServiceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Actions Section
              SettingCard(
                title: "Actions",
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.black),
                    title: const Text(
                      "Log out",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showLogoutDialog(context),
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
