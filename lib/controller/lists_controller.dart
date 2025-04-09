import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListsController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final isPrivate = false.obs;
  final imageBase64 = ''.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var memberOfLists = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMemberOfLists();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      imageBase64.value = base64Encode(bytes);
    }
  }

  Future<void> createList() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final image = imageBase64.value;
    final user = _auth.currentUser;

    if (name.isEmpty || user == null) return;

    final displayName = user.displayName ?? 'Guest';
    final username = user.displayName?.toLowerCase().replaceAll(' ', '') ?? 'guest';

    try {
      final docRef = await _firestore.collection('lists').add({
        'name': name,
        'description': description.isNotEmpty ? description : null,
        'image': image,
        'private': isPrivate.value,
        'createdBy': user.uid,
        'createdByName': displayName,
        'createdByUsername': username,
        'members': [user.uid],
        'timestamp': FieldValue.serverTimestamp(),
      });

      await docRef.update({'listId': docRef.id});
      await fetchMemberOfLists();

      nameController.clear();
      descriptionController.clear();
      imageBase64.value = '';

      Get.back(); 
    } catch (e) {
      Get.snackbar('Error', 'Failed to create list: $e');
    }
  }


  Future<void> fetchMemberOfLists() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await _firestore
          .collection('lists')
          .where('members', arrayContains: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      memberOfLists.value = snapshot.docs.map((doc) {
        return doc.data()..['id'] = doc.id;
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch lists: $e');
    }
  }

Future<void> loadListData(String listId) async {
  isLoading.value = true;
  try {
    DocumentSnapshot doc = await _firestore.collection('lists').doc(listId).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      nameController.text = data['name'] ?? '';
      descriptionController.text = data['description'] ?? '';
      isPrivate.value = data['private'] ?? false;
      imageBase64.value = data['image'] ?? '';
    }
  } catch (e) {
    print("Error loading list data: $e");
  } finally {
    isLoading.value = false;
  }
}

Future<void> updateList(String listId) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  await _firestore.collection('lists').doc(listId).update({
    'name': nameController.text,
    'description': descriptionController.text,
    'image': imageBase64.value,
    'isPrivate': isPrivate.value,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  await fetchMemberOfLists();
  Get.back(); 
}

Future<void> deleteList(String listId) async {
  try {
    print("Deleting list...");
    await FirebaseFirestore.instance.collection('lists').doc(listId).delete();
    print("List $listId deleted successfully");

    await fetchMemberOfLists();
    Get.back(); 
  } catch (e) {
    print("Error deleting list: $e");
  }
}

void resetFields() {
  nameController.clear();
  descriptionController.clear();
  imageBase64.value = '';
  isPrivate.value = false;
}



}
