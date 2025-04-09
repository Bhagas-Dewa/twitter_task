import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/auth_controller.dart';
import 'package:twitter_task/views/auth/login_page.dart';
import 'package:twitter_task/views/auth/register_page.dart';
import 'package:twitter_task/views/home/home.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthController authController = Get.find<AuthController>();
  bool isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (authController.isUserLoggedIn()) {
      Get.offAll(() => HomePage());
    }

    setState(() {
      isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking authentication
    if (isChecking) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/TwitterLogo.svg',
                height: 50,
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4C9EEB)),
              ),
            ],
          ),
        ),
      );
    }
    
    // Show the regular welcome page content after checking
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
          'assets/images/TwitterLogo.svg',
          height: 30,
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'See what\'s happening in the world right now.',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.to(RegisterPage()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4C9EEB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Create account',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue100',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ), 
                  ), 
                ), 
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 40, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Have an account already? ',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(LoginPage()),
              child: Text(
                'Log in',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  color: Color(0xff4C9EEB),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}