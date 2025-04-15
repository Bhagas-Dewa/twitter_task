// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:twitter_task/controller/tweet_controller.dart';
// import 'package:twitter_task/controller/user_controller.dart';
// import 'package:twitter_task/models/tweet_model.dart';

// class ComposeThreadPage extends StatefulWidget {
//   final Tweet mainTweet;
//   final List<Tweet> replyTweets;

//   const ComposeThreadPage({
//     super.key,
//     required this.mainTweet,
//     required this.replyTweets,
//   });

//   @override
//   State<ComposeThreadPage> createState() => _ComposeThreadPageState();
// }

// class _ComposeThreadPageState extends State<ComposeThreadPage> {
//   final TweetController tweetController = Get.find<TweetController>();

//   @override
//   void initState() {
//     super.initState();
//     tweetController.initializeThread(
//       mainContent: widget.mainTweet,
//       replyTweets: widget.replyTweets,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: GetBuilder<TweetController>(
//         builder: (controller) => ListView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           itemCount: controller.threadTweetControllers.length + 1,
//           itemBuilder: (context, index) {
//             if (index == controller.threadTweetControllers.length) {
//               return _buildAddTweetButton();
//             }
//             return _buildTweetInputField(index);
//           },
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: Colors.white,
//       elevation: 0,
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text("Cancel",
//                 style: TextStyle(
//                     color: Color(0xff4C9EEB),
//                     fontWeight: FontWeight.w900,
//                     fontSize: 17)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               tweetController.postThreadTweetsFromList();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xff4C9EEB),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             child: const Text("Tweet all"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTweetInputField(int index) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Obx(() {
//             final user = Get.find<UserController>().currentUser.value;
//             final imageProvider = (user != null && user.profilePicture.isNotEmpty)
//                 ? MemoryImage(base64Decode(user.profilePicture))
//                 : const AssetImage('assets/images/photoprofile_dummy.png')
//                     as ImageProvider;

//             return CircleAvatar(radius: 22, backgroundImage: imageProvider);
//           }),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: tweetController.threadTweetControllers[index],
//               decoration: const InputDecoration(
//                 hintText: "What's happening?",
//                 border: InputBorder.none,
//               ),
//               maxLines: null,
//               onChanged: (_) {
//                 tweetController.updateThreadTweetState();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddTweetButton() {
//     return Center(
//       child: TextButton.icon(
//         onPressed: () {
//           tweetController.addThreadTweet();
//         },
//         icon: const Icon(Icons.add, color: Color(0xff4C9EEB)),
//         label: const Text(
//           "Add another tweet",
//           style: TextStyle(color: Color(0xff4C9EEB)),
//         ),
//       ),
//     );
//   }
// }
