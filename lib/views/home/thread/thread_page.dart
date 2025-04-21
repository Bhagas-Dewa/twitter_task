import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/views/home/thread/thread_headline.dart';
import 'package:twitter_task/views/home/thread/thread_reply_item.dart';

class ThreadPage extends StatelessWidget {
  final Tweet tweet;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TweetController tweetController = Get.find<TweetController>();

  ThreadPage({Key? key, required this.tweet}) : super(key: key) {
    tweetController.changeThreadHeadline(
      tweet.threadRootId ?? tweet.id,
      tweet.threadRootId ?? tweet.id,
    );
  }

  Stream<List<Tweet>> getRepliesStream(String threadRootId) {
    return _firestore
        .collection('tweets')
        .where('threadRootId', isEqualTo: threadRootId)
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Tweet.fromFirestore(doc)).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFBDC5CD), width: 0.33),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff4C9EEB),
                  ),
                  iconSize: 20,
                  onPressed: () {
                    Get.back();
                  },
                ),
                const Text(
                  'Thread',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'Helveticaneue900',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),

      body: Obx(() {
        final refreshKey = Key(
          'thread_refresh_${tweetController.refreshTrigger.value}',
        );

        return StreamBuilder<List<Tweet>>(
          key: refreshKey, // Key ini memaksa rebuild widget saat berubah
          stream: getRepliesStream(tweetController.currentThreadRootId.value),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No replies found'));
            }

            final tweets = snapshot.data!;

            // Tentukan headline
            final headlineTweet = tweets.firstWhere(
              (t) => t.id == tweetController.currentHeadlineTweetId.value,
              orElse: () => tweet,
            );

            final displayedTweetIds = <String>{headlineTweet.id};

            // Memisah replies untuk menghindari duplikasi
            final replies =
                tweets
                    .where(
                      (t) =>
                          t.id != headlineTweet.id &&
                          t.threadRootId ==
                              tweetController.currentThreadRootId.value,
                    )
                    .toList();
            
            replies.forEach((t) => displayedTweetIds.add(t.id));

            // Urutkan replies
            replies.sort((a, b) => a.timestamp.compareTo(b.timestamp));

            final repliesBefore =
                replies
                    .where((r) => r.timestamp.isBefore(headlineTweet.timestamp))
                    .toList();

            final repliesAfter =
                replies
                    .where((r) => r.timestamp.isAfter(headlineTweet.timestamp))
                    .toList();

            return ListView(
              children: [
                // Jika headline bukan root tweet, tampilkan root tweet sebagai reply item
                if (headlineTweet.id != (tweet.threadRootId ?? tweet.id) &&
                    !repliesBefore.any(
                      (r) => r.id == (tweet.threadRootId ?? tweet.id),
                    ))
                  ThreadReplyItem(
                    reply: tweets.firstWhere(
                      (t) => t.id == (tweet.threadRootId ?? tweet.id),
                      orElse: () => tweets.first,
                    ),
                    threadRootId: tweet.threadRootId ?? tweet.id,
                    onTap: () {
                      tweetController.changeThreadHeadline(
                        tweet.threadRootId ?? tweet.id,
                        tweet.threadRootId ?? tweet.id,
                      );
                    },
                  ),

                // Reply item sebelum headline
                ...repliesBefore.map(
                  (replyTweet) => ThreadReplyItem(
                    key: Key('reply_before_${replyTweet.id}'),
                    reply: replyTweet,
                    threadRootId: tweet.threadRootId ?? tweet.id,
                    onTap: () {
                      tweetController.changeThreadHeadline(
                        replyTweet.id,
                        headlineTweet.threadRootId ?? headlineTweet.id,
                      );
                    },
                  ),
                ),

                // Headline
                ThreadHeadline(
                  key: Key('headline_${headlineTweet.id}'),
                  tweet: headlineTweet,
                ),

                // Reply item setelah headline
                ...repliesAfter.map(
                  (replyTweet) => ThreadReplyItem(
                    key: Key('reply_after_${replyTweet.id}'),
                    reply: replyTweet,
                    threadRootId: tweet.threadRootId ?? tweet.id,
                    onTap: () {
                      tweetController.changeThreadHeadline(
                        replyTweet.id,
                        headlineTweet.threadRootId ?? headlineTweet.id,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
