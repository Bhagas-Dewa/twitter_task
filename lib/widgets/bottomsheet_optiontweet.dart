import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/tweet_controller.dart';

class BottomSheetOptionTweet extends StatefulWidget {
  final String tweetId;
  const BottomSheetOptionTweet({Key? key, required this.tweetId})
    : super(key: key);

  @override
  State<BottomSheetOptionTweet> createState() => _BottomSheetOptionTweetState();
}

class _BottomSheetOptionTweetState extends State<BottomSheetOptionTweet> {
  final TweetController tweetController = Get.find<TweetController>();

  @override
  void initState() {
    super.initState();
    tweetController.loadTweetOwnership(widget.tweetId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOwner = tweetController.isOwner.value;
      final isPinned = tweetController.isPinned.value;

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
            const SizedBox(height: 12),
            _buildOption(
              isOwner
                  ? 'assets/images/option_link_false.png'
                  : 'assets/images/option_link.png',
              'Copy link to tweet',
              isOwner ? const Color(0xffC4C4C4) : Colors.black,
              isOwner ? null : () {},
            ),
            _buildOption(
              isOwner
                  ? 'assets/images/option_pin.png'
                  : 'assets/images/option_pin_false.png',
              isPinned ? 'Unpin Tweet' : 'Pin to profile',
              isOwner ? Colors.black : const Color(0xffC4C4C4),
              isOwner
                  ? () async {
                    await tweetController.togglePin(widget.tweetId, isPinned);
                    Get.back();
                  }
                  : null,
            ),
            _buildOption(
              isOwner
                  ? 'assets/images/option_delete.png'
                  : 'assets/images/option_delete_false.png',
              'Delete Tweet',
              isOwner ? Colors.black : const Color(0xffC4C4C4),
              isOwner
                  ? () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Delete Tweet'),
                        content: const Text(
                          'Are you sure you want to delete this tweet?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Ambil data tweet untuk cek apakah ini tweet utama dalam thread
                              final doc =
                                  await FirebaseFirestore.instance
                                      .collection('tweets')
                                      .doc(widget.tweetId)
                                      .get();

                              final data = doc.data();
                              final isThreadRoot =
                                  data?['isThread'] == true &&
                                  data?['parentTweetId'] == null;

                              await tweetController.deleteTweet(
                                widget.tweetId,
                                isThreadRoot: isThreadRoot,
                              );

                              tweetController.fetchTweets();
                              Get.back();
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  : null,
            ),
            _buildOption(
              isOwner
                  ? 'assets/images/option_mute_false.png'
                  : 'assets/images/option_mute.png',
              'Mute this conversation',
              isOwner ? const Color(0xffC4C4C4) : Colors.black,
              isOwner ? null : () {},
            ),
            _buildOption(
              isOwner
                  ? 'assets/images/option_hidden_false.png'
                  : 'assets/images/option_hidden.png',
              'View hidden replies',
              isOwner ? const Color(0xffC4C4C4) : Colors.black,
              isOwner ? null : () {},
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOption(
    String iconPath,
    String text,
    Color textColor,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Image.asset(iconPath, height: 24),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
