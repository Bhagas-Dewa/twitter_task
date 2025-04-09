import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/widgets/tweet_item.dart';

class LikedTweetsTab extends StatelessWidget {
  const LikedTweetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('liked_tweets')
          .where('userId', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final likedDocs = snapshot.data?.docs ?? [];

        if (likedDocs.isEmpty) {
          return const Center(child: Text("No liked tweets yet."));
        }

        return FutureBuilder<List<Tweet>>(
          future: _fetchLikedTweets(likedDocs),
          builder: (context, tweetSnapshot) {
            if (tweetSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final likedTweets = tweetSnapshot.data ?? [];

            return ListView.builder(
              itemCount: likedTweets.length,
              itemBuilder: (context, index) {
                return TweetItem(tweet: likedTweets[index]);
              },
            );
          },
        );
      },
    );
  }

  Future<List<Tweet>> _fetchLikedTweets(List<DocumentSnapshot> likedDocs) async {
    List<Tweet> tweets = [];

    for (var doc in likedDocs) {
      String tweetId = doc['tweetId'];
      var tweetSnapshot = await FirebaseFirestore.instance
          .collection('tweets')
          .doc(tweetId)
          .get();
      if (tweetSnapshot.exists) {
        tweets.add(Tweet.fromFirestore(tweetSnapshot));
      }
    }

    return tweets;
  }
}
