import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/search_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/views/sidebar/sidebar.dart';

class AppBarSearch extends StatelessWidget implements PreferredSizeWidget {
  final SearchScreenController controller;
  final UserController userController = Get.find<UserController>();

  AppBarSearch({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0.033,
      shadowColor: const Color(0xffBDC5CD),
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

              // 🔍 Search Field
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleSuggestions(true),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xffE7ECF0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 75),
                        Image.asset(
                          'assets/images/appbarsearch_search.png',
                          height: 13,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: controller.textController,
                            decoration: const InputDecoration(
                              hintText: "Search Twitter",
                              hintStyle: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Helveticaneue',
                                letterSpacing: -0.3,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              isDense: true,
                            ),
                            onTap: () => controller.toggleSuggestions(true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ⚙️ Settings
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
