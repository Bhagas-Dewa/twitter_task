import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/user_controller.dart';

class ProfileUserInformation extends StatelessWidget {
  ProfileUserInformation({super.key});

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = userController.currentUser.value;

      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'HelveticaNeue100',
              ),
            ),
            Text(
              user.username,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff687684),
                fontFamily: 'HelveticaNeue',
              ),
            ),

            const SizedBox(height: 10),
            _buildUserBio(),
            const SizedBox(height: 8),
            _buildUserDescription(),
            const SizedBox(height: 8),
            _buildUserStats(),
            const SizedBox(height: 8),
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
        height: 1.25,
      ),
    );
  }

  Widget _buildUserDescription() {
    return Row(
      children: [
        Image.asset('assets/images/profile_link.png', height: 14, width: 14),
        const SizedBox(width: 6),
        const Text(
          'pixsellz.oi',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff4C9EEB),
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 20),
        Image.asset(
          'assets/images/profile_calender.png',
          height: 14,
          width: 14,
        ),
        const SizedBox(width: 6),
        const Text(
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
        const Text(
          '216',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'HelveticaNeue100',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 5),
        const Text(
          'Following',
          style: TextStyle(
            color: Color(0xff687684),
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 20),
        const Text(
          '217',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'HelveticaNeue100',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 5),
        const Text(
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
