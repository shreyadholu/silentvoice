// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import '/homepage.dart';
import '/forgotpass.dart';
import '/signup.dart';
import 'dart:math';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home_screen()),
      );
    }
  }

  Future<void> loginUser() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('User_data') // Change 'users' to your actual table name
          .select()
          .eq('username', username)
          .eq('password', password)
          .maybeSingle();

      if (response != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('username', username);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home_screen()),
        );
      } else {
        _showErrorDialog("Invalid username or password.");
      }
    } catch (e) {
      _showErrorDialog("Login error: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF45B2E0), Color(0xFF97D8C4)],
                ),
              ),
            ),
          ),
          Positioned(
            top: -screenHeight * 0.1,
            left: -screenWidth * 0.1,
            child: Transform.rotate(
              angle: pi / 6,
              child: Container(
                width: screenWidth * 0.6,
                height: screenWidth * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.3),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "Good to see you,",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Login to your account",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(Icons.email, "Email", usernameController),
                  const SizedBox(height: 20),
                  _buildTextField(Icons.lock, "Password", passwordController,
                      obscureText: true),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot your password?",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E86C1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        },
                        child: const Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hintText,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}