import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> handlePasswordReset() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      _showMessage("Please enter your email.");
      return;
    }

    // Step 1: Check if email exists in the user_data table
    final response = await supabase
        .from('user_data')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (response == null) {
      _showMessage("Email not found. Please enter a registered email.");
      return;
    }

    // Step 2: If exists, send password reset email
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo:
            'https://yourapp.com/reset-password', // Update with your redirect URL
      );
      _showMessage("Password reset email sent! Check your inbox.");
    } catch (error) {
      _showMessage("Error sending reset email. Please try again later.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
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
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: handlePasswordReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Send Email",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
