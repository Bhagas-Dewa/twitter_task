import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:twitter_task/models/tweet_model.dart';

class TweetController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var currentUser = Rxn<User>();

  var likedTweetIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLikedTweets();
    currentUser.value = _auth.currentUser;
  }

  Future<void> fetchLikedTweets() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await _firestore
        .collection('liked_tweets')
        .where('userId', isEqualTo: userId)
        .get();

    likedTweetIds.value = snapshot.docs.map((doc) => doc['tweetId'] as String).toSet();
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
      // UNLIKE
      await likeDocRef.delete();
      await tweetRef.update({'likesCount': FieldValue.increment(-1)});
      likedTweetIds.remove(tweetId);
    } else {
      // LIKE
      await likeDocRef.set({
        'userId': userId,
        'tweetId': tweetId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await tweetRef.update({'likesCount': FieldValue.increment(1)});
      likedTweetIds.add(tweetId);
    }

    likedTweetIds.refresh();
  }

  Future<void> pinTweet(String tweetId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final tweetsRef = FirebaseFirestore.instance.collection('tweets');

    // Unpin tweet lain dari user
    final userTweets = await tweetsRef.where('userId', isEqualTo: userId).get();
    for (var doc in userTweets.docs) {
      if (doc['isPinned'] == true && doc.id != tweetId) {
        await doc.reference.update({'isPinned': false});
      }
    }
    await tweetsRef.doc(tweetId).update({'isPinned': true});
  }

  Future<List<Tweet>> fetchUserTweets(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tweets')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    final allTweets = snapshot.docs.map((doc) => Tweet.fromFirestore(doc)).toList();

    Tweet? pinned;
    List<Tweet> others = [];

    for (var tweet in allTweets) {
      if (tweet.isPinned == true) {
        pinned = tweet;
      } else {
        others.add(tweet);
      }
    }

    if (pinned != null) {
      return [pinned, ...others];
    }
    return others;
  }



//   Future<void> updateAllHasImageField() async {
//   final tweetsSnapshot = await _firestore.collection('tweets').get();

//   for (var doc in tweetsSnapshot.docs) {
//     final data = doc.data();
//     final hasImage = (data['image'] as String?)?.isNotEmpty ?? false;

//     await doc.reference.update({'hasImage': hasImage});
//   }

//   print("Field 'hasImage' updated untuk semua tweet");
// }

}
