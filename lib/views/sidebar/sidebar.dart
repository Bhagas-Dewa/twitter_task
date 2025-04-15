import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/auth_controller.dart';
import 'package:twitter_task/controller/sidebar_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/views/bookmarks/bookmarks_page.dart';
import 'package:twitter_task/views/sidebar/lists/lists_page.dart';
import 'package:twitter_task/views/sidebar/moments/moments_page.dart';
import 'package:twitter_task/views/sidebar/profile/profile_page.dart';
import 'package:twitter_task/views/sidebar/settings_privacy.dart';
import 'package:twitter_task/views/sidebar/topics/topics_page.dart';

class Sidebar extends StatelessWidget {
  Sidebar({Key? key}) : super(key: key);

  final AuthController _authController = Get.find<AuthController>();
  final SidebarController sidebarController = Get.put(SidebarController());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xffE7ECF0).withOpacity(0.5),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => sidebarController.closeSidebar(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              position: sidebarController.slideAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffBDC5CD),
                      offset: Offset(0.33, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildProfileHeader(),
                    _buildUserInfo(),
                    const SizedBox(height: 25),
                    _buildMenu(),
                    const SizedBox(height: 10),
                    _buildDivider(),
                    const SizedBox(height: 10),
                    _buildSettings(),
                    const Spacer(),
                    _buildFooterIcons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            final user = Get.find<UserController>().currentUser.value;
            final base64Image = user?.profilePicture ?? '';
            final imageProvider =
                (base64Image.isNotEmpty)
                    ? MemoryImage(base64Decode(base64Image))
                    : const AssetImage('assets/images/photoprofile_dummy.png')
                        as ImageProvider;

            return GestureDetector(
              onTap: () {
                Get.to(() => ProfilePage());
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }),

          Row(
            children: [
              _buildIcon('assets/images/sidebar_pp3.png'),
              const SizedBox(width: 8),
              _buildIcon('assets/images/sidebar_pp2.png'),
              const SizedBox(width: 8),
              _buildIcon('assets/images/sidebar_menu.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String assetPath) {
    return Image.asset(assetPath, height: 32, width: 32);
  }

  Widget _buildUserInfo() {
    return Obx(() {
      final user = Get.find<UserController>().currentUser.value;

      if (user == null) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: CircularProgressIndicator(),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(left: 24, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'HelveticaNeue100',
              ),
            ),
            Text(
              user.username,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff687684),
                fontFamily: 'HelveticaNeue',
              ),
            ),
            const SizedBox(height: 16),
            _buildUserStats(),
          ],
        ),
      );
    });
  }

  Widget _buildUserStats() {
    return Row(
      children: [
        Text(
          '216',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'HelveticaNeue100',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: -1,
          ),
        ),
        SizedBox(width: 5),
        Text(
          'Following',
          style: TextStyle(
            color: Color(0xff687684),
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 20),
        Text(
          '217',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'HelveticaNeue100',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: -1,
          ),
        ),
        SizedBox(width: 5),
        Text(
          'Followers',
          style: TextStyle(
            color: Color(0xff687684),
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildMenu() {
    final menuItems = ['Profile', 'Lists', 'Topics', 'Bookmarks', 'Moments'];
    final menuIcons = [
      'sidebar_profile.png',
      'sidebar_list.png',
      'sidebar_topics.png',
      'sidebar_bookmarks.png',
      'sidebar_moments.png',
    ];

    // List halaman tujuan
    final pages = [
      ProfilePage(),
      ListsPage(),
      TopicsPage(),
      BookmarksPage(),
      MomentsPage(),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(menuIcons.length, (index) {
              return _buildMenuItem(
                menuIcons[index],
                menuItems[index],
                pages[index],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String icon, String text, Widget page) {
    return GestureDetector(
      onTap: () {
        Get.to(() => page);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Image.asset('assets/images/$icon', height: 24, width: 24),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'HelveticaNeue100',
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcon(String assetName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Image.asset('assets/images/$assetName', height: 24, width: 24),
    );
  }

  Widget _buildMenuText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'Helvetivaneue',
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Color(0xffBDC5CD), thickness: 0.35);
  }

  Widget _buildSettings() {
    final settings = ['Settings and privacy', 'Help center', 'Logout'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            settings.map((text) {
              return GestureDetector(
                onTap: () {
                  if (text == 'Settings and privacy') {
                    Get.to(() => SettingsPrivacyPage());
                  } else if (text == 'Help center') {
                    // Get.to(() => HelpCenterPage());
                  } else if (text == 'Logout') {
                    _authController.signOut();
                  }
                },
                child: _buildMenuText(text),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildFooterIcons() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIcon2('assets/images/sidebar_lamp.png'),
          _buildIcon2('assets/images/sidebar_barcode.png'),
        ],
      ),
    );
  }

  Widget _buildIcon2(String assetName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Image.asset(assetName, height: 22, width: 22),
    );
  }
}
