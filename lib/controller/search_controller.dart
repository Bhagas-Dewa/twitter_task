import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/models/tweet_model.dart';
import 'package:twitter_task/views/search/searchresult_page.dart';

class SearchScreenController extends GetxController {
  final RxBool showSuggestions = false.obs;
  final TextEditingController textController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  var searchResults = <Tweet>[].obs;
  var isSearching = false.obs;
  var recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecentSearches();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void toggleSuggestions(bool value) {
    showSuggestions.value = value;
  }

  Future<List<Tweet>> searchTweets(String query) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tweets')
          .orderBy('timestamp', descending: true)
          .get();

      final filtered = snapshot.docs
          .map((doc) => Tweet.fromFirestore(doc))
          .where((tweet) => tweet.content.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return filtered;
    } catch (e) {
      print("Error saat mencari tweet: $e");
      return [];
    }
  }

  // Future<List<Tweet>> searchTweets(String query) async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('tweets')
  //         .orderBy('content')
  //         .where('content', isGreaterThanOrEqualTo: query)
  //         .where('content', isLessThanOrEqualTo: '$query\uf8ff')
  //         .get();

  //     return snapshot.docs.map((doc) => Tweet.fromFirestore(doc)).toList();
  //   } catch (e) {
  //     print("Error saat mencari tweet: $e");
  //     return [];
  //   }
  // }

  Future<void> saveSearchQuery(String query) async {
    if (userId == null || query.trim().isEmpty) return;

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await FirebaseFirestore.instance.collection('search_history').add({
      'query': query,
      'timestamp': timestamp,
      'userId': userId,
    });

    await fetchRecentSearches();
  }

  Future<void> fetchRecentSearches() async {
    if (userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('search_history')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

          print("Total recent search ditemukan: ${snapshot.docs.length}");

      final allSearches = snapshot.docs.map((doc) => doc['query'].toString()).toList();
      recentSearches.value = allSearches.toSet().toList(); // remove duplicates
    } catch (e) {
      print("Gagal mengambil recent search: $e");
    }
  }

  Future<void> clearSearchHistory() async {
    if (userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('search_history')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      recentSearches.clear();
    } catch (e) {
      print("Gagal menghapus search history: $e");
    }
  }

  void selectHistory(String keyword) {
    textController.text = keyword;
    showSuggestions.value = false;

    // pencarian otomatis setelah memilih
    isSearching.value = true;
    searchTweets(keyword).then((results) {
      searchResults.value = results;
      Get.to(() => SearchResultPage(searchQuery: keyword)); 
      textController.clear();
    });
  }



}