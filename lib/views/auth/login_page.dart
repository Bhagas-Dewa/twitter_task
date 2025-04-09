import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/auth_controller.dart';
import 'package:twitter_task/views/auth/forgetpassword_page.dart';
import 'package:twitter_task/views/auth/welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff4C9EEB),
          ), 
          onPressed: () {
            Get.to(() => WelcomePage());
          },
        ),
        title: const Text(
          'Sign in',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'HelveticaNeue500',
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Input
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                hintText: 'Enter email',
                hintStyle: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff687684),
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 241, 241, 241),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24, 
                  vertical: 16
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Password Input
            Obx(() => TextField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: 'Enter password',
                hintStyle: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff687684),
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 241, 241, 241),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24, 
                  vertical: 16
                ),
              ),
            )),

            const SizedBox(height: 55),

            // Login Button
            ElevatedButton(
              onPressed: controller.login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4C9EEB),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),elevation: 0,
              ), 
              child: const Text(
                'Email Login',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'HelveticaNeue900',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Forget Password
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Get.to(() => ForgetPasswordPage()),
                child: const Text(
                  'Forget password?',
                  style: TextStyle(
                    color: Color(0xff4C9EEB),
                    fontFamily: 'HelveticaNeue100',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ), 
            ), 
            SizedBox(height: 40),

            // Google Login
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: OutlinedButton.icon(
                onPressed: controller.signInWithGoogle,
                icon: Image.asset(
                  'assets/images/google.png',
                  height: 24,
                ),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    color: Color.fromARGB(255, 153, 153, 153),
                    fontFamily: 'HelveticaNeue800',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            )


          ],
        ),
      ),
      ),
      
    );
  }
}