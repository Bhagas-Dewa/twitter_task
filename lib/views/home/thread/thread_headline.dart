import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/views/home/thread/thread_utils.dart';
import 'package:twitter_task/widgets/bottomsheet_optiontweet.dart';
import 'package:twitter_task/widgets/bottomsheet_retweet.dart';

class ThreadHeadline extends StatelessWidget {
  final Tweet tweet;
  final TweetController tweetController = Get.find<TweetController>();

  ThreadHeadline({Key? key, required this.tweet}) : super(key: key);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: Get.find<UserController>().getUserById(tweet.userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildUserLoadingPlaceholder();
              }

              final user = snapshot.data!;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        user.profilePicture.isNotEmpty
                            ? MemoryImage(base64Decode(user.profilePicture))
                            : const AssetImage(
                                  'assets/images/photoprofile_dummy.png',
                                )
                                as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Helveticaneue100',
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Helveticaneue100',
                          fontSize: 16,
                          color: Color(0xff687684),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/tweet_downarrow.png',
                      height: 10,
                      width: 12,
                    ),
                    onPressed: () {
                      _showBottomSheetOptions(context);
                    },
                  ),
                ],
              );
            },
          ),

          // Tweet content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              tweet.content,
              style: const TextStyle(
                fontFamily: 'Helveticaneue',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
          ),

          // Tweet image
          if (tweet.image != null && tweet.image!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64Decode(tweet.image!),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),

          // Timestamp
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              formatTimestamp(tweet.timestamp),
              style: TextStyle(
                color: Color(0XFF687684),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Helveticaneue',
                letterSpacing: -0.3,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                _buildStat("7 Replies"),
                const SizedBox(width: 12),
                _buildStat("2 Retweets"),
                const SizedBox(width: 12),
                _buildStat("${tweet.likesCount ?? 0} Likes"),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildActionButton('assets/images/tweet_comment.png'),
              SizedBox(width: 40),
              GestureDetector(
                onTap: showRetweetBottomSheet,
                child: _buildActionButton('assets/images/tweet_retweet.png'),
              ),
              SizedBox(width: 50),
              _buildActionLikeButton(),
              SizedBox(width: 50),
              _buildActionButton('assets/images/tweet_share.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserLoadingPlaceholder() {
    return Row(
      children: [
        CircleAvatar(radius: 24, backgroundColor: Colors.grey[300]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100, height: 16, color: Colors.grey[300]),
            const SizedBox(height: 4),
            Container(width: 80, height: 14, color: Colors.grey[300]),
          ],
        ),
      ],
    );
  }

  Widget _buildStat(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Helveticaneue',
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildActionButton(String iconPath) {
    return IconButton(
      icon: Image.asset(iconPath, width: 16, height: 16),
      onPressed:
          iconPath == 'assets/images/tweet_retweet.png'
              ? showRetweetBottomSheet
              : () {
                print('Action button pressed! $iconPath');
              },
    );
  }

  Widget _buildActionLikeButton() {
    return GestureDetector(
      onTap: () {
        tweetController.toggleLike(tweet.id, tweet.likesCount ?? 0);
      },
      child: Obx(() {
        final isLiked = tweetController.isLiked(tweet.id);
        return Row(
          children: [
            Image.asset(
              isLiked
                  ? 'assets/images/tweet_love_filled.png'
                  : 'assets/images/tweet_love.png',
              height: 16,
              width: 16,
              color: isLiked ? Colors.red : Color(0xff687684),
            ),
            SizedBox(width: 4),
            Text(
              '${tweet.likesCount ?? 0}',
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

  void _showBottomSheetOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BottomSheetOptionTweet(tweetId: tweet.id),
    );
  }

  void showRetweetBottomSheet() {
    Get.bottomSheet(
      BottomSheetRetweet(tweet: tweet),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
