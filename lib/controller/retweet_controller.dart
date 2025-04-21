import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/models/retweet_model.dart';

class RetweetController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable untuk tracking retweet
  final RxSet<String> retweetedTweetIds = <String>{}.obs;

  // Controller untuk quote retweet
  final TextEditingController quoteTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserRetweets();
  }

  @override
  void onClose() {
    quoteTextController.dispose();
    super.onClose();
  }

  // Cek apakah tweet sudah diretweet
  bool isRetweeted(String tweetId) {
    return retweetedTweetIds.contains(tweetId);
  }

  // Fetch retweet yang dilakukan pengguna saat ini
  Future<void> fetchUserRetweets() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await _firestore
          .collection('retweets')
          .where('userId', isEqualTo: userId)
          .get();

      retweetedTweetIds.value = 
          snapshot.docs.map((doc) => doc['tweetId'] as String).toSet();
    } catch (e) {
      print('Error fetching user retweets: $e');
    }
  }

  // Lakukan retweet standar
  Future<void> performStandardRetweet(Tweet tweet) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      // Cek apakah sudah diretweet
      final existingRetweet = await _firestore
          .collection('retweets')
          .where('userId', isEqualTo: currentUser.uid)
          .where('tweetId', isEqualTo: tweet.id)
          .where('isQuote', isEqualTo: false)
          .get();

      // Gunakan transaction untuk konsistensi
      await _firestore.runTransaction((transaction) async {
        final tweetRef = _firestore.collection('tweets').doc(tweet.id);

        if (existingRetweet.docs.isNotEmpty) {
          // Batalkan retweet jika sudah diretweet
          transaction.delete(existingRetweet.docs.first.reference);
          transaction.update(tweetRef, {
            'retweetsCount': FieldValue.increment(-1)
          });
          retweetedTweetIds.remove(tweet.id);
        } else {
          // Tambahkan retweet baru
          final newRetweetRef = _firestore.collection('retweets').doc();
          final retweet = Retweet(
            id: newRetweetRef.id,
            userId: currentUser.uid,
            tweetId: tweet.id,
            originalTweetUserId: tweet.userId,
            timestamp: DateTime.now(),
            isQuote: false,
          );

          transaction.set(newRetweetRef, retweet.toFirestore());
          transaction.update(tweetRef, {
            'retweetsCount': FieldValue.increment(1)
          });
          retweetedTweetIds.add(tweet.id);
        }
      });

      // Tampilkan notifikasi
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

  // Lakukan quote retweet
  Future<void> performQuoteRetweet(Tweet tweet) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || quoteTextController.text.isEmpty) return;

    try {
      // Gunakan transaction untuk konsistensi
      await _firestore.runTransaction((transaction) async {
        final tweetRef = _firestore.collection('tweets').doc(tweet.id);
        final newRetweetRef = _firestore.collection('retweets').doc();

        final retweet = Retweet(
          id: newRetweetRef.id,
          userId: currentUser.uid,
          tweetId: tweet.id,
          originalTweetUserId: tweet.userId,
          timestamp: DateTime.now(),
          isQuote: true,
          quoteText: quoteTextController.text,
        );

        // Tambahkan quote retweet
        transaction.set(newRetweetRef, retweet.toFirestore());
        
        // Naikkan jumlah retweet
        transaction.update(tweetRef, {
          'retweetsCount': FieldValue.increment(1)
        });

        retweetedTweetIds.add(tweet.id);
      });

      // Bersihkan text controller
      quoteTextController.clear();

      // Tampilkan notifikasi
      Get.snackbar(
        'Quote Retweet',
        'Quote retweet berhasil',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal melakukan quote retweet',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Quote Retweet error: $e');
    }
  }

  // Ambil jumlah retweet untuk tweet tertentu
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