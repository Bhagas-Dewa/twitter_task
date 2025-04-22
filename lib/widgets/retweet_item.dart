import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/models/retweet_model.dart';
import 'package:twitter_task/views/home/thread/thread_utils.dart';
import 'package:twitter_task/widgets/bottomsheet_optiontweet.dart';
import 'package:twitter_task/widgets/bottomsheet_retweet.dart';

class RetweetItem extends StatelessWidget {
  final Retweet retweet;
  final TweetController tweetController = Get.put(TweetController());
  final UserController userController = Get.find<UserController>();

  RetweetItem({Key? key, required this.retweet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 18, left: 20, bottom: 10, top: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffCED5DC), width: 0.33),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: FutureBuilder(
              future: _getRetweetHeaderText(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox.shrink();

                return Row(
                  children: [
                    // Icon retweet
                    Image.asset(
                      'assets/images/tweet_retweet.png',
                      height: 14,
                      width: 14,
                    ),
                    SizedBox(width: 10),
                    // Retweet text
                    Text(
                      snapshot.data!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff687684),
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Foto profil user retweet
              FutureBuilder(
                future: Get.find<UserController>().getUserById(retweet.userId),
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

              SizedBox(width: 12),

              // Konten kanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header user
                    FutureBuilder(
                      future: Get.find<UserController>().getUserById(
                        retweet.userId,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Text("Loading...");
                        final user = snapshot.data!;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      user.name ?? 'Unknown',
                                      style: TextStyle(
                                        fontFamily: 'Helveticalneue',
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    user.username ?? '',
                                    style: TextStyle(
                                      fontFamily: 'Helveticalneue',
                                      fontSize: 16,
                                      color: Color(0xff687684),
                                      letterSpacing: -0.3,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "· ${getTimeAgo(retweet.timestamp)}",
                                    style: TextStyle(
                                      fontFamily: 'Helveticalneue',
                                      fontSize: 16,
                                      color: Color(0xff687684),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showBottomSheetOptions(context),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Image.asset(
                                  'assets/images/tweet_downarrow.png',
                                  height: 8,
                                  width: 10,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // Quote text (jika ada)
                    if (retweet.isQuote && retweet.quoteText != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          () {
                            return retweet.quoteText!;
                          }(),
                          style: TextStyle(
                            fontFamily: 'Helveticalneue',
                            fontSize: 16,
                            color: Colors.black,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),

                    // Original Tweet
                    SizedBox(height: 5),
                    FutureBuilder<Tweet>(
                      future: _fetchOriginalTweet(retweet.tweetId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final originalTweet = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOriginalTweetPreview(originalTweet),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _tweetIcon(
                                    'assets/images/tweet_comment.png',
                                    '0',
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showRetweetBottomSheet(
                                        Tweet(
                                          id: retweet.id,
                                          userId: retweet.userId,
                                          content: retweet.quoteText ?? '',
                                          timestamp: retweet.timestamp,
                                          image: null,
                                          hasImage: false,
                                          likesCount: retweet.likesCount,
                                          retweetsCount: 0,
                                          isRetweet: true,
                                          originalTweetId: retweet.tweetId,
                                          originalTweetUserId:
                                              retweet.originalTweetUserId,
                                          isPinned: false,
                                          isDeleted: false,
                                        ),
                                      );
                                    },
                                    child: Obx(() {
                                      final tweet =
                                          tweetController.tweetMap[retweet.id];
                                      final retweetsCount =
                                          tweet?.retweetsCount ?? 0;

                                      return _tweetIcon(
                                        'assets/images/tweet_retweet.png',
                                        retweetsCount.toString(),
                                      );
                                    }),
                                  ),
                                  Obx(() {
                                    final tweet =
                                        tweetController.tweetMap[retweet.id];
                                    final isLiked = tweetController.isLiked(
                                      retweet.id,
                                    );
                                    final likesCount = tweet?.likesCount ?? 0;

                                    return GestureDetector(
                                      onTap: () {
                                        tweetController.toggleLike(
                                          retweet.id,
                                          likesCount,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            isLiked
                                                ? 'assets/images/tweet_love_filled.png'
                                                : 'assets/images/tweet_love.png',
                                            height: 15,
                                            width: 15,
                                            color:
                                                isLiked
                                                    ? Colors.red
                                                    : Color(0xff687684),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '$likesCount',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  isLiked
                                                      ? Colors.red
                                                      : Color(0xff687684),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),

                                  _tweetIcon(
                                    'assets/images/tweet_share.png',
                                    '',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tweetIcon(String assetPath, String count) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
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
      ),
    );
  }

  Widget _buildOriginalTweetPreview(Tweet tweet) {
    if (tweet.isDeleted) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBDC5CD), width: 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Tweet tidak tersedia',
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFBDC5CD), width: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info tweet asli
          FutureBuilder(
            future: Get.find<UserController>().getUserById(tweet.userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text("Loading...");
              final user = snapshot.data!;
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        user.profilePicture.isNotEmpty
                            ? MemoryImage(base64Decode(user.profilePicture))
                            : AssetImage('assets/images/photoprofile_dummy.png')
                                as ImageProvider,
                    radius: 14,
                  ),
                  SizedBox(width: 8),
                  Text(
                    user.name ?? 'Unknown',
                    style: TextStyle(
                      fontFamily: 'Helveticalneue',
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 5),
                  Text(
                    user.username ?? '',
                    style: TextStyle(
                      fontFamily: 'Helveticalneue',
                      fontSize: 14,
                      color: Color(0xff687684),
                      letterSpacing: -0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    "· ${getTimeAgo(tweet.timestamp)}",
                    style: TextStyle(
                      fontFamily: 'Helveticalneue',
                      fontSize: 14,
                      color: Color(0xff687684),
                      letterSpacing: -0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 8),
          Text(
            tweet.content,
            style: TextStyle(
              fontFamily: 'Helveticalneue',
              fontSize: 14,
              color: Colors.black,
              letterSpacing: -0.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (tweet.hasImage && tweet.image != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  base64Decode(tweet.image!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      height: 150,
                      child: Center(child: Text("Image not available")),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<Tweet> _fetchOriginalTweet(String tweetId) async {
    try {
      final tweet = await tweetController.fetchTweetById(tweetId);

      // Tambahkan pengecekan untuk tweet yang dihapus atau tidak tersedia
      if (tweet.isDeleted) {
        return Tweet(
          id: tweetId,
          userId: retweet.originalTweetUserId,
          content: 'Tweet tidak tersedia',
          timestamp: retweet.timestamp,
          hasImage: false,
          isPinned: false,
          isDeleted: true,
        );
      }

      return tweet;
    } catch (e) {
      // Jika gagal mengambil tweet
      return Tweet(
        id: tweetId,
        userId: retweet.originalTweetUserId,
        content: 'Tweet tidak tersedia',
        timestamp: retweet.timestamp,
        hasImage: false,
        isPinned: false,
        isDeleted: true,
      );
    }
  }

  Future<String> _getRetweetHeaderText() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (retweet.userId == currentUserId) {
      return retweet.isQuote ? "You Quote Retweeted" : "You Retweeted";
    } else {
      final user = await userController.getUserById(retweet.userId);
      return retweet.isQuote
          ? "${user?.name ?? 'You'} Retweeted"
          : "${user?.name ?? 'You'} Retweeted";
    }
  }

  void _showBottomSheetOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BottomSheetOptionTweet(tweetId: retweet.id),
    );
  }

  void _showRetweetBottomSheet(Tweet tweet) {
    Get.bottomSheet(
      BottomSheetRetweet(tweet: tweet),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
