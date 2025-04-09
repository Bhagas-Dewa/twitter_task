import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/views/mail/message_setting.dart';
import 'package:twitter_task/views/sidebar/sidebar.dart';

class AppbarMail extends StatelessWidget implements PreferredSizeWidget {
  
  const AppbarMail({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xffBDC5CD),
                offset: Offset(0, 0.33), 
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 11),
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              Row(
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
                    color: Color(0xffE7ECF0), 
                    borderRadius: BorderRadius.circular(20), 
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 15),
                        Image.asset(
                          'assets/images/appbarsearch_search.png', 
                          height: 13,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            // controller: controller,
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 52);
}