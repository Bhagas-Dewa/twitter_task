import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/models/tweetcontent_model.dart';
import 'package:twitter_task/widgets/bottomsheet_retweet.dart';

class TweetController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Tweet posting
  var tweetController = TextEditingController();
  var isTweetEnabled = false.obs;
  var imagePath = ''.obs;
  var base64Image = ''.obs;
  var isLoading = false.obs;

  // Tweet fetch
  var tweets = <Tweet>[].obs;
  var threadTweetList = <TweetContent>[].obs;
  var refreshTrigger = 0.obs;
  var tweetMap = <String, Tweet>{}.obs;

  // Like & ownership
  var likedTweetIds = <String>{}.obs;
  var isPinned = false.obs;
  var isOwner = false.obs;
  var tweetOwnerId = ''.obs;

  // Tweet thread
  var currentHeadlineTweetId = ''.obs;
  var currentThreadRootId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    tweetController.addListener(updateTweetState);
    fetchLikedTweets();
    fetchTweets();
  }

  @override
  void onClose() {
    tweetController.dispose();
    super.onClose();
  }

  void forceRefresh() {
    refreshTrigger.value++;
  }

  void changeThreadHeadline(String newHeadlineTweetId, String threadRootId) {
    if (currentHeadlineTweetId.value != newHeadlineTweetId) {
      currentHeadlineTweetId.value = newHeadlineTweetId;
      currentThreadRootId.value = threadRootId;

      forceRefresh();

      print(
        'Thread Headline Changed: $newHeadlineTweetId, Root: $threadRootId',
      );
    }
  }

  void resetThreadHeadline() {
    currentHeadlineTweetId.value = '';
    currentThreadRootId.value = '';
  }

  // Tweet input state
  void updateTweetState() {
    isTweetEnabled.value =
        tweetController.text.isNotEmpty || base64Image.value.isNotEmpty;
  }

  void resetTweet() {
    tweetController.clear();
    imagePath.value = '';
    base64Image.value = '';
    isTweetEnabled.value = false;
  }

  // Thread Management
  void initThreadWithFirstTweet(String content, String? image) {
    threadTweetList.clear();
    threadTweetList.add(TweetContent(content: content, image: image));
  }

  void addEmptyThreadTweet() {
    threadTweetList.add(TweetContent(content: '', image: null));
  }

  void updateThreadTweet(int index, {String? content, String? image}) {
    final current = threadTweetList[index];
    threadTweetList[index] = TweetContent(
      content: content ?? current.content,
      image: image ?? current.image,
    );
  }

  void removeThreadTweet(int index) {
    if (threadTweetList.length > 1) {
      threadTweetList.removeAt(index);
    }
  }

  Future<void> selectImage(XFile image) async {
    try {
      isLoading.value = true;
      final bytes = await File(image.path).readAsBytes();
      base64Image.value = base64Encode(bytes);
      imagePath.value = image.path;
      updateTweetState();
    } catch (e) {
      print("Error encoding image: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> postTweet() async {
    if (tweetController.text.isEmpty && base64Image.value.isEmpty) return null;

    try {
      final ref = await _firestore.collection('tweets').add({
        'userId': _auth.currentUser?.uid ?? 'anonymous',
        'timestamp': Timestamp.now(),
        'text': tweetController.text,
        'image': base64Image.value,
        'hasImage': base64Image.value.isNotEmpty,
        'likesCount': 0,
        'isPinned': false,
        'isThread': false,
        'parentTweetId': null,
        'threadRootId': null,
      });

      final tweetId = ref.id;
      await ref.update({'tweetId': tweetId});

      resetTweet();
      Get.back();
      return tweetId;
    } catch (e) {
      print("Error posting tweet: $e");
      return null;
    }
  }

  // Fetch Tweets
  void fetchTweets() {
    _firestore
        .collection('tweets')
        .where('parentTweetId', isNull: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          tweets.value =
              snapshot.docs.map((doc) => Tweet.fromFirestore(doc)).toList();
        });
  }

  Future<Tweet> fetchTweetById(String tweetId) async {
    final doc = await _firestore.collection('tweets').doc(tweetId).get();
    final tweet = Tweet.fromFirestore(doc);
    tweetMap[tweetId] = tweet;
    return tweet;
  }

  // Like
  Future<void> fetchLikedTweets() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final snapshot =
        await _firestore
            .collection('liked_tweets')
            .where('userId', isEqualTo: userId)
            .get();

    likedTweetIds.value =
        snapshot.docs.map((doc) => doc['tweetId'] as String).toSet();
  }

  bool isLiked(String tweetId) {
    return likedTweetIds.contains(tweetId);
  }

  Future<void> toggleLike(String tweetId, int currentLikesCount) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final likeDocId = '${userId}_$tweetId';
    final likeDocRef = _firestore.collection('liked_tweets').doc(likeDocId);
    final tweetRef = _firestore.collection('tweets').doc(tweetId);

    final likeDoc = await likeDocRef.get();

    if (likeDoc.exists) {
      await likeDocRef.delete();
      await tweetRef.update({'likesCount': FieldValue.increment(-1)});
      likedTweetIds.remove(tweetId);
    } else {
      await likeDocRef.set({
        'userId': userId,
        'tweetId': tweetId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await tweetRef.update({'likesCount': FieldValue.increment(1)});
      likedTweetIds.add(tweetId);
    }
    likedTweetIds.refresh();

    try {
      final updatedDoc = await tweetRef.get();
      final updatedTweet = Tweet.fromFirestore(updatedDoc);
      tweetMap[tweetId] = updatedTweet;
    } catch (e) {
      print("Error updating tweetMap after like: $e");
    }
  }

  // Pinning
  Future<void> pinTweet(String tweetId) async {
    final userId = _auth.currentUser?.uid;
    final tweetsRef = _firestore.collection('tweets');

    final userTweets = await tweetsRef.where('userId', isEqualTo: userId).get();
    for (var doc in userTweets.docs) {
      if (doc['isPinned'] == true && doc.id != tweetId) {
        await doc.reference.update({'isPinned': false});
      }
    }
    await tweetsRef.doc(tweetId).update({'isPinned': true});
  }

  Future<void> togglePin(String tweetId, bool currentState) async {
    final userId = _auth.currentUser?.uid;
    final tweetsRef = _firestore.collection('tweets');

    final userTweets = await tweetsRef.where('userId', isEqualTo: userId).get();
    for (var doc in userTweets.docs) {
      if (doc['isPinned'] == true && doc.id != tweetId) {
        await doc.reference.update({'isPinned': false});
      }
    }

    await tweetsRef.doc(tweetId).update({'isPinned': !currentState});
    isPinned.value = !currentState;
  }

  // Ownership check
  Future<void> loadTweetOwnership(String tweetId) async {
    final doc = await _firestore.collection('tweets').doc(tweetId).get();
    if (doc.exists) {
      final data = doc.data();
      final currentUserId = _auth.currentUser?.uid;

      tweetOwnerId.value = data?['userId'] ?? '';
      isPinned.value = data?['isPinned'] ?? false;
      isOwner.value = tweetOwnerId.value == currentUserId;
    }
  }

  // Delete tweet
  Future<void> deleteTweet(String tweetId, {bool isThreadRoot = false}) async {
    try {
      final batch = _firestore.batch();

      if (isThreadRoot) {
        // Hapus semua tweet dalam thread
        final snapshot =
            await _firestore
                .collection('tweets')
                .where('threadRootId', isEqualTo: tweetId)
                .get();

        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }

        // Juga hapus tweet utamanya sendiri
        final mainDocRef = _firestore.collection('tweets').doc(tweetId);
        batch.delete(mainDocRef);
      } else {
        // Hapus tweet tunggal
        final tweetRef = _firestore.collection('tweets').doc(tweetId);
        batch.delete(tweetRef);
      }

      await batch.commit();

      Get.snackbar(
        'Success',
        isThreadRoot ? 'Thread deleted' : 'Tweet deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete tweet',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Post thread tweet
  Future<void> postThreadTweetsFromList() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null || threadTweetList.isEmpty) return;

    try {
      final main = threadTweetList[0];
      if (main.isEmpty) return;

      final mainDocRef = await _firestore.collection('tweets').add({
        'userId': userId,
        'text': main.content,
        'image': main.image ?? '',
        'timestamp': Timestamp.now(),
        'likesCount': 0,
        'hasImage': main.image != null && main.image!.isNotEmpty,
        'isPinned': false,
        'isThread': threadTweetList.length > 1,
        'parentTweetId': null,
        'threadRootId': null,
        'tweetId': '',
      });

      final rootId = mainDocRef.id;

      await mainDocRef.update({'tweetId': rootId, 'threadRootId': rootId});

      // Buat replies (tweets lain dalam thread)
      String lastParentId = rootId;
      for (int i = 1; i < threadTweetList.length; i++) {
        final reply = threadTweetList[i];
        if (reply.isEmpty) continue;

        final replyDocRef = await _firestore.collection('tweets').add({
          'userId': userId,
          'text': reply.content,
          'image': reply.image ?? '',
          'timestamp': Timestamp.now(),
          'likesCount': 0,
          'hasImage': reply.image != null && reply.image!.isNotEmpty,
          'isPinned': false,
          'isThread': true,
          'parentTweetId': lastParentId,
          'threadRootId': rootId,
        });

        final replyId = replyDocRef.id;
        await replyDocRef.update({'tweetId': replyId});

        lastParentId = replyId;
      }

      threadTweetList.clear();
      fetchTweets();
      Get.back();

      Get.snackbar(
        'Thread Posted',
        'Your thread has been posted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to post thread: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
