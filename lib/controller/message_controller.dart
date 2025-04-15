import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/models/user_model.dart';
import '../models/message_model.dart';
import '../models/chat_room_model.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController _userController = Get.find<UserController>();

  final receiveMessages = false.obs;
  final qualityFilter = false.obs;
  final readReceipts = false.obs;

  final RxString chatId = ''.obs;
  final Rx<AppUser?> chattingWith = Rx<AppUser?>(null);

  void setReceiveMessages(bool value) => receiveMessages.value = value;
  void setQualityFilter(bool value) => qualityFilter.value = value;
  void setReadReceipts(bool value) => readReceipts.value = value;

  String _generateChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return sorted.join('_');
  }

  Future<String> getOrCreateChatRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    final sorted = [currentUserId, otherUserId]..sort();
    final chatId = sorted.join('_');

    final chatDoc = await _firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      final newChat = ChatRoomModel(
        chatId: chatId,
        participants: sorted,
        lastMessage: '',
        lastSenderId: '',
        lastTimestamp: DateTime.now(),
      );

      await _firestore.collection('chats').doc(chatId).set(newChat.toMap());
    }

    return chatId;
  }

  Future<void> prepareChatRoom(String otherUserId) async {
    final currentUser = _userController.currentUser.value;
    if (currentUser == null || otherUserId.isEmpty) {
      print('currentUser or otherUserId is null/empty');
      return;
    }

    final currentUserId = currentUser.uid;

    // buat chat room
    final id = await getOrCreateChatRoom(currentUserId, otherUserId);
    chatId.value = id;

    // Ambil user lawan
    final user = await _userController.getUserById(otherUserId);
    if (user == null) {
      print('Failed to fetch user for ID: $otherUserId');
    }
    chattingWith.value = user;
  }

  /// Send message to specific chat
  Future<void> sendMessage(String chatId, MessageModel message) async {
    final messagesRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    await messagesRef.add(message.toMap());

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message.text,
      'lastSenderId': message.senderId,
      'lastTimestamp': Timestamp.fromDate(message.timestamp ?? DateTime.now()),
    });
  }

  /// Stream messages in a chat room (ordered by time ascending)
  Stream<List<MessageModel>> streamMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => MessageModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  /// Ambil semua user kecuali user saat ini
  Future<List<AppUser>> fetchAllUsersExceptCurrent() async {
    final currentUserId = _userController.currentUser.value?.uid;
    if (currentUserId == null) return [];

    final snapshot = await _firestore.collection('users').get();

    return snapshot.docs
        .map((doc) => AppUser.fromMap(doc.data()))
        .where((user) => user.uid != currentUserId)
        .toList();
  }

  Future<AppUser?> fetchUserById(String uid) async {
    return await _userController.getUserById(uid);
  }

  final userCache = <String, AppUser>{}.obs;

  Future<void> preloadUsers(List<String> userIds) async {
    for (var id in userIds) {
      if (!userCache.containsKey(id)) {
        final user = await fetchUserById(id);
        if (user != null) {
          userCache[id] = user;
        }
      }
    }
  }
}
