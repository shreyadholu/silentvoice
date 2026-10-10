import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silentvoie2/login.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Account', style: TextStyle(fontSize: 20)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
                SizedBox(width: 15),
                Text('Username',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Text('Account Management',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.folder_open, color: Colors.blue),
              title: Text('Edit Personal Data'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.blue),
              title: Text('Change Password'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blue),
              title: Text('Logout'),
              onTap: () {
                logout(context);
              },
            ),
            SizedBox(height: 20),
            Text('Other',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AccountPage(),
  ));
}