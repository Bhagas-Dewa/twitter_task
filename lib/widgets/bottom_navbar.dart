import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/views/home/home.dart';
import 'package:twitter_task/views/mail/mail_page.dart';
import 'package:twitter_task/views/notification/notification_page.dart';
import 'package:twitter_task/views/search/search_page.dart';

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;

  void navigateTo(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        Get.to(() => HomePage(), transition: Transition.noTransition);
        break;
      case 1:
        Get.to(() => SearchPage(), transition: Transition.noTransition);
        break;
      case 2:
        Get.to(() => NotificationPage(), transition: Transition.noTransition);
        break;
      case 3:
        Get.to(() => MailPage(), transition: Transition.noTransition);
        break;
    }
  }
}

class BottomNavBar extends StatelessWidget {
  final BottomNavBarController controller = Get.put(BottomNavBarController());

  final List<String> iconPaths = [
    'assets/images/home_false.png',
    'assets/images/search_false.png',
    'assets/images/notification_false.png',
    'assets/images/mail_false.png',
  ];

  final List<String> iconActivePaths = [
    'assets/images/home_true.png',
    'assets/images/search_true.png',
    'assets/images/notification_true.png',
    'assets/images/mail_true.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        boxShadow: [
          BoxShadow(
            color: Color(0xffBDC5CD),
            offset: Offset(0, -0.033),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20), 
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () => controller.navigateTo(index), 
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Image.asset(
                    controller.selectedIndex.value == index
                        ? iconActivePaths[index]
                        : iconPaths[index],
                    width: 21,
                    height: 21,
                  ),
                ),
              );
            }),
          )),
    );
  }
}