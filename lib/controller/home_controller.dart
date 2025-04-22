import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/models/retweet_model.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var feedItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeed();
  }

  Future<void> fetchFeed() async {
    try {
      final tweetsQuery =
          await _firestore
              .collection('tweets')
              .where('parentTweetId', isNull: true)
              .orderBy('timestamp', descending: true)
              .get();

      final retweetsQuery =
          await _firestore
              .collection('tweets')
              .where('isRetweet', isEqualTo: true)
              .orderBy('timestamp', descending: true)
              .get();

      final feedList = await Future.wait([
        ...tweetsQuery.docs.map((doc) async {
          final tweet = Tweet.fromFirestore(doc);
          print('Retweet Details:');
          print('Tweet ID: ${tweet.id}');
          print('Text: ${tweet.content}');
          print('Is Quote: ${tweet.quotedTweetId != null}');
          print('Quote Text: ${tweet.quotedTweetContent}');
          return {
            'type': 'tweet',
            'data': tweet,
            'timestamp': (doc.data()['timestamp'] as Timestamp).toDate(),
          };
        }),
        ...retweetsQuery.docs.map((doc) async {
          final tweet = Tweet.fromFirestore(doc);

          final retweet = Retweet(
            id: tweet.id,
            userId: tweet.userId,
            tweetId: tweet.originalTweetId ?? '',
            originalTweetUserId: tweet.originalTweetUserId ?? '',
            timestamp: tweet.timestamp,
            isQuote:tweet.quotedTweetId != null,
            quoteText: tweet.content,
          );

          return {
            'type': 'retweet',
            'data': retweet,
            'timestamp': tweet.timestamp,
          };
        }),
      ]);

      feedItems.value =
          feedList.where((item) => item['timestamp'] != null).toList()..sort(
            (a, b) => (b['timestamp'] as DateTime).compareTo(
              a['timestamp'] as DateTime,
            ),
          );
    } catch (e) {
      print('Error fetching feed: $e');
      feedItems.clear();
    }
  }

  Future<void> refreshFeed() async {
    await fetchFeed();
  }

  void sortFeedByNewest() {
    feedItems.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
  }

  List<Map<String, dynamic>> getTweetItems() {
    return feedItems.where((item) => item['type'] == 'tweet').toList();
  }

  List<Map<String, dynamic>> getRetweetItems() {
    return feedItems.where((item) => item['type'] == 'retweet').toList();
  }
}
