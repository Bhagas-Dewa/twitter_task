import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_task/controller/home_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';

class AddTweetPage extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final ImagePicker _picker = ImagePicker();

  AddTweetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTweetInput(),
          const Spacer(),
          _buildBottomCamera(),
          _buildBottomIcons(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xff4C9EEB),
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
            ),
            Obx(
              () => Container(
                width: 67,
                height: 38,
                decoration: BoxDecoration(
                  color:
                      homeController.isTweetEnabled.value
                          ? const Color(0xFF4C9EEB)
                          : const Color(0xFFB9DCF7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed:
                      homeController.isTweetEnabled.value
                          ? () async {
                            await homeController.postTweet();
                          }
                          : null,
                  child: const Text(
                    "Tweet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTweetInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final user = Get.find<UserController>().currentUser.value;

            if (user == null) {
              return CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey[300],
              );
            }

            final imageProvider =
                user.profilePicture.isNotEmpty
                    ? MemoryImage(base64Decode(user.profilePicture))
                    : const AssetImage('assets/images/photoprofile_dummy.png')
                        as ImageProvider;

            return CircleAvatar(radius: 22, backgroundImage: imageProvider);
          }),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: homeController.tweetController,
                  decoration: const InputDecoration(
                    hintText: "What's happening?",
                    hintStyle: TextStyle(
                      color: Color(0xff687684),
                      fontSize: 19,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Helveticaneue',
                    fontSize: 19,
                  ),
                  maxLines: null,
                  onChanged: (text) {
                    homeController.updateTweetState();
                  },
                ),

                // Image preview
                Obx(() {
                  return homeController.imagePath.value.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(
                                File(homeController.imagePath.value),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  homeController.imagePath.value = '';
                                  homeController.base64Image.value = '';
                                  homeController.updateTweetState();
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomIcons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0xffBDC5CD), offset: Offset(0, -0.3)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset(
              'assets/images/addtweet_image.png',
              width: 20,
              height: 20,
            ),
            onPressed: () async {
              final XFile? image = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 70,
              );
              if (image != null) {
                print('Image Selected: ${image.path}');
                await homeController.selectImage(image);
              }
            },
          ),
          SizedBox(width: 5),
          Image.asset('assets/images/addtweet_gif.png', width: 20, height: 20),
          SizedBox(width: 20),
          Image.asset(
            'assets/images/addtweet_stats.png',
            width: 20,
            height: 20,
          ),
          SizedBox(width: 20),
          Image.asset(
            'assets/images/addtweet_location.png',
            width: 20,
            height: 20,
          ),
          const Spacer(),
          Image.asset(
            'assets/images/addtweet_circle.png',
            width: 20,
            height: 20,
          ),
          Container(
            width: 1,
            height: 25,
            color: Color(0xffCED5DC),
            margin: const EdgeInsets.symmetric(horizontal: 15),
          ),
          Image.asset('assets/images/addtweet_plus.png', width: 20, height: 20),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildBottomCamera() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                final XFile? photo = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null) {
                  print('Gambar diambil: ${photo.path}');
                  await homeController.selectImage(photo);
                }
              },
              child: Image.asset(
                'assets/images/bottomicon_camera.png',
                height: 78,
                width: 78,
              ),
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/images/bottomicon_img1.png',
              height: 78,
              width: 78,
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/images/bottomicon_img2.png',
              height: 78,
              width: 78,
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/images/bottomicon_img3.png',
              height: 78,
              width: 78,
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/images/bottomicon_img4.png',
              height: 78,
              width: 78,
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/images/bottomicon_img1.png',
              height: 78,
              width: 78,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
