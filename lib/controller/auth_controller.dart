import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_task/controller/user_controller.dart';
import 'package:twitter_task/services/auth_service.dart';
import 'package:twitter_task/views/auth/welcome_page.dart';
import 'package:twitter_task/views/home/home.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.put(AuthService());
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  RxBool isPasswordVisible = false.obs;

  RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // checkUserLoggedIn();
  }
  
  void checkUserLoggedIn() {
    if (_authService.currentUser != null) {
      Get.offAll(() => HomePage());
    } else {
      Get.offAll(() => WelcomePage());
    }
  }
  
  // Getters for accessing private properties
  bool isUserLoggedIn() {
    return _authService.isUserLoggedIn();
  }

  User? get currentUser => _authService.currentUser;
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  // Email & Password Login
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Login Error',
        'Please enter email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
      return;
    }
    
    try {
      isLoading.value = true;
      
      await _authService.signIn(
        email: emailController.text,
        password: passwordController.text
      );

      await Get.find<UserController>().fetchUserData();
      
      Get.snackbar(
        'Login',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white
      );
      
      // Navigate to home screen
      Get.offAll(() => HomePage());
    } catch (e) {
      Get.snackbar(
        'Login Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      await _authService.signInWithGoogle();

      await Get.find<UserController>().fetchUserData();
      
      Get.snackbar(
        'Google Sign In',
        'Successfully signed in with Google',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white
      );
      
      Get.offAll(() => HomePage());
    } catch (e) {
      if (e.toString() != 'Google sign in cancelled by user') {
        Get.snackbar(
          'Google Sign In Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  // Registration
  Future<void> register() async {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Registration Error',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
      return;
    }
    
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Registration Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
      return;
    }
    
    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Registration Error',
        'Please enter a password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
      return;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Registration Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
      return;
    }
    
    try {
      isLoading.value = true;
      
      await _authService.signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text
      );

      await Get.find<UserController>().fetchUserData();
      
      Get.snackbar(
        'Registration',
        'Registration successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white
      );
      
      // Navigate to home screen
      Get.offAll(() => HomePage());
    } catch (e) {
      Get.snackbar(
        'Registration Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Password Reset
  Future<void> forgetPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Forget Password Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
      return;
    }
    
    try {
      isLoading.value = true;
      
      await _authService.resetPassword(emailController.text);
      
      Get.snackbar(
        'Forget Password',
        'Password reset instructions sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white
      );
      
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Forget Password Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Sign Out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      
      Get.dialog(
        Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      
      // Sign out from Firebase
      await _authService.signOut();

      Get.find<UserController>().currentUser.value = null;
      
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      Get.offAll(() => WelcomePage());
      
      Get.snackbar(
        'Sign Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white
      );
      
    } catch (e) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      
      Get.snackbar(
        'Sign Out Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}