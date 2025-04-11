import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_task/controller/auth_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/views/sidebar/sidebar.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();

  AppBarHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0.033,
      shadowColor: const Color(0xffBDC5CD),
      flexibleSpace: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              final user = _userController.currentUser.value;
              final base64Image = user?.profilePicture ?? '';
              final imageProvider = (base64Image.isNotEmpty)
                  ? MemoryImage(base64Decode(base64Image))
                  : const AssetImage('assets/images/photoprofile_dummy.png') as ImageProvider;

              return IconButton(
                onPressed: () {
                  Get.to(
                    () => Sidebar(),
                    transition: Transition.noTransition,
                    fullscreenDialog: true,
                    opaque: false,
                  );
                },
                icon: Container(
                  height: 32,
                  width: 32,
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

            SvgPicture.asset(
              'assets/images/TwitterLogo.svg',
              height: 24,
              width: 24,
            ),

            IconButton(
              icon: Image.asset(
                'assets/images/appbar_feature.png',
                height: 24,
                width: 24,
              ),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Get.back(),
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () async {
                          Get.back();
                          await _authController.signOut();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
