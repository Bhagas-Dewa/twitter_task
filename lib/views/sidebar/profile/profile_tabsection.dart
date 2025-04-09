import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/profile_controller.dart';
import 'package:twitter_task/views/sidebar/profile/tab/tab_likes.dart';
import 'package:twitter_task/views/sidebar/profile/tab/tab_media.dart';
import 'package:twitter_task/views/sidebar/profile/tab/tab_tweets.dart';

class ProfileTabSection extends StatelessWidget {
  final ProfileController controller;

  const ProfileTabSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        // TabBar (pinned di luar CustomScrollView bisa juga)
        Container(
          color: Colors.white,
          child: TabBar(
            controller: controller.tabController,
            labelColor: const Color(0xFF4C9EEB),
            unselectedLabelColor: const Color(0xff687684),
            indicatorColor: const Color(0xFF4C9EEB),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Helveticaneue700',
              letterSpacing: -0.3,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Helveticaneue700',
              letterSpacing: -0.3,
            ),
            tabs: controller.tabs.map((e) => Tab(text: e)).toList(),
          ),
        ),

        // TabBarView
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            controller: controller.tabController,
            children: controller.tabs.map((tab) {
              if (tab == "Likes") return LikedTweetsTab();
              if (tab == "Media") return MediaTab();
              if (tab == "Tweets") return TweetsTab();
              return Center(child: Text('Konten $tab'));
            }).toList(),
          ),
        ),
      ]),
    );
  }
}
