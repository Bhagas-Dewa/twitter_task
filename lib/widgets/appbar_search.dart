import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/views/sidebar/sidebar.dart';
import 'package:twitter_task/controller/search_controller.dart';

class AppBarSearch extends StatelessWidget implements PreferredSizeWidget {
  final SearchScreenController controller;
  
  const AppBarSearch({super.key, required this.controller});

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
              IconButton(
                icon: Image.asset('assets/images/appbar_PP.png', height: 32, width: 32),
                color: const Color(0xff4C9EEB),
                onPressed: () {
                  Get.to(() => Sidebar(), 
                    transition: Transition.noTransition,
                    fullscreenDialog: true,
                    opaque: false,
                  );
                },
              ),
              
              // Search Field
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
                            controller: controller.textController, // Gunakan textController
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
              
              // Tombol settings
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