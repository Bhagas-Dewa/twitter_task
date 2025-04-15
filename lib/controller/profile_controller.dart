import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_task/controller/user_controller.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final tabs = ['Tweets', 'Replies', 'Media', 'Likes'];
  final userController = Get.find<UserController>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();

  RxString base64Image = ''.obs;
  RxString base64Banner = ''.obs;
  File? selectedImage;
  File? selectedBanner;

  @override
  void onInit() {
    tabController = TabController(length: tabs.length, vsync: this);
    final user = userController.currentUser.value;
    if (user != null) {
      nameController.text = user.name;
      usernameController.text = user.username;
      base64Image.value = user.profilePicture.toString();
      base64Banner.value = user.profileBanner.toString();
    }

    super.onInit();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);

      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: 60,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes != null) {
        base64Image.value = base64Encode(compressedBytes);
      } else {
        Get.snackbar('Error', 'Gagal kompres gambar');
      }
    }
  }

  Future<void> pickBannerImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: 60,
        format: CompressFormat.jpeg,
      );
      if (compressedBytes != null) {
        base64Banner.value = base64Encode(compressedBytes);
      } else {
        Get.snackbar('Error', 'Gagal kompres banner');
      }
    }
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty');
      return;
    }

    final validUsername = username.startsWith('@') ? username : '@$username';

    await userController.updateUser(
      name: name,
      username: username,
      newBase64Image: base64Image.value,
      newBase64Banner: base64Banner.value,
    );

    await userController.fetchUserData();

    Get.back();
    Get.snackbar('Success', 'Profile updated');
  }
  

  @override
  void onClose() {
    tabController.dispose();
    nameController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}
