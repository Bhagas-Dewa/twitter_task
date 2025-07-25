import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/auth_controller.dart';
import 'package:twitter_task/controller/lists_controller.dart';
import 'package:twitter_task/controller/message_controller.dart';
import 'package:twitter_task/controller/retweet_controller.dart';
import 'package:twitter_task/controller/tweet_controller.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/views/auth/welcome_page.dart';
import 'package:twitter_task/services/auth_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );

  // Inisialisasi controller dengan GetX
  Get.put(UserController());
  Get.put(AuthController());
  Get.put(AuthService());
  Get.put(MessageController());
  Get.put(TweetController());
  Get.put(RetweetController());
  Get.put(ListsController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      theme: ThemeData(fontFamily: 'HelveticaNeue'),
    );
  }
}
