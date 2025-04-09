import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/auth_controller.dart';
import 'package:twitter_task/views/auth/login_page.dart';

class ForgetPasswordPage extends StatelessWidget {
  ForgetPasswordPage({Key? key}) : super(key: key);

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff4C9EEB),
          ), 
          onPressed: () {
            Get.to(() => LoginPage());
          },
        ),
        title: const Text(
          'Forget Password',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'HelveticaNeue400',
              fontSize: 22,
            ),
          ),
        centerTitle: true,
        elevation: 0,
      ), 
      body: Padding(
        padding: const EdgeInsets.all(30),
        
        child: Center( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Forget Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'HelveticaNeue700',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your email address below to\nreceive password reset instruction',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff687684),
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 55),
              TextFormField(
                controller: _authController.emailController,
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
                    horizontal: 18, 
                    vertical: 16
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 35),
              
              ElevatedButton(
                onPressed: () {
                  _authController.forgetPassword();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4C9EEB),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ), elevation: 0,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'HelveticaNeue500',
                  fontWeight: FontWeight.w500,
                  color: Colors.white
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