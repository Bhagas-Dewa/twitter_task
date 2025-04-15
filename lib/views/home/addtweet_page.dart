// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:twitter_task/controller/tweet_controller.dart';
// import 'package:twitter_task/controller/user_controller.dart';
// import 'package:twitter_task/models/tweet_model.dart';
// import 'package:twitter_task/services/auth_service.dart';
// import 'package:twitter_task/views/home/compose_thread_page.dart';

// class AddTweetPage extends StatelessWidget {
//   final TweetController tweetController = Get.find<TweetController>();
//   final ImagePicker _picker = ImagePicker();
//   final AuthService authService = Get.find<AuthService>();

//   AddTweetPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           _buildTweetInput(),
//           const Spacer(),
//           _buildBottomCamera(),
//           _buildBottomIcons(),
//         ],
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       title: Padding(
//         padding: const EdgeInsets.only(right: 16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             TextButton(
//               onPressed: () => Get.back(),
//               child: const Text(
//                 "Cancel",
//                 style: TextStyle(
//                   color: Color(0xff4C9EEB),
//                   fontWeight: FontWeight.w900,
//                   fontSize: 17,
//                 ),
//               ),
//             ),
//             Obx(() => Container(
//                   width: 67,
//                   height: 38,
//                   decoration: BoxDecoration(
//                     color: tweetController.isTweetEnabled.value
//                         ? const Color(0xFF4C9EEB)
//                         : const Color(0xFFB9DCF7),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: TextButton(
//                     onPressed: tweetController.isTweetEnabled.value
//                         ? () async => await tweetController.postTweet()
//                         : null,
//                     child: const Text(
//                       "Tweet",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTweetInput() {
//     final userController = Get.find<UserController>();

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Obx(() {
//             final user = userController.currentUser.value;
//             final imageProvider = user?.profilePicture.isNotEmpty == true
//                 ? MemoryImage(base64Decode(user!.profilePicture))
//                 : const AssetImage('assets/images/photoprofile_dummy.png')
//                     as ImageProvider;
//             return CircleAvatar(radius: 22, backgroundImage: imageProvider);
//           }),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: tweetController.tweetController,
//                   decoration: const InputDecoration(
//                     hintText: "What's happening?",
//                     border: InputBorder.none,
//                     hintStyle: TextStyle(
//                       color: Color(0xff687684),
//                       fontSize: 19,
//                     ),
//                   ),
//                   style: const TextStyle(
//                     fontSize: 19,
//                     fontFamily: 'Helveticaneue',
//                     color: Colors.black,
//                   ),
//                   maxLines: null,
//                   onChanged: (_) => tweetController.updateTweetState(),
//                 ),
//                 Obx(() {
//                   if (tweetController.imagePath.value.isEmpty) {
//                     return const SizedBox.shrink();
//                   }
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.file(
//                             File(tweetController.imagePath.value),
//                             height: 200,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: GestureDetector(
//                             onTap: () {
//                               tweetController.resetTweet();
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.6),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(Icons.close,
//                                   size: 16, color: Colors.white),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomIcons() {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(color: Color(0xffBDC5CD), offset: Offset(0, -0.3)),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//       child: Row(
//         children: [
//           IconButton(
//             icon: Image.asset('assets/images/addtweet_image.png', width: 20),
//             onPressed: () async {
//               final image = await _picker.pickImage(
//                 source: ImageSource.gallery,
//                 imageQuality: 70,
//               );
//               if (image != null) await tweetController.selectImage(image);
//             },
//           ),
//           const SizedBox(width: 5),
//           Image.asset('assets/images/addtweet_gif.png', width: 20),
//           const SizedBox(width: 20),
//           Image.asset('assets/images/addtweet_stats.png', width: 20),
//           const SizedBox(width: 20),
//           Image.asset('assets/images/addtweet_location.png', width: 20),
//           const Spacer(),
//           Image.asset('assets/images/addtweet_circle.png', width: 20),
//           const VerticalDivider(color: Color(0xffCED5DC), width: 30),
//           GestureDetector(
//             onTap: () {
//               final text = tweetController.tweetController.text;
//               final image = tweetController.base64Image.value;
//               if (text.isEmpty && image.isEmpty) {
//                 Get.snackbar(
//                   'Empty Tweet',
//                   'Please write something or add an image before threading.',
//                   backgroundColor: Colors.red,
//                   colorText: Colors.white,
//                 );
//                 return;
//               }

//               final mainTweet = Tweet(
//                 id: '',
//                 userId: authService.currentUser!.uid,
//                 content: text,
//                 image: image,
//                 timestamp: DateTime.now(),
//                 likesCount: 0,
//                 hasImage: image.isNotEmpty,
//                 isPinned: false,
//                 isThread: true,
//                 parentTweetId: null,
//               );

//               Get.to(() => ComposeThreadPage(
//                     mainTweet: mainTweet,
//                     replyTweets: [],
//                   ));
//             },
//             child: Image.asset('assets/images/plus_thread.png', width: 20),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomCamera() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             const SizedBox(width: 8),
//             GestureDetector(
//               onTap: () async {
//                 final photo = await _picker.pickImage(source: ImageSource.camera);
//                 if (photo != null) await tweetController.selectImage(photo);
//               },
//               child: Image.asset(
//                 'assets/images/bottomicon_camera.png',
//                 height: 78,
//                 width: 78,
//               ),
//             ),
//             const SizedBox(width: 8),
//             ...List.generate(5, (index) {
//               return Padding(
//                 padding: const EdgeInsets.only(right: 8),
//                 child: Image.asset(
//                   'assets/images/bottomicon_img${(index % 4) + 1}.png',
//                   height: 78,
//                   width: 78,
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/models/tweetcontent_model.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
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
            ),
            if (!isFirst)
              GestureDetector(
                onTap: () => controller.removeThreadTweet(index),
                child: const Icon(Icons.close, size: 18),
              ),
          ],
        ),
        if (tweet.image != null && tweet.image!.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: MemoryImage(base64Decode(tweet.image!)),
                fit: BoxFit.cover,
              ),
            ),
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
