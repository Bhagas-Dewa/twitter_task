import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/search_controller.dart';
import 'package:twitter_task/widgets/tweet_item.dart';
import 'package:twitter_task/models/tweet_model.dart';

class SearchResultPage extends StatelessWidget {
  final String searchQuery;

   const SearchResultPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchScreenController controller = Get.put(SearchScreenController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Results for \"$searchQuery\""),
      ),
      body: FutureBuilder<List<Tweet>>(
        future: controller.searchTweets(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tweets found"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return TweetItem(tweet: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
