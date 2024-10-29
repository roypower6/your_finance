import 'package:flutter/material.dart';

// Main SettingScreen with navigation to each specific screen
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: const [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "설정",
                    style: TextStyle(
                      color: Color(0xff5AA897),
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.blue),
                title: Text(
                  '앱 버전',
                ),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.red),
                title: Text('개발자 이메일'),
                subtitle: Text('roy040707@gmail.com'),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.green),
                title: Text('개발자'),
                subtitle: Text('Rhee Seung gi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Help & Support Screen
