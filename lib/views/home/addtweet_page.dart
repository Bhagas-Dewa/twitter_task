import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';

class AddTweetPage extends StatelessWidget {
  final TweetController controller = Get.find<TweetController>();
  final ImagePicker _picker = ImagePicker();

  AddTweetPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.threadTweetList.isEmpty) {
      controller.initThreadWithFirstTweet('', null);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.threadTweetList.length,
                itemBuilder: (context, index) {
                  return _buildTweetInput(index);
                },
              ),
            ),
          ),
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
      title: Row(
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
          Obx(() {
            return ElevatedButton(
              onPressed:
                  controller.threadTweetList.isNotEmpty
                      ? () => controller.postThreadTweetsFromList()
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C9EEB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(67, 34),
              ),
              child: Text(
                "Tweet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTweetInput(int index) {
    final tweet = controller.threadTweetList[index];
    final isFirst = index == 0;
    final isLast = index == controller.threadTweetList.length - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Obx(() {
              final user = Get.find<UserController>().currentUser.value;
              final imageProvider =
                  user?.profilePicture.isNotEmpty == true
                      ? MemoryImage(base64Decode(user!.profilePicture))
                      : const AssetImage('assets/images/photoprofile_dummy.png')
                          as ImageProvider;
              return CircleAvatar(radius: 22, backgroundImage: imageProvider);
            }),
            // Connection line
            if (!isLast)
              Container(
                width: 2,
                height: 50, 
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: TextEditingController(text: tweet.content)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: tweet.content.length),
                  ),
                onChanged: (value) {
                  controller.updateThreadTweet(index, content: value);
                },
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "What's happening?",
                  border: InputBorder.none,
                ),
              ),
              // Image placement
              if (tweet.image != null && tweet.image!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 16),
                  child: Row(
                    children: [
                      // Placeholder for connection line space
                      const SizedBox(width: 0, height: 150),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            base64Decode(tweet.image!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (!isFirst)
          GestureDetector(
            onTap: () => controller.removeThreadTweet(index),
            child: const Icon(Icons.close, size: 18),
          ),
      ],
    );
  }

  Widget _buildBottomIcons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0xffBDC5CD), offset: Offset(0, -0.3)),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Image.asset(
              'assets/images/addtweet_image.png',
              width: 20,
              height: 20,
            ),
            onPressed: () async {
              final image = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 70,
              );
              if (image != null) {
                final bytes = await File(image.path).readAsBytes();
                controller.updateThreadTweet(
                  controller.threadTweetList.length - 1,
                  image: base64Encode(bytes),
                );
              }
            },
          ),
          const SizedBox(width: 5),
          Image.asset('assets/images/addtweet_gif.png', width: 20, height: 20),
          const SizedBox(width: 20),
          Image.asset(
            'assets/images/addtweet_stats.png',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 20),
          Image.asset(
            'assets/images/addtweet_location.png',
            width: 20,
            height: 20,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => controller.addEmptyThreadTweet(),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/plus_thread.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
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
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                final photo = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null) {
                  final bytes = await File(photo.path).readAsBytes();
                  controller.updateThreadTweet(
                    controller.threadTweetList.length - 1,
                    image: base64Encode(bytes),
                  );
                }
              },
              child: Image.asset(
                'assets/images/bottomicon_camera.png',
                height: 78,
                width: 78,
              ),
            ),
            const SizedBox(width: 8),
            ...List.generate(4, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  'assets/images/bottomicon_img${i + 1}.png',
                  height: 78,
                  width: 78,
                ),
              );
            }),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
