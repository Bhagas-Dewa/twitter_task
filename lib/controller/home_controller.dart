// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:twitter_task/models/tweet_model.dart';
// import 'package:twitter_task/controller/auth_controller.dart';

// class HomeController extends GetxController {
//   final TextEditingController tweetController = TextEditingController();
//   final AuthController _authController = Get.find<AuthController>();

//   var isTweetEnabled = false.obs;
//   var imagePath = ''.obs;
//   var base64Image = ''.obs;
//   var tweets = <Tweet>[].obs;
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     resetTweet();
//     tweetController.addListener(() {
//       updateTweetState();
//     });

//     fetchTweets();
//   }

//   void fetchTweets() {
//     FirebaseFirestore.instance
//         .collection('tweets')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//           tweets.value =
//               snapshot.docs.map((doc) {
//                 final tweet = Tweet.fromFirestore(doc);
//                 return tweet;
//               }).toList();
//         });
//   }

//   Future<String?> postTweet() {
//     if (tweetController.text.isEmpty && base64Image.value.isEmpty)
//       return Future.value(null);

//     print(
//       "Posting tweet with image: ${base64Image.value.isNotEmpty ? 'Yes (${base64Image.value.length} chars)' : 'No'}",
//     );

//     CollectionReference tweetsRef = FirebaseFirestore.instance.collection(
//       'tweets',
//     );

//     return tweetsRef
//         .add({
//           'userId': _authController.currentUser?.uid ?? 'anonymous',
//           'timestamp': Timestamp.now(),
//           'text': tweetController.text,
//           'image': base64Image.value,
//           'hasImage': base64Image.value.isNotEmpty,
//           'likesCount': 0,
//           'isPinned': false,
//         })
//         .then((docRef) {
//           String tweetId = docRef.id;

//           //  Update dokumen untuk menyimpan ID ke dalam field `tweetId`
//           return docRef.update({'tweetId': tweetId}).then((_) {
//             print("Tweet posted with ID: $tweetId");

//             resetTweet();
//             Get.back();

//             return tweetId;
//           });
//         })
//         .catchError((error) {
//           print("Error posting tweet: $error");
//           return null;
//         });
//   }

//   Future<void> selectImage(XFile image) async {
//     try {
//       print("selectImage called with path: ${image.path}");
//       isLoading.value = true;
//       final bytes = await File(image.path).readAsBytes();
//       print("Image bytes size: ${bytes.length}");
//       base64Image.value = base64Encode(bytes);
//       print("Base64 image encoded, length: ${base64Image.value.length}");
//       imagePath.value = image.path;
//       updateTweetState();
//       print("Image path: ${imagePath.value}");
//       print("Base64 image is empty: ${base64Image.value.isEmpty}");
//       print("Tweet enabled: ${isTweetEnabled.value}");
//     } catch (e) {
//       print("Error encoding image: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

  


//   void updateTweetState() {
//     isTweetEnabled.value =
//         tweetController.text.isNotEmpty || base64Image.value.isNotEmpty;
//   }

//   void resetTweet() {
//     tweetController.clear();
//     imagePath.value = '';
//     base64Image.value = '';
//     isTweetEnabled.value = false;
//     ;
//   }

//   @override
//   void onClose() {
//     tweetController.dispose();
//     imagePath.value = '';
//     base64Image.value = '';
//     isTweetEnabled.value = false;
//     super.onClose();
//   }
// }
