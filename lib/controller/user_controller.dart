import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_task/models/user_model.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Map<String, AppUser> _userCache = {};
  Rx<AppUser?> currentUser = Rx<AppUser?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      currentUser.value = AppUser.fromMap(doc.data()!);
    } else {
      await createDefaultUser();
    }
  }

  Future<void> createDefaultUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;

    final name = firebaseUser.displayName ?? 'user';
    final generatedUsername = '@${name.toLowerCase().replaceAll(' ', '')}';

    final user = AppUser(
      uid: firebaseUser.uid,
      name: name,
      username: generatedUsername,
      profilePicture: '', 
    );

    await _firestore.collection('users').doc(firebaseUser.uid).set(user.toMap());
    currentUser.value = user;
  }

  Future<void> updateUser({
    required String name,
    required String username,
    String? newBase64Image,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final updatedData = {
      'name': name,
      'username': username,
      if (newBase64Image != null) 'profilePicture': newBase64Image,
    };

    await _firestore.collection('users').doc(uid).update(updatedData);

    currentUser.value = AppUser(
      uid: uid,
      name: name,
      username: currentUser.value?.username ?? '',
      profilePicture: newBase64Image ?? currentUser.value?.profilePicture ?? '',
    );
  }

  Future<String> getDefaultProfileBase64() async {
    final byteData = await rootBundle.load('assets/images/default_profile.png');
    final bytes = byteData.buffer.asUint8List();
    return base64Encode(bytes);
  }

  Future<AppUser?> getUserById(String uid) async {
    if (uid.isEmpty) {
      print('getUserById called with empty uid');
      return null;
    }

    if (_userCache.containsKey(uid)) {
      return _userCache[uid];
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final user = AppUser.fromMap(doc.data()!);
        _userCache[uid] = user;
        return user;
      }
    } catch (e) {
      print('Error fetching user by ID: $e');
    }

    return null;
  }


}
