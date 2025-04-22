import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/widgets/tweet_item.dart';

class RepliesTab extends StatelessWidget {
  const RepliesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<List<Tweet>>(
      future: _fetchRepliesAndRetweets(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tweets = snapshot.data ?? [];

        if (tweets.isEmpty) {
          return const Center(child: Text("No replies or retweets yet."));
        }

        tweets.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          itemCount: tweets.length,
          itemBuilder: (context, index) {
            return TweetItem(tweet: tweets[index]);
          },
        );
      },
    );
  }

  Future<List<Tweet>> _fetchRepliesAndRetweets(String userId) async {
    final firestore = FirebaseFirestore.instance;

    final repliesSnapshot =
        await firestore
            .collection('tweets')
            .where('userId', isEqualTo: userId)
            .where('parentTweetId', isNotEqualTo: null)
            .get();

    final retweetsSnapshot =
        await firestore
            .collection('tweets')
            .where('userId', isEqualTo: userId)
            .where('isRetweet', isEqualTo: true)
            .get();

    final allTweetsMap = <String, Tweet>{};

    for (var doc in repliesSnapshot.docs) {
      final tweet = Tweet.fromFirestore(doc);

      if ((doc.data() as Map<String, dynamic>)['threadRootId'] == doc.id)
        continue;

      allTweetsMap[doc.id] = tweet;
    }

    for (var doc in retweetsSnapshot.docs) {
      final tweet = Tweet.fromFirestore(doc);
      allTweetsMap[doc.id] = tweet;
    }

    return allTweetsMap.values.toList();
  }
}
