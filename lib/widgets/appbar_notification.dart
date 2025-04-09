import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/views/sidebar/sidebar.dart';

class AppbarNotification extends StatelessWidget implements PreferredSizeWidget {
  
  const AppbarNotification({super.key});

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                icon: Image.asset(
                  'assets/images/appbar_PP.png',
                  height: 32,
                  width: 32,
                ),
                color: const Color(0xff4C9EEB),
                onPressed: () {
                  Get.to(() => Sidebar(), 
                    transition: Transition.noTransition,
                    fullscreenDialog: true,
                    opaque: false,
                  );
                },
              ),
              Text(
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