import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/views/mail/message_setting.dart';
import 'package:twitter_task/views/sidebar/sidebar.dart';

class AppbarMail extends StatelessWidget implements PreferredSizeWidget {
  const AppbarMail({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0.033,
      shadowColor: const Color(0xffBDC5CD),
      flexibleSpace: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xffBDC5CD),
                offset: Offset(0, 0.33),
              ),
            ],
          ),
          padding: const EdgeInsets.only(left: 11, right: 11, top: 10),
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              Row(
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
                    'Messages',
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
                    onPressed: () {
                      Get.to(() => MessageSetting());
                    },
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Container(
                  height: 32,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffE7ECF0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      Image.asset(
                        'assets/images/appbarsearch_search.png',
                        height: 13,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search for people and groups",
                            hintStyle: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Helveticaneue',
                              letterSpacing: -0.3,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 55);
}
