import 'package:cloud_firestore/cloud_firestore.dart';

class Retweet {
  final String id;
  final String userId;
  final String tweetId;
  final String originalTweetUserId;
  final DateTime timestamp;
  final bool isQuote; 
  final String? quoteText; 
  final int?likesCount;

  Retweet({
    required this.id,
    required this.userId,
    required this.tweetId,
    required this.originalTweetUserId,
    required this.timestamp,
    this.isQuote = false,
    this.quoteText,
    this.likesCount,
  });

  factory Retweet.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Retweet(
      id: doc.id,
      userId: data['userId'] ?? '',
      tweetId: data['tweetId'] ?? '',
      originalTweetUserId: data['originalTweetUserId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isQuote: data['isQuote'] ?? false,
      quoteText: data['quoteText'],
      likesCount: data['likesCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'tweetId': tweetId,
      'originalTweetUserId': originalTweetUserId,
      'timestamp': Timestamp.fromDate(timestamp),
      'isQuote': isQuote,
      'quoteText': quoteText,
      'likesCount': likesCount,
    };
  }

  Retweet copyWith({
    String? id,
    String? userId,
    String? tweetId,
    String? originalTweetUserId,
    DateTime? timestamp,
    bool? isQuote,
    String? quoteText,
    int? likesCount,
  }) {
    return Retweet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tweetId: tweetId ?? this.tweetId,
      originalTweetUserId: originalTweetUserId ?? this.originalTweetUserId,
      timestamp: timestamp ?? this.timestamp,
      isQuote: isQuote ?? this.isQuote,
      quoteText: quoteText ?? this.quoteText,
      likesCount: likesCount ?? this.likesCount,
    );
  }
}