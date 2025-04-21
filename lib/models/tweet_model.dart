import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String id;
  final String userId;
  final String content;
  final String? image;
  final DateTime timestamp;
  final int? likesCount;
  final bool hasImage;
  final bool isPinned;
  final bool isThread;
  final String? parentTweetId;
  final String? threadRootId;
  final int retweetsCount;
  final String? quotedTweetId; 
  final String? quotedTweetContent;
  final String? quotedTweetUserId; 

  Tweet({
    required this.id,
    required this.userId,
    required this.content,
    this.image,
    required this.timestamp,
    this.likesCount,
    this.retweetsCount = 0,
    required this.hasImage,
    required this.isPinned,
    this.isThread = false,
    this.parentTweetId,
    this.threadRootId,
    this.quotedTweetId,
    this.quotedTweetContent,
    this.quotedTweetUserId,
  });

  factory Tweet.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Tweet(
      id: doc.id,
      userId: data['userId'] ?? '',
      content: data['text'] ?? '',
      image: data.containsKey('image') ? data['image'] as String? : null,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likesCount: data['likesCount'] ?? 0,
      retweetsCount: data['retweetsCount'] ?? 0,
      hasImage: data['hasImage'] ?? false,
      isPinned: data['isPinned'] ?? false,
      isThread: data['isThread'] ?? false,
      parentTweetId: data['parentTweetId'],
      threadRootId: data['threadRootId'],
      quotedTweetId: data['quotedTweetId'],
      quotedTweetContent: data['quotedTweetContent'],
      quotedTweetUserId: data['quotedTweetUserId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'text': content,
      'image': image,
      'timestamp': Timestamp.fromDate(timestamp),
      'likesCount': likesCount,
      'hasImage': image != null && image!.isNotEmpty,
      'isPinned': isPinned,
      'isThread': isThread,
      'parentTweetId': parentTweetId,
      'threadRootId': threadRootId,
      'retweetsCount': retweetsCount,
      'quotedTweetId': quotedTweetId,
      'quotedTweetContent': quotedTweetContent,
      'quotedTweetUserId': quotedTweetUserId,
    };
  }

  Tweet copyWith({
    String? id,
    String? userId,
    String? content,
    String? image,
    DateTime? timestamp,
    int? likesCount,
    int? retweetsCount,
    bool? hasImage,
    bool? isPinned,
    bool? isThread,
    String? parentTweetId,
    String? threadRootId,
    String? quotedTweetId,
    String? quotedTweetContent,
    String? quotedTweetUserId,
  }) {
    return Tweet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      image: image ?? this.image,
      timestamp: timestamp ?? this.timestamp,
      likesCount: likesCount ?? this.likesCount,
      retweetsCount: retweetsCount ?? this.retweetsCount,
      hasImage: hasImage ?? this.hasImage,
      isPinned: isPinned ?? this.isPinned,
      isThread: isThread ?? this.isThread,
      parentTweetId: parentTweetId ?? this.parentTweetId,
      threadRootId: threadRootId ?? this.threadRootId,
      quotedTweetId: quotedTweetId ?? this.quotedTweetId,
      quotedTweetContent: quotedTweetContent ?? this.quotedTweetContent,
      quotedTweetUserId: quotedTweetUserId ?? this.quotedTweetUserId,
    );
  }
}
