// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import '/sign_dict.dart';
import '/sign_interpreter.dart';
import '/sign_concepts.dart';
import '/account_page.dart';
import '/app_settings.dart';

class Home_screen extends StatelessWidget {
  const Home_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
          SafeArea(
            child: Column(
              children: [
                /// Top Profile & Logout Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountPage(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: screenWidth * 0.09,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.settings,
                              color: Colors.black,
                              size: screenWidth * 0.08,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Welcome Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    "Welcome, User!",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(
                    height: screenHeight * 0.05), // Moves white container down

                /// White Full-Screen Container with Buttons
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(screenWidth * 0.1),
                      child: Column(
                        children: [
                          _buildMenuButton(
                            context: context,
                            icon: Icons.menu_book,
                            titleKey: "Sign Dictionary",
                            subtitleKey: "Explore sign language words",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignDictionary(),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                              height: screenHeight * 0.05), // Increased spacing
                          _buildMenuButton(
                            context: context,
                            icon: Icons.record_voice_over,
                            titleKey: "Sign Learning",
                            subtitleKey: "Improve your signing skills",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SignLearningScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                              height: screenHeight * 0.05), // Increased spacing
                          _buildMenuButton(
                            context: context,
                            icon: Icons.front_hand,
                            titleKey: "Sign Interpreter",
                            subtitleKey: "Get live interpretation",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                       const SignInterpreter(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required IconData icon,
    required String titleKey,
    required String subtitleKey,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF45B2E0), Color(0xFF97D8C4)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            Icon(icon, color: Colors.black, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleKey,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitleKey,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
