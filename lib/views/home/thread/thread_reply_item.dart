import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/views/home/thread/thread_utils.dart';
import 'package:twitter_task/widgets/bottomsheet_optiontweet.dart';

class ThreadReplyItem extends StatelessWidget {
  final Tweet reply;
  final TweetController tweetController = Get.find<TweetController>();

  ThreadReplyItem({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffCED5DC), width: 0.33),
        ),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              FutureBuilder(
                future: Get.find<UserController>().getUserById(reply.userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey[300],
                    );
                  }

                  final user = snapshot.data!;
                  final imageProvider =
                      user.profilePicture.isNotEmpty
                          ? MemoryImage(base64Decode(user.profilePicture))
                          : const AssetImage(
                                'assets/images/photoprofile_dummy.png',
                              )
                              as ImageProvider;

                  return CircleAvatar(
                    radius: 18,
                    backgroundImage: imageProvider,
                  );
                },
              ),
              // Connection line
              Container(
                width: 2,
                height: 30,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ), // padding line
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info
                FutureBuilder(
                  future: Get.find<UserController>().getUserById(reply.userId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Row(
                        children: [
                          Text(
                            "Loading...",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      );
                    }

                    final user = snapshot.data!;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Helveticaneue100',
                            fontSize: 15,
                            color: Colors.black,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Helveticaneue100',
                            fontSize: 15,
                            color: Color(0xff687684),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '· ${getTimeAgo(reply.timestamp)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Helveticaneue100',
                            fontSize: 15,
                            color: Color(0xff687684),
                            letterSpacing: -0.3,
                          ),
                        ),
                        // Spacer(),
                        // IconButton(
                        //   icon: Image.asset(
                        //     'assets/images/tweet_downarrow.png',
                        //     height: 8,
                        //     width: 10,
                        //   ),
                        //   onPressed: () {
                        //     _showBottomSheetOptions(context);
                        //   },
                        //   padding: EdgeInsets.zero,
                        //   constraints: BoxConstraints(),
                        // ),
                        
                      ],
                    );
                  },
                ),

                // Tweet content
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    reply.content,
                    style: const TextStyle(
                      fontFamily: 'Helveticaneue',
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Tweet image
                if (reply.image != null && reply.image!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(reply.image!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildAction('assets/images/tweet_comment.png', ''),
                      SizedBox(width: 50),
                      _buildAction('assets/images/tweet_retweet.png', ''),
                      SizedBox(width: 50),
                      _buildAction(
                        'assets/images/tweet_love.png',
                        '${reply.likesCount ?? 0}',
                      ),
                      SizedBox(width: 50),
                      _buildAction('assets/images/tweet_share.png', ''),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(String iconPath, String count) {
    if (iconPath == 'assets/images/tweet_love.png') {
      return GestureDetector(
        onTap: () {
          tweetController.toggleLike(reply.id, reply.likesCount ?? 0);
        },
        child: Obx(() {
          final isLiked = tweetController.isLiked(reply.id);
          return Row(
            children: [
              Image.asset(
                isLiked
                    ? 'assets/images/tweet_love_filled.png'
                    : 'assets/images/tweet_love.png',
                height: 14,
                width: 14,
                color: isLiked ? Colors.red : Color(0xff687684),
              ),
              SizedBox(width: 4),
              Text(
                '${reply.likesCount ?? 0}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isLiked ? Colors.red : Color(0xff687684),
                ),
              ),
            ],
          );
        }),
      );
    }

    return Row(
      children: [
        Image.asset(iconPath, width: 14, height: 14, color: Color(0xff687684)),
      ],
    );
  }

  void _showBottomSheetOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BottomSheetOptionTweet(tweetId: reply.id),
    );
  }
}
