import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0), 
      end: Offset.zero, 
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    openSidebar();
    super.onInit();
  }

  void openSidebar() {
    animationController.forward();
  }

  void closeSidebar() {
    animationController.reverse().then((_) => Get.back());
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
