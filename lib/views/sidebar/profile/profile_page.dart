import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/profile_controller.dart';
import 'package:twitter_task/views/home/addtweet_page.dart';
import 'package:twitter_task/views/sidebar/profile/profile_tabsection.dart';
import 'package:twitter_task/widgets/bottom_navbar.dart';
import 'package:twitter_task/widgets/profile_userinformation.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final controller = Get.put(ProfileController());

  final double bannerHeight = 138;
  final double avatarRadius = 34;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Banner, back button, avatar, dan edit
          SliverToBoxAdapter(
            child: SizedBox(
              height: bannerHeight + avatarRadius,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: bannerHeight,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/profile_banner.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 8),
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Image.asset(
                          'assets/images/profile_backbanner.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 115,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        Container(
                          width: avatarRadius * 2,
                          height: avatarRadius * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/sidebar_pp.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Color(0xFF4C9EEB)),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Edit profile',
                                  style: TextStyle(
                                    color: Color(0xFF4C9EEB),
                                    fontSize: 14,
                                    fontFamily: 'Helveticaneue100',
                                    letterSpacing: -0.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Informasi profil
          SliverToBoxAdapter(
            child: ProfileUserInformation(),
          ),

          // TabBar + TabBarView
          ProfileTabSection(controller: controller),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddTweetPage()),
        backgroundColor: const Color(0xff4C9EEB),
        shape: const CircleBorder(),
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
