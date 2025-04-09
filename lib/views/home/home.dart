import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_task/controller/auth_controller.dart';
import 'package:twitter_task/views/home/addtweet_page.dart';
import 'package:twitter_task/widgets/appbar_home.dart';
import 'package:twitter_task/widgets/bottom_navbar.dart';
import 'package:twitter_task/controller/home_controller.dart';
import 'package:twitter_task/widgets/tweet_item.dart';

class HomePage extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final HomeController homeController = Get.put(HomeController());

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarHome(),

       body: Obx(() {
        if (homeController.tweets.isEmpty) {
          return Center(child: Text("No tweets available"));
        }
        return ListView.builder(
          itemCount: homeController.tweets.length,
          itemBuilder: (context, index) {
            final tweet = homeController.tweets[index];
            return TweetItem(tweet: tweet);
          },
        );
      }),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          homeController.resetTweet();
          Get.to(()=> AddTweetPage()
          );
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