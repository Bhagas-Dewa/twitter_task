import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/retweet_controller.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/views/home/add_retweet_page.dart';

class BottomSheetRetweet extends StatelessWidget {
  final Tweet tweet;
  const BottomSheetRetweet({
    Key? key,
    required this.tweet, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
        children: [
          Center(
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildOption(
            'assets/images/bottomsheet_retweet.png',
            'Retweet',
            Colors.black,
            () {
              Get.to(() => AddRetweetPage(tweet: tweet));
            },
          ),
          _buildOption(
            'assets/images/bottomsheet_retweetwithquote.png',
            'Retweet with Quote',
            Colors.black,
            () {
              Get.to(() => AddRetweetPage(tweet: tweet, isQuoteRetweet: true));
            },
          ),
          SizedBox(height: 15),
          Center(
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffE7ECF0),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextButton(
                onPressed: () {
                  // Logic for Cancel
                  Get.back();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    String iconPath,
    String text,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Image.asset(iconPath, height: 20, width: 24),
            const SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                fontSize: 19,
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
