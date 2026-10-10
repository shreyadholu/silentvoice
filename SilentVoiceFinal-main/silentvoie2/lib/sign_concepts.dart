import 'package:flutter/material.dart';
import '/alphabet_learning.dart';
import '/num_learning.dart';
import 'dart:math';

class SignLearningScreen extends StatelessWidget {
  const SignLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
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

          // Faded Circular Decoration
          Positioned(
            top: -screenHeight * 0.12,
            left: -screenWidth * 0.12,
            child: Transform.rotate(
              angle: pi / 6,
              child: Container(
                width: screenWidth * 0.7,
                height: screenWidth * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.35),
                ),
              ),
            ),
          ),

          // Page Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),

                /// **Back Button**
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.03),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                ),

                SizedBox(height: screenHeight * 0.01), // Adjusted spacing
                /// **Title**
                Center(
                  child: Text(
                    "Let's Start",
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.07), // Adjusted spacing
                /// **Curved White Container**
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(screenWidth * 0.07),
                        topRight: Radius.circular(screenWidth * 0.07),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.08),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: screenHeight * 0.06),

                          /// **Buttons moved to the top**
                          _buildMenuButton(
                            icon: Icons.menu_book,
                            title: "Alphabets",
                            subtitle: "Learn sign language alphabets",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AlphabetsScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          _buildMenuButton(
                            icon: Icons.numbers,
                            title: "Numbers",
                            subtitle: "Learn sign language numbers",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NumberScreen(),
                                ),
                              );
                            },
                          ),

                          /// **Spacer to push remaining content to bottom**
                          const Spacer(),
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

  /// **Custom Button Widget**
  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
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
          children: [
            SizedBox(width: 20),
            Icon(icon, color: Colors.black, size: 40),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
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
