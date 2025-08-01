import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/views/home/thread/thread_utils.dart';
import 'package:twitter_task/widgets/bottomsheet_optiontweet.dart';
import 'package:twitter_task/views/home/thread/thread_page.dart';
import 'package:twitter_task/widgets/bottomsheet_retweet.dart';

class TweetItem extends StatelessWidget {
  final Tweet tweet;
  final bool isInThreadPage;
  final TweetController tweetController = Get.put(TweetController());

  TweetItem({Key? key, required this.tweet, this.isInThreadPage = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    tweetController.fetchTweetById(tweet.id);

    return Container(
      padding: EdgeInsets.only(right: 18, left: 20, bottom: 10),
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
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: FutureBuilder(
                  future: Get.find<UserController>().getUserById(tweet.userId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey[300],
                      );
                    }

                    final user = snapshot.data!;
                    final imageProvider =
                        (user.profilePicture.isNotEmpty)
                            ? MemoryImage(base64Decode(user.profilePicture))
                            : const AssetImage(
                                  'assets/images/photoprofile_dummy.png',
                                )
                                as ImageProvider;

                    return CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 22,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(width: 10),

          // Tweet content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    FutureBuilder(
                      future: Get.find<UserController>().getUserById(
                        tweet.userId,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Row(
                            children: [
                              Text(
                                "Loading...",
                                style: TextStyle(
                                  fontFamily: 'Helveticaneue',
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        }

                        final user = snapshot.data!;
                        return Row(
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                fontFamily: 'Helveticalneue',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 5),
                            Text(
                              user.username,
                              style: TextStyle(
                                fontFamily: 'Helveticalneue',
                                fontSize: 16,
                                color: Color(0xff687684),
                                letterSpacing: -0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),

                          ],
                        );
                      },
                    ),

                    SizedBox(width: 8),
                    Text(
                      "· ${getTimeAgo(tweet.timestamp)}",
                      style: TextStyle(
                        fontFamily: 'Helveticalneue',
                        fontSize: 16,
                        color: Color(0xff687684),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/tweet_downarrow.png',
                        height: 8,
                        width: 10,
                      ),
                      onPressed: () {
                        _showBottomSheetOptions(context);
                      },
                    ),
                  ],
                ),

                Transform.translate(
                  offset: Offset(0, -12),
                  child: _highlightHashtags(tweet.content),
                ),

                // Tweet image
                if (tweet.image != null && tweet.image!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 16,
                      child: Image.memory(
                        base64Decode(tweet.image!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text("Failed to load image"),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],

                if (tweet.isThread && !isInThreadPage)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ThreadPage(tweet: tweet));
                      },
                      child: Text(
                        "Show this thread",
                        style: TextStyle(
                          fontFamily: 'Helveticalneue',
                          fontSize: 16,
                          color: Color(0xff4C9EEB),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _tweetIcon('assets/images/tweet_comment.png', '7'),
                      GestureDetector(
                        onTap: () {
                          showRetweetBottomSheet();
                        },
                        child: Obx(() {
                          final updatedTweet = tweetController.tweetMap[tweet.id];
                          final retweetsCount = updatedTweet?.retweetsCount ?? tweet.retweetsCount ?? 0;

                          return _tweetIcon(
                            'assets/images/tweet_retweet.png',
                            retweetsCount.toString(),
                          );
                        }),
                      ),

                      GestureDetector(
                        onTap: () {
                          tweetController.toggleLike(
                            tweet.id,
                            tweet.likesCount ?? 0,
                          );
                        },
                        child: Obx(() {
                          final updatedTweet = tweetController.tweetMap[tweet.id];
                          final isLiked = tweetController.isLiked(tweet.id);
                          final likesCount = updatedTweet?.likesCount ?? tweet.likesCount ?? 0;
                          return Row(
                            children: [
                              Image.asset(
                                isLiked
                                    ? 'assets/images/tweet_love_filled.png'
                                    : 'assets/images/tweet_love.png',
                                height: 15,
                                width: 15,
                                color: isLiked ? Colors.red : Color(0xff687684),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${tweet.likesCount ?? 0}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isLiked ? Colors.red : Color(0xff687684),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),

                      _tweetIcon('assets/images/tweet_share.png', ''),
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

  Widget _highlightHashtags(String text) {
    final RegExp hashtagRegExp = RegExp(r"\B#\w+");
    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    hashtagRegExp.allMatches(text).forEach((match) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: TextStyle(
              fontFamily: 'Helveticalneue',
              fontSize: 16,
              color: Colors.black,
              letterSpacing: -0.3,
            ),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(
            fontFamily: 'Helveticalneue',
            fontSize: 16,
            color: Color(0xff4C9EEB),
            letterSpacing: -0.3,
          ),
        ),
      );

      lastMatchEnd = match.end;
    });

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: TextStyle(
            fontFamily: 'Helveticalneue',
            fontSize: 16,
            color: Colors.black,
            letterSpacing: -0.3,
          ),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _tweetIcon(String assetPath, String count) {
    return Row(
      children: [
        Image.asset(assetPath, height: 15, width: 15),
        SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xff687684),
          ),
        ),
      ],
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
