import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Create a Rx variable to track user state
  Rxn<User> user = Rxn<User>();
  
  // Getter for current user
  User? get currentUser => user.value;
  
  // Constructor to initialize the user state listener
  AuthService() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      user.value = firebaseUser;
    });
  }
  
  // Check if user is logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
  
  // Email & Password Sign Up
  Future<UserCredential> signUp({
    required String name, 
    required String email, 
    required String password
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      // Update user display name
      await userCredential.user?.updateDisplayName(name);
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Rethrow with more descriptive message
      String errorMessage = _getAuthErrorMessage(e);
      throw errorMessage;
    }
  }
  
  // Email & Password Sign In
  Future<UserCredential> signIn({required String email, required String password}) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getAuthErrorMessage(e);
      throw errorMessage;
    }
  }
  
  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw 'Google sign in cancelled by user';
      }
      
      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in with Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (e is String) {
        throw e;
      }
      throw 'Error signing in with Google: ${e.toString()}';
    }
  }
  
  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Sign out from Google
    await _auth.signOut(); // Sign out from Firebase

    // user.value = null;
  }
  
  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getAuthErrorMessage(e);
      throw errorMessage;
    }
  }
  
  // Helper method to get human-readable error messages
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password. Please try again.';
      case 'email-already-in-use':
        return 'Email is already in use. Please use a different email.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}