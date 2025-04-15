import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/auth_controller.dart';
import 'package:twitter_task/controller/message_controller.dart';
import 'package:twitter_task/models/chat_room_model.dart';
import 'package:twitter_task/views/mail/new_message_page.dart';
import 'package:twitter_task/views/mail/roomchat_page.dart';
import 'package:twitter_task/widgets/appbar_mail.dart';
import 'package:twitter_task/widgets/bottom_navbar.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  final authService = Get.find<AuthController>();
  final messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    final currentUserId = authService.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarMail(),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('chats')
                .where('participants', arrayContains: currentUserId)
                .orderBy('lastTimestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages yet.'));
          }

          final chats =
              snapshot.data!.docs.map((doc) {
                return ChatRoomModel.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                );
              }).toList();

          final otherUserIds =
              chats
                  .map(
                    (chat) => chat.participants.firstWhere(
                      (id) => id != currentUserId,
                    ),
                  )
                  .toSet()
                  .toList();

          return FutureBuilder(
            future: messageController.preloadUsers(otherUserIds),
            builder: (context, preloadSnapshot) {
              if (preloadSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                itemCount: chats.length,
                separatorBuilder:
                    (_, __) =>
                        Divider(thickness: 0.33, color: Color(0xffCED5DC), height: 0.5,),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final otherUserId = chat.participants.firstWhere(
                    (id) => id != currentUserId,
                  );
                  final user = messageController.userCache[otherUserId];

                  if (user == null) return const SizedBox.shrink();

                  final isMe = chat.lastSenderId == currentUserId;
                  final lastMsg =
                      isMe ? 'You: ${chat.lastMessage}' : chat.lastMessage;

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 27.5,
                      backgroundImage:
                          user.profilePicture.isNotEmpty
                              ? MemoryImage(base64Decode(user.profilePicture))
                              : const AssetImage(
                                    'assets/images/photoprofile_dummy.png',
                                  )
                                  as ImageProvider,
                    ),
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'HelveticaNeue100',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            user.username,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.w600,
                              color: Color(0xff687684),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),

                    subtitle: Text(
                      lastMsg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'HelveticaNeue',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff687684),
                        letterSpacing: -0.1,
                      ),
                    ),
                    onTap: () async {
                      await messageController.prepareChatRoom(user.uid);
                      if (messageController.chatId.value.isNotEmpty &&
                          messageController.chattingWith.value != null) {
                        Get.to(() => RoomChatPage(otherUserId: user.uid));
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => NewMessagePage());
        },
        backgroundColor: const Color(0xff4C9EEB),
        shape: const CircleBorder(),
        elevation: 2,
        child: Image.asset('assets/images/fab_mail.png', height: 23, width: 21),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
