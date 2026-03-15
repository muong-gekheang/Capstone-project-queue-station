import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store/auth_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/auth/auth_screen.dart';
import 'package:queue_station_app/ui/screens/auth/view_model/auth_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/screens/auth/widgets/custom_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onSwitchTap});
  final ValueChanged<AuthScreenTab> onSwitchTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final vm = context.read<AuthViewModel>();

    final result = await vm.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    debugPrint("Loading: ${vm.isLoading}");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ? "Login successful" : "Login failed")),
      );
      if (result) {
        context.go("/");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<AuthViewModel>();
    return Scaffold(
      backgroundColor: AppTheme.naturalWhite,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Logo
              SizedBox(
                height: 150,
                width: 300,
                child: Image.asset(
                  "assets/queue_station.png",
                  fit: BoxFit.cover,
                ),
              ),

              /// Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((255 * 0.25).toInt()),
                      blurRadius: 8,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Login to start queueing",
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _emailController,
                      label: "Email",
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _passwordController,
                      label: "Password",
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: vm.isLoading ? null : _handleLogin,
                        child: vm.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  color: AppTheme.naturalWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: vm.isLoading
                              ? null
                              : () {
                                  widget.onSwitchTap(AuthScreenTab.register);
                                },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
