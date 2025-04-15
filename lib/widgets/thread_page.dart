import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/widgets/tweet_item.dart';

class ThreadPage extends StatelessWidget {
  final Tweet tweet;

  ThreadPage({Key? key, required this.tweet}) : super(key: key);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Tweet>> fetchReplies(String threadRootId) async {
    final snapshot = await _firestore
        .collection('tweets')
        .where('threadRootId', isEqualTo: threadRootId)
        .orderBy('timestamp')
        .get();

    return snapshot.docs.map((doc) => Tweet.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thread"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: FutureBuilder<List<Tweet>>(
        future: fetchReplies(tweet.threadRootId ?? tweet.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No replies in this thread."));
          }

          final tweets = snapshot.data!;
          final allTweets = [tweet, ...tweets.where((t) => t.id != tweet.id)];

          return ListView.builder(
            itemCount: allTweets.length,
            itemBuilder: (context, index) {
              return TweetItem(tweet: allTweets[index]);
            },
          );
        },
      ),
    );
  }
}
