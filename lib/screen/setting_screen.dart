import 'package:flutter/material.dart';
import 'package:your_finance/screen/setting_screen_folder/app_info_screen.dart';
import 'package:your_finance/screen/setting_screen_folder/app_setting_screen.dart';
import 'package:your_finance/screen/setting_screen_folder/developer_info_screen.dart';

// Main SettingScreen with navigation to each specific screen
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              const Row(
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
              ListTile(
                leading: const Icon(Icons.info, color: Colors.blue),
                title: const Text(
                  '앱 정보',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppInfoScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.green),
                title: const Text('앱 설정'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppSettingsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.purple),
                title: const Text('개발자 정보'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeveloperInfoScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Help & Support Screen
