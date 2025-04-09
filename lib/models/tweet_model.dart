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


  Tweet({
    required this.id,
    required this.userId,
    required this.content,
    this.image, 
    required this.timestamp,
    this.likesCount,
    required this.hasImage,
    required this.isPinned,
  });

  factory Tweet.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Tweet(
      id: doc.id,
      userId: data['userId'] ?? '',
      content: data.containsKey('text') ? data['text'] as String : '',
      image: data.containsKey('image') ? data['image'] as String? : null,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likesCount: data['likesCount'] ?? 0,
      hasImage: data['hasImage'] ?? false,
      isPinned: data['isPinned'] ?? false,
    );
  }

  // Convert Tweet object ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'content': content,
      'image': image,
      'timestamp': Timestamp.fromDate(timestamp),
      'likesCount': likesCount,
      'hasImage': image != null && image!.isNotEmpty,
      'isPinned': isPinned, 
    };
  }
}
