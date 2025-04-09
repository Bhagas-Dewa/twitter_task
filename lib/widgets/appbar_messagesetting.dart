import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/mail_controller.dart';
import 'package:twitter_task/views/sidebar/sidebar.dart';

class AppbarMessagesetting extends StatelessWidget implements PreferredSizeWidget {
  
  AppbarMessagesetting({super.key});

  final mailController = Get.find<MailController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff4C9EEB)),
                  iconSize: 20,
                onPressed: () {
                  Get.back();
                },
              ),
              Text(
                'Message settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Helveticaneue900',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back(); 
                },
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

            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}