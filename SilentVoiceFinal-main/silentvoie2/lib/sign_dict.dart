import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sign_learning.dart';

class SignDictionary extends StatefulWidget {
  const SignDictionary({super.key});

  @override
  State<SignDictionary> createState() => _SignDictionaryState();
}

class _SignDictionaryState extends State<SignDictionary> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<String> signs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSigns();
  }

  Future<void> fetchSigns() async {
    try {
      final response = await supabase.from('Dict_data').select('sentence');

      // ignore: unnecessary_null_comparison
      if (response != null && response.isNotEmpty) {
        setState(() {
          signs =
              response.map<String>((row) => row['sentence'] as String).toList();
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
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
                  end: Alignment.center,
                  colors: [Color(0xFF45B2E0), Color(0xFF97D8C4)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header with Back Button and Title
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        "Dictionary",
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Loading Indicator
                if (isLoading) const CircularProgressIndicator(),

                // Sign List
                if (!isLoading)
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        itemCount: signs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                signs[index],
                                style: TextStyle(fontSize: screenWidth * 0.04),
                              ),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 18),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VideoScreen(sentence: signs[index]),
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
}
