import 'package:flutter/material.dart';
import 'package:twitter_task/widgets/appbar_mail.dart';
import 'package:twitter_task/widgets/appbar_notification.dart';
import 'package:twitter_task/widgets/bottom_navbar.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarMail(),
      body: Text('data'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: Color(0xff4C9EEB),
        shape: CircleBorder(),
        elevation: 2,
        child: Image.asset(
          'assets/images/fab_mail.png', 
          height: 23,
          width: 21,
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}