import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/retweet_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/models/tweet_model.dart';

class AddRetweetPage extends StatelessWidget {
  final Tweet tweet;
  final bool isQuoteRetweet;

  const AddRetweetPage({
    Key? key,
    required this.tweet,
    this.isQuoteRetweet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RetweetController retweetController = Get.find();
    final UserController userController = Get.find();

    print('Is Quote Retweet: $isQuoteRetweet');
    print(
      'Quote Text Controller: ${retweetController.quoteTextController.text}',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            ElevatedButton(
              onPressed: () {
                print(
                  'Quote Text Before Retweet: ${retweetController.quoteTextController.text}',
                );

                if (isQuoteRetweet) {

                  if (retweetController.quoteTextController.text
                      .trim()
                      .isNotEmpty) {
                    final quoteText =
                        retweetController.quoteTextController.text;

                    print('Actual Quote Text: $quoteText');

                    retweetController.performQuoteRetweet(tweet, quoteText);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please add a quote before retweeting',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                } else {
                  retweetController.performStandardRetweet(tweet);
                }
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C9EEB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(67, 34),
              ),
              child: Text(
                "Retweet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isQuoteRetweet)
                Obx(() {
                  final user = Get.find<UserController>().currentUser.value;
                  final imageProvider =
                      user?.profilePicture.isNotEmpty == true
                          ? MemoryImage(base64Decode(user!.profilePicture))
                          : const AssetImage(
                                'assets/images/photoprofile_dummy.png',
                              )
                              as ImageProvider;
                  return CircleAvatar(
                    radius: 22,
                    backgroundImage: imageProvider,
                  );
                }),

              SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isQuoteRetweet)
                      TextField(
                        controller: retweetController.quoteTextController,
                        decoration: InputDecoration(
                          hintText: 'What are your thoughts?',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),

                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    SizedBox(height: 5),

                    // Preview tweet 
                    FutureBuilder(
                      future: userController.getUserById(tweet.userId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Text(tweet.content),
                          );
                        }

                        final user = snapshot.data!;
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        user.profilePicture.isNotEmpty
                                            ? MemoryImage(
                                              base64Decode(user.profilePicture),
                                            )
                                            : AssetImage(
                                                  'assets/images/photoprofile_dummy.png',
                                                )
                                                as ImageProvider,
                                    radius: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        user.username,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                tweet.content,
                                style: TextStyle(fontSize: 16),
                              ),

                              // Tambahkan preview gambar jika ada
                              if (tweet.hasImage && tweet.image != null)
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                        base64Decode(tweet.image!),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color: Colors.grey[300],
                                            height: 200,
                                            child: Center(
                                              child: Text(
                                                "Failed to load image",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
