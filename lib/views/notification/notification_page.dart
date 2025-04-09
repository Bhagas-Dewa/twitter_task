import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/notification_controller.dart';
import 'package:twitter_task/views/home/addtweet_page.dart';
import 'package:twitter_task/widgets/appbar_notification.dart';
import 'package:twitter_task/widgets/bottom_navbar.dart';
import 'package:twitter_task/widgets/allnotification_list.dart';
import 'package:twitter_task/widgets/mention_list.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarNotification(),
      body: Column(
        children: [
          TabBar(
                controller: controller.tabController,
                padding: EdgeInsets.only(bottom: 5),
                tabs: const [
                  Tab(text: 'All',),
                  Tab(text: 'Mentions'),
                ],
                indicatorColor: const Color(0xff4C9EEB),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: const Color(0xff4C9EEB),
                unselectedLabelColor: const Color(0xff687684),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500, 
                  fontFamily: 'Helveticaneue100',
                  color: Color(0xff4C9EEB),
                  fontSize: 16,
                  letterSpacing: -0.3,
                  ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Helveticaneue100',
                  color: Color(0xff687684),
                  fontSize: 16,
                  letterSpacing: -0.3,
                  ),
              ), 
          Expanded(
            child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    NotificationList(),
                    MentionList(mentions: controller.mentions),

                  ],
                )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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

  @override
  void dispose() {
    super.dispose();
  }
}
