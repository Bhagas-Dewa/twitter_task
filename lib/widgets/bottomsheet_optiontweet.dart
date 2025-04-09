import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/home_controller.dart';

class BottomSheetOptionTweet extends StatefulWidget {
  final String tweetId;
  const BottomSheetOptionTweet({Key? key, required this.tweetId}) : super(key: key);

  @override
  State<BottomSheetOptionTweet> createState() => _BottomSheetOptionTweetState();
}

class _BottomSheetOptionTweetState extends State<BottomSheetOptionTweet> {
  bool isPinned = false;
  bool isLoading = true;
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _fetchTweet();
  }

  Future<void> _fetchTweet() async {
    final doc = await FirebaseFirestore.instance.collection('tweets').doc(widget.tweetId).get();
    if (doc.exists) {
      final data = doc.data();
      setState(() {
        isPinned = data?['isPinned'] ?? false;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          _buildOption(
            'assets/images/option_link.png',
            'Copy link to tweet',
            const Color(0xffC4C4C4),
          ),
          _buildOption(
            'assets/images/option_pintoprofile.png',
            isPinned ? 'Unpin Tweet' : 'Pin to profile',
            Colors.black,
            () async {
              if (isPinned) {
                await FirebaseFirestore.instance
                    .collection('tweets')
                    .doc(widget.tweetId)
                    .update({'isPinned': false});
              } else {
                await FirebaseFirestore.instance
                    .collection('tweets')
                    .doc(widget.tweetId)
                    .update({'isPinned': true});
              }

              Get.back(); // Tutup bottom sheet
            },
          ),
          _buildOption(
            'assets/images/option_delete.png',
            'Delete Tweet',
            Colors.black,
            () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Delete Tweet'),
                  content: const Text('Are you sure you want to delete this tweet?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        homeController.deleteTweet(widget.tweetId);
                        Get.back(); // Close dialog
                        Get.back(); // Close bottom sheet
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
          _buildOption(
            'assets/images/option_mute.png',
            'Mute this conversation',
            const Color(0xffC4C4C4),
          ),
          _buildOption(
            'assets/images/option_viewhiddenreplies.png',
            'View hidden replies',
            const Color(0xffC4C4C4),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    String iconPath,
    String text,
    Color textColor, [
    VoidCallback? onTap,
  ]) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Image.asset(iconPath, height: 30),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Helveticaneue',
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.33,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
