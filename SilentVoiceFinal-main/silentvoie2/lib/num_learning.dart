// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> dataset = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await supabase.from('num_learning').select();
    if (response.isNotEmpty) {
      setState(() {
        dataset = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  void showPrevious() {
    setState(() {
      currentIndex = (currentIndex - 1 + dataset.length) % dataset.length;
    });
  }

  void showNext() {
    setState(() {
      currentIndex = (currentIndex + 1) % dataset.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adjusted Header with Reduced Height
            Container(
              height: screenHeight * 0.08,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF97D8C4), Color(0xFF45B2E0)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Numbers',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Data Display with Navigation
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left, size: 50),
                          onPressed: dataset.isNotEmpty ? showPrevious : null,
                        ),
                        Flexible(
                          child: Container(
                            margin:
                                EdgeInsets.only(bottom: screenHeight * 0.02),
                            width: screenWidth * 0.7,
                            height: screenHeight * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: dataset.isNotEmpty
                                ? Center(
                                    child: Image.network(
                                      dataset[currentIndex]['num_sign'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(child: Text('Loading...')),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_right, size: 50),
                          onPressed: dataset.isNotEmpty ? showNext : null,
                        ),
                      ],
                    ),
                    Text(
                      dataset.isNotEmpty
                          ? dataset[currentIndex]['numbers']
                          : 'Loading...',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
