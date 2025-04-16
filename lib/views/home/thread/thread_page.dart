import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/views/home/thread/thread_headline.dart';
import 'package:twitter_task/views/home/thread/thread_reply_item.dart';

class ThreadPage extends StatelessWidget {
  final Tweet tweet;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ThreadPage({Key? key, required this.tweet}) : super(key: key);

  Future<List<Tweet>> fetchReplies(String threadRootId) async {
    final snapshot =
        await _firestore
            .collection('tweets')
            .where('threadRootId', isEqualTo: threadRootId)
            .orderBy('timestamp')
            .get();

    return snapshot.docs.map((doc) => Tweet.fromFirestore(doc)).toList();
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
                bottom: BorderSide(
                  color: Color(0xFFBDC5CD),
                  width: 0.33,
                ),
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

      body: FutureBuilder<List<Tweet>>(
        future: fetchReplies(tweet.threadRootId ?? tweet.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //   // Jika tidak ada replies, tetap tampilkan tweet utama
          //   return ListView(
          //     children: [
          //       ThreadHeadline(tweet: tweet),
          //       // _buildReplyField(),
          //     ],
          //   );
          // }

          final tweets = snapshot.data!;

          // Pisahkan tweet utama dengan replies
          final rootTweet = tweets.firstWhere(
            (t) => t.id == (tweet.threadRootId ?? tweet.id),
            orElse: () => tweet,
          );

          final replies =
              tweets
                  .where(
                    (t) =>
                        t.id != rootTweet.id &&
                        t.threadRootId == (tweet.threadRootId ?? tweet.id),
                  )
                  .toList();

          // Urutkan replies berdasarkan timestamp
          replies.sort((a, b) => a.timestamp.compareTo(b.timestamp));

          return ListView(
            children: [
              ThreadHeadline(tweet: rootTweet),

              // Tweet replies
              ...replies
                  .map((replyTweet) => ThreadReplyItem(reply: replyTweet))
                  .toList(),

              // _buildReplyField(),
            ],
          );
        },
      ),
    );
  }

  // Widget _buildReplyField() {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       border: Border(top: BorderSide(color: Colors.grey.shade300)),
  //     ),
  //     child: Row(
  //       children: [
  //         const CircleAvatar(
  //           radius: 18,
  //           backgroundImage: AssetImage('assets/images/photoprofile_dummy.png'),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: TextField(
  //             decoration: const InputDecoration(
  //               border: InputBorder.none,
  //               hintText: "Tweet your reply",
  //               hintStyle: TextStyle(color: Colors.grey),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
