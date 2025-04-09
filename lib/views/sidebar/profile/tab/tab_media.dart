import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/widgets/tweet_item.dart';

class MediaTab extends StatelessWidget {
  const MediaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tweets')
          .where('userId', isEqualTo: currentUser?.uid)
          .where('hasImage', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Belum ada media.'));
        }

        final tweets = snapshot.data!.docs
            .map((doc) => Tweet.fromFirestore(doc))
            .toList();

        return ListView.separated(
          itemCount: tweets.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final tweet = tweets[index];

            return TweetItem(tweet: tweet);
          },
        );
      },
    );
  }
}
