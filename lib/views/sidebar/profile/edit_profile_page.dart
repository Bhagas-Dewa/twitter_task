import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final user = profileController.userController.currentUser.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Color(0xff4C9EEB),
            ),
            onPressed: () => Get.back(),
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: 'Helveticaneue100',
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: profileController.saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xff4C9EEB),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Helveticaneue100',
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: profileController.pickBannerImage,
                child: Obx(() {
                  final bannerBase64 = profileController.base64Banner.value;
                  return Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7ECF0),
                      image:
                          bannerBase64.isNotEmpty
                              ? DecorationImage(
                                image: MemoryImage(base64Decode(bannerBase64)),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child:
                        bannerBase64.isEmpty
                            ? Center(
                              child: Image.asset(
                                'assets/images/bottomicon_camera.png',
                                width: 50,
                                height: 50,
                                color: Color(0xff4C9EEB),
                              ),
                            )
                            : null,
                  );
                }),
              ),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: profileController.pickImage,
                  child: Obx(() {
                    final base64 = profileController.base64Image.value;
                    return CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFFE7ECF0),
                      backgroundImage:
                          base64.isNotEmpty
                              ? MemoryImage(base64Decode(base64))
                              : const AssetImage(
                                    'assets/images/bottomicon_camera.png',
                                  )
                                  as ImageProvider,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // NAME
              const Text(
                'Name',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Helveticaneue',
                  fontWeight: FontWeight.w700,
                  color: Color(0xff687684),
                ),
              ),
              TextField(
                controller: profileController.nameController,
                cursorColor: const Color(0xff4C9EEB),
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Helveticaneue',
                    fontWeight: FontWeight.w800,
                    color: Color(0xff687684),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff687684), width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff4C9EEB), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // USERNAME
              const Text(
                'Username',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Helveticaneue',
                  fontWeight: FontWeight.w700,
                  color: Color(0xff687684),
                ),
              ),
              TextField(
                controller: profileController.usernameController,
                cursorColor: const Color(0xff4C9EEB),
                decoration: const InputDecoration(
                  hintText: '@username',
                  hintStyle: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Helveticaneue',
                    fontWeight: FontWeight.w800,
                    color: Color(0xff687684),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff687684), width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff4C9EEB), width: 2),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: 'Helveticaneue',
                  fontWeight: FontWeight.w800,
                  color: Color(0xff687684),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
