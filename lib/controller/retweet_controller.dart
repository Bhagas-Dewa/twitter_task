import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/models/retweet_model.dart';

class RetweetController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxSet<String> retweetedTweetIds = <String>{}.obs;

  final TextEditingController quoteTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserRetweets();
    quoteTextController.clear();
  }

  @override
  void onClose() {
    quoteTextController.dispose();
    super.onClose();
  }

  bool isRetweeted(String tweetId) {
    return retweetedTweetIds.contains(tweetId);
  }

  Future<void> fetchUserRetweets() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot =
          await _firestore
              .collection('retweets')
              .where('userId', isEqualTo: userId)
              .get();

      retweetedTweetIds.value =
          snapshot.docs.map((doc) => doc['tweetId'] as String).toSet();
    } catch (e) {
      print('Error fetching user retweets: $e');
    }
  }

  Future<void> performStandardRetweet(Tweet tweet) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore.runTransaction((transaction) async {
        final tweetRef = _firestore.collection('tweets').doc(tweet.id);

        final existingRetweet =
            await _firestore
                .collection('retweets')
                .where('userId', isEqualTo: currentUser.uid)
                .where('tweetId', isEqualTo: tweet.id)
                .where('isQuote', isEqualTo: false)
                .get();

        if (existingRetweet.docs.isNotEmpty) {
          transaction.delete(existingRetweet.docs.first.reference);
          transaction.update(tweetRef, {
            'retweetsCount': FieldValue.increment(-1),
          });
          retweetedTweetIds.remove(tweet.id);
        } else {

          final newTweetRef = _firestore.collection('tweets').doc();
          final newTweet = {
            'userId': currentUser.uid,
            'text': tweet.content,
            'image': tweet.image,
            'timestamp': Timestamp.now(),
            'isRetweet': true,
            'originalTweetId': tweet.id,
            'originalTweetUserId': tweet.userId,
            'retweetsCount': 0,
            'likesCount': 0,
            'hasImage': tweet.hasImage,
          };

          transaction.set(newTweetRef, newTweet);

          transaction.update(tweetRef, {
            'retweetsCount': FieldValue.increment(1),
          });

          retweetedTweetIds.add(tweet.id);
        }
      });

      Get.snackbar(
        'Retweet',
        isRetweeted(tweet.id) ? 'Retweet berhasil' : 'Retweet dibatalkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal melakukan retweet',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Retweet error: $e');
    }
  }

  Future<void> performQuoteRetweet(Tweet tweet, String quoteText) async {
  final currentUser = _auth.currentUser;
  
  if (currentUser == null || quoteText.isEmpty) return;

  try {
    await _firestore.runTransaction((transaction) async {
      final tweetRef = _firestore.collection('tweets').doc(tweet.id);
      final newTweetRef = _firestore.collection('tweets').doc();

      final newTweet = {
        'userId': currentUser.uid,
        'text': quoteText, 
        'image': null,
        'timestamp': Timestamp.now(),
        'isRetweet': true,
        'isQuote': true,
        'originalTweetId': tweet.id,
        'originalTweetUserId': tweet.userId,
        'quotedTweetContent': tweet.content, 
        'quotedTweetId': tweet.id,
        'quotedTweetUserId': tweet.userId,
        'retweetsCount': 0,
        'likesCount': 0,
        'hasImage': false,
      };

      transaction.set(newTweetRef, newTweet);

      transaction.update(tweetRef, {
        'retweetsCount': FieldValue.increment(1),
      });

      retweetedTweetIds.add(tweet.id);
    });

    quoteTextController.clear();

    Get.snackbar(
      'Quote Retweet',
      'Quote retweet berhasil',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  } catch (e) {
    print('Quote Retweet Error: $e');
    Get.snackbar(
      'Error',
      'Gagal melakukan quote retweet',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

  Future<int> getRetweetCount(String tweetId) async {
    try {
      final tweetDoc = await _firestore.collection('tweets').doc(tweetId).get();
      return tweetDoc.data()?['retweetsCount'] ?? 0;
    } catch (e) {
      print('Error getting retweet count: $e');
      return 0;
    }
  }
}
