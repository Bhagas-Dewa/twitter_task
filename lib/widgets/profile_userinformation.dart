import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/auth_controller.dart';

class ProfileUserInformation extends StatelessWidget {
  ProfileUserInformation({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = _authController.currentUser;
      final displayName = user?.displayName ?? 'Guest';
      final username = user?.displayName?.toLowerCase().replaceAll(' ', '') ?? 'guest';

      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'HelveticaNeue100',
              ),
            ),
            Text(
              '@$username',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff687684),
                fontFamily: 'HelveticaNeue',
              ),
            ),
            SizedBox(height: 10),
            _buildUserBio(),
            SizedBox(height: 8),
            _buildUserDescription(),
            SizedBox(height: 8),
            _buildUserStats(), 
            SizedBox(height: 8),
          ],
        ),
      );
    });
  }

  Widget _buildUserBio() {
    return const Text(
      "Digital Goodies Team - Web & Mobile UI/UX development; Graphics; Illustrations",
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'HelveticaNeue',
        fontWeight: FontWeight.w600,
        height: 1.25
      ),
    );
  }
  
  Widget _buildUserDescription() {
    return Row(
      children: [
        Image.asset(
          'assets/images/profile_link.png',
          height: 14,
          width: 14,
        ), SizedBox(width: 6),
        Text(
          'pixsellz.oi',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff4C9EEB),
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(width: 20),
        Image.asset(
          'assets/images/profile_calender.png',
          height: 14,
          width: 14,
        ), SizedBox(width: 6),
        Text(
          'Joined September 2018',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff687684),
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildUserStats() {
    return Row(
       children: [
        Text(
          '216',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'HelveticaNeue100',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
        ), SizedBox(width: 5),
        Text(
          'Following',
          style: TextStyle(
            color: Color(0xff687684),
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(width: 20),
        Text(
          '217',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'HelveticaNeue100',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
        ), SizedBox(width: 5),
        Text(
          'Followers',
          style: TextStyle(
            color: Color(0xff687684),
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );                   
  }

}
