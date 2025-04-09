import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/home_controller.dart';
import 'package:twitter_task/controller/tweet_controller.dart';

class SettingsPrivacyPage extends StatelessWidget {
  const SettingsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings and privacy',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Helveticaneue900',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xff4C9EEB),
                fontSize: 17,
                fontFamily: 'Helveticaneue100',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ], elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xffBDC5CD),
                offset: Offset(0, 0.33),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Color(0xffE7ECF0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('@pixsellz'),
             _buildDivider(),
            _buildMenuItem('Account', onTap: () => Get.toNamed('/account')),
             _buildDivider(),
            _buildMenuItem('Privacy and safety'),
             _buildDivider(),
            _buildMenuItem('Notifications', onTap: () => Get.toNamed('/notifications')),
             _buildDivider(),
            _buildMenuItem('Content preferences'),
             _buildDividerFull(),
             SizedBox(height: 10,
             child: Container(
              color: Color(0xffE7ECF0),
             ),
             ),
            _buildSectionHeader('General'),
             _buildDivider(),
            _buildMenuItem('Display and sound'),
             _buildDivider(),
            _buildMenuItem('Data usage'),
             _buildDivider(),
            _buildMenuItem('Accessibility'),
             _buildDivider(),
            _buildMenuItem('About Twitter'),
            _buildDivider(),
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  'General settings affect all of your Twitter accounts on this device.',
                  style: TextStyle(
                    color: Color(0xff687684), 
                    fontSize: 14,
                    letterSpacing: -0.33,
                    fontFamily: 'Helvetivaneue',
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
            _buildDividerFull(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
      height: 47,
      width: double.infinity,
      color: Color(0xffE7ECF0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          color: Color(0xff687684),
          fontFamily: 'Helveticaneue100',
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, {VoidCallback? onTap}) {
  return Container(
    color: Colors.white,
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Helveticaneue100',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 15),
      onTap: onTap,
    ),
  );
}

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Divider(
        height: 0.35,
        thickness: 0.35,
        color: const Color(0xffCED5DC),
      ),
    );
  }

   Widget _buildDividerFull() {
    return Divider(
        height: 0.35,
        thickness: 0.35,
        color: const Color(0xffCED5DC),
      );
  }
}
