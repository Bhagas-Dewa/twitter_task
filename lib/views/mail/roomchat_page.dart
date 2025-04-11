import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/message_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/models/message_model.dart';
import 'package:twitter_task/models/user_model.dart';

class RoomChatPage extends StatefulWidget {
  final String otherUserId;

  const RoomChatPage({super.key, required this.otherUserId});

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final MessageController _messageController = Get.find<MessageController>();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageController.prepareChatRoom(widget.otherUserId);

    Future.delayed(Duration(seconds: 1), () {
      print('🔁 Chat ID: ${_messageController.chatId.value}');
      print(
        '🧍 Current user: ${Get.find<UserController>().currentUser.value?.uid}',
      );
      print(
        '🧑‍💼 Chatting with: ${_messageController.chattingWith.value?.uid}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.1,
        shadowColor: Color(0xffBDC5CD),
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        title: Obx(() {
          final user = _messageController.chattingWith.value;
          if (user == null) return const SizedBox.shrink();

          return Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage:
                    user.profilePicture.isNotEmpty
                        ? MemoryImage(base64Decode(user.profilePicture))
                        : const AssetImage(
                              'assets/images/photoprofile_dummy.png',
                            )
                            as ImageProvider,
              ),
              SizedBox(width: 10),
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'HelveticaNeue100',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/roomchat_vc.png', width: 24),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Image.asset('assets/images/roomchat_call.png', width: 22),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Obx(() {
        final chatId = _messageController.chatId.value;
        if (chatId.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: _messageController.streamMessages(chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data ?? [];

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe =
                          message.senderId ==
                          Get.find<UserController>().currentUser.value?.uid;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Color(0xff4C9EEB) : Color(0xffE7ECF0),
                            borderRadius:
                                isMe
                                    ? BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(3),
                                    )
                                    : BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(3),
                                    ),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontFamily: 'Helveticaneue',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.33,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 4, top: 12, bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xffE7ECF0),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color(0xff687684),
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xff4C9EEB)),
                    onPressed: () {
                      final text = _textController.text.trim();
                      if (text.isNotEmpty) {
                        final msg = MessageModel(
                          senderId:
                              Get.find<UserController>().currentUser.value!.uid,
                          text: text,
                          timestamp: DateTime.now(),
                        );

                        _messageController.sendMessage(chatId, msg);
                        _textController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
