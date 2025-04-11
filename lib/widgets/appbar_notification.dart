import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/views/sidebar/sidebar.dart';

class AppbarNotification extends StatelessWidget implements PreferredSizeWidget {
  const AppbarNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final user = userController.currentUser.value;
                final base64Image = user?.profilePicture ?? '';
                final imageProvider = (base64Image.isNotEmpty)
                    ? MemoryImage(base64Decode(base64Image))
                    : const AssetImage('assets/images/photoprofile_dummy.png') as ImageProvider;

                return IconButton(
                  icon: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => Sidebar(),
                      transition: Transition.noTransition,
                      fullscreenDialog: true,
                      opaque: false,
                    );
                  },
                );
              }),

              const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontFamily: 'Helveticaneue900',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),

              IconButton(
                icon: Image.asset(
                  'assets/images/appbarsearch_settings.png',
                  height: 24,
                  width: 24,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
