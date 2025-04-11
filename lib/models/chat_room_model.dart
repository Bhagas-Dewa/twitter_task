import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final String lastSenderId;
  final DateTime? lastTimestamp;

  ChatRoomModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastSenderId,
    this.lastTimestamp,
  });

  factory ChatRoomModel.fromMap(String id, Map<String, dynamic> map) {
    return ChatRoomModel(
      chatId: id,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastSenderId: map['lastSenderId'] ?? '',
      lastTimestamp: (map['lastTimestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'lastTimestamp': lastTimestamp != null
          ? Timestamp.fromDate(lastTimestamp!)
          : null,
    };
  }
}

