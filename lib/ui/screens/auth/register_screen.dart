import 'package:flutter/material.dart';
import 'package:queue_station_app/services/auth_service.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/screens/auth/widgets/custom_text_field.dart';
import 'package:queue_station_app/ui/screens/auth/widgets/custom_text_form_field.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/settings_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = "";
  String username = "";
  String phoneNumber = "";
  String password = "";
  String confirmPassword = "";
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    final success = await _authService.register(
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      password: password,
    );

    setState(() => _isLoading = false);

    if (success) Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Registration successful" : "Registration failed",
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.naturalWhite,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 300,
                child: Image.asset(
                  "assets/queue_station.png",
                  fit: BoxFit.cover,
                ),
              ),

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      CustomTextFormField(
                        label: "Email",
                        onSaved: (newValue) {
                          email = newValue;
                        },
                      ),
                      const SizedBox(height: 18),
                      CustomTextFormField(
                        label: "Username",
                        onSaved: (newValue) {
                          username = newValue;
                        },
                      ),
                      const SizedBox(height: 18),
                      CustomTextFormField(
                        label: "Phone number",
                        onSaved: (newValue) {
                          phoneNumber = newValue;
                        },
                      ),
                      const SizedBox(height: 18),
                      CustomTextFormField(
                        label: "Password",
                        onSaved: (newValue) {
                          password = newValue;
                        },
                      ),
                      const SizedBox(height: 18),
                      CustomTextFormField(
                        label: "Confirm password",
                        onSaved: (newValue) {
                          confirmPassword = newValue;
                        },
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
                          onPressed: _isLoading ? null : _handleRegister,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Register",
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
                          const Text("Have an account? "),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
