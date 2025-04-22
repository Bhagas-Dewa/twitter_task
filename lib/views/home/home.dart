import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_task/controller/auth_controller.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/models/retweet_model.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/views/home/addtweet_page.dart';
import 'package:twitter_task/widgets/appbar_home.dart';
import 'package:twitter_task/widgets/bottom_navbar.dart';
import 'package:twitter_task/controller/home_controller.dart';
import 'package:twitter_task/widgets/retweet_item.dart';
import 'package:twitter_task/widgets/tweet_item.dart';

class HomePage extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final TweetController tweetController = Get.find<TweetController>();
  final HomeController homeController = Get.put(HomeController());

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarHome(),

      body: Obx(() {
        if (homeController.feedItems.isEmpty) {
          return Center(child: Text("No feed items available"));
        }

        return RefreshIndicator(
          onRefresh: homeController.refreshFeed,
          child: ListView.builder(
            itemCount: homeController.feedItems.length,
            itemBuilder: (context, index) {
              final item = homeController.feedItems[index];

               if (item['type'] == 'tweet') {
                final tweet = item['data'] as Tweet;
                return TweetItem(tweet: tweet);
              } else if (item['type'] == 'retweet') {
                final retweet = item['data'] as Retweet;
                return RetweetItem(retweet: retweet);
              }

              return SizedBox.shrink(); 
            },
          ),
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<TweetController>().resetTweet();
          Get.to(() => AddTweetPage());
        },
        backgroundColor: Color(0xff4C9EEB),
        shape: CircleBorder(),
        elevation: 2,
        child: Image.asset(
          'assets/images/floating_addtweet.png',
          height: 23,
          width: 21,
        ),
      ),

      bottomNavigationBar: BottomNavBar(),
    );
  }
}
