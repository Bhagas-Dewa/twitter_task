import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Initialize the AuthController
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
            Get.back();
          },
        ),
        title: const Text(
          'Sign Up',
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Input
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 17,
                  letterSpacing: 0,
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
              const SizedBox(height: 25),

              // Email Input
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email',
                    hintStyle: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 17,
                    letterSpacing: 0,
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
              const SizedBox(height: 25),

              // Password Input
              Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                    hintStyle: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 17,
                    letterSpacing: 0,
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
              const SizedBox(height: 25),

              // Confirm Password Input
              TextField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                    hintStyle: TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 17,
                    letterSpacing: 0,
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
              const SizedBox(height: 50),

              // Sign Up Button
              ElevatedButton(
                onPressed: controller.register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4C9EEB),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}