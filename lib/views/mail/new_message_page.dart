import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/message_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/models/user_model.dart';
import 'package:twitter_task/services/auth_service.dart';
import 'package:twitter_task/views/mail/roomchat_page.dart';

class NewMessagePage extends StatelessWidget {
  final MessageController messageController = Get.put(MessageController());
  final UserController userController = Get.find<UserController>();
  final authService = Get.find<AuthService>();

  NewMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: _buildAppBar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: FutureBuilder<List<AppUser>>(
                future: messageController.fetchAllUsersExceptCurrent(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }

                  final users = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                final currentUser = authService.currentUser;
                                  if (currentUser == null) return;

                                  //room chat dan data lawan bicara
                                  await messageController.prepareChatRoom(user.uid);
                                  Get.to(() => RoomChatPage(otherUserId: '',));
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundImage:
                                        user.profilePicture.isNotEmpty
                                            ? MemoryImage(
                                              base64Decode(user.profilePicture),
                                            )
                                            : const AssetImage(
                                                  'assets/images/photoprofile_dummy.png',
                                                )
                                                as ImageProvider,
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Helveticaneue100',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          user.username,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Helveticaneue100',
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff687684),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 0.33,
                            height: 1,
                            color: Color(0xffCED5DC),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      title: const Text(
        'New message',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          fontFamily: 'Helveticaneue100',
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: const BoxDecoration(color: Color(0xffE7ECF0)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search for people and groups',
          hintStyle: const TextStyle(
            fontSize: 17,
            fontFamily: 'Helveticaneue',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.4,
          ),
          icon: Image.asset(
            'assets/images/appbarsearch_search.png',
            width: 14,
            height: 14,
          ),
        ),
      ),
    );
  }
}
