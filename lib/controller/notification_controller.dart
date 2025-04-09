import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/models/notification_model.dart';

class NotificationController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var selectedIndex = 0.obs;

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxList<MentionModel> mentions = <MentionModel>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
      update();
    });
    loadDummyNotifications();
    loadDummyMentions();
  }

  void loadDummyNotifications() {
    notifications.addAll([
      NotificationModel(
        profileImage: 'assets/images/notif_pp1.png',
        starImage: 'assets/images/notificon_star.png',
        username: 'Saad Drusteer',
        content: 'Are you using WordPress and migrating to the JAMstack? I wrote up a case study about how Smashing Magazine moved to JAMstack and saw great performance improvements and better security.',
        link: 'smashingdrusteer.com/2020/01/migration',
      ),
      NotificationModel(
        profileImage: 'assets/images/notif_pp2.png',
        starImage: 'assets/images/notificon_star.png',
        username: 'UX Upper',
        content: 'Creating meaningful experiences: an introduction to User Experience design >',
        link: 'www.ly/p0fx50y5CoO',
      ),
      NotificationModel(
        profileImage: 'assets/images/notif_pp3.png',
        starImage: 'assets/images/notificon_star.png',
        username: 'Teador VAN SCHNEIDER',
        content: 'I\'m always surprised how few designers are also serious gamers. Curious why that is.',
        link: 'www.google.com',
      ),
    ]);
  }

  void loadDummyMentions() {
    mentions.addAll([
      MentionModel(
        name: 'Mariane',
        username: '@marianeee',
        date: '1/21/20',
        profileImage: 'assets/images/mention_pp1.png',
        mentionText: 'Hey',
        taggedUsers: '@theflaticon @iconmonstr @pixsellz @danielbruce_ @romanshamin @_vect_ @glyphish',
        articleText: 'Check our new article "Top Icons Packs and Resources for Web" You are in! \n😎',
        link: '👉🏻 marianeee.com/blog/top-icons...',
        mentionImage: 'assets/images/mention_pict1.png',
        comments: 7,
        retweets: 1,
        likes: 3,
      ),
      MentionModel(
        name: 'John Doe',
        username: '@johndoe',
        date: '2/15/20',
        profileImage: 'assets/images/mention_pp2.png',
        mentionText: 'Check this out!',
        taggedUsers: '@flutter @dart @firebase',
        articleText: 'A new way to build apps with Flutter.',
        link: '👉🏻 johndoe.com/flutter-news',
        mentionImage: 'assets/images/mention_pict3.png',
        comments: 12,
        retweets: 5,
        likes: 20,
      ),
    ]);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
