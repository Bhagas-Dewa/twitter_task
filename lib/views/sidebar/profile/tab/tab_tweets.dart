import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/widgets/tweet_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TweetsTab extends StatelessWidget {
  final TweetController tweetController = Get.put(TweetController());

  TweetsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tweets')
          .where('userId', isEqualTo: currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tweets = snapshot.data!.docs
            .map((doc) => Tweet.fromFirestore(doc))
            .toList();

        // Pindahkan tweet yang dipin ke atas
        tweets.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.timestamp.compareTo(a.timestamp);
        });

        if (tweets.isEmpty) {
          return const Center(child: Text('No tweets yet.'));
        }

        return ListView.builder(
          itemCount: tweets.length,
          itemBuilder: (context, index) {
            final tweet = tweets[index];

            return Padding(
              padding: const EdgeInsets.only(),
              child: Stack(
                children: [
                  // Widget TweetItem
                  TweetItem(tweet: tweet),
                  if (tweet.isPinned && index == 0)
                    Positioned(
                      top: -4,
                      left: 50,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/tweet_pin.png',
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width:10),
                          const Text(
                            "Pinned Tweet",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff687684),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
