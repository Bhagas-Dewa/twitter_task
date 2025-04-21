import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 
import 'package:twitter_task/controller/search_controller.dart'; 
import 'package:twitter_task/widgets/tweet_item.dart'; 
import 'package:twitter_task/models/tweet_model.dart'; 
 
class SearchResultPage extends StatelessWidget { 
  final String searchQuery; 
 
  const SearchResultPage({Key? key, required this.searchQuery}) 
    : super(key: key); 
 
  @override 
  Widget build(BuildContext context) { 
    final SearchScreenController controller = Get.put(SearchScreenController()); 
 
    return Scaffold( 
      backgroundColor: Colors.white, 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
            child: Row(
              children: [
                IconButton( 
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon( 
                    Icons.arrow_back_ios, 
                    color: Colors.black, 
                    size: 20, 
                  ), 
                  onPressed: () { 
                    Get.back(); 
                  }, 
                ),
                Expanded(
                  child: Container( 
                    height: 32, 
                    decoration: BoxDecoration( 
                      color: const Color(0xFFE7ECF0), 
                      borderRadius: BorderRadius.circular(20), 
                    ), 
                    padding: const EdgeInsets.symmetric(horizontal: 12), 
                    child: Row( 
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        Image.asset('assets/images/appbarsearch_search.png', height: 13), 
                        const SizedBox(width: 6), 
                        Text("Results for \"$searchQuery\"", 
                          style: const TextStyle( 
                            fontSize: 16, 
                            fontFamily: 'Helveticaneue100', 
                            fontWeight: FontWeight.w300, 
                            letterSpacing: -0.4, 
                            color: Color(0xff687684), 
                          ), 
                        ), 
                      ], 
                    ), 
                  ),
                ),
              ],
            ),
          ),
        ),
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