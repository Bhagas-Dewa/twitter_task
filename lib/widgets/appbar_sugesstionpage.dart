import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/search_controller.dart';
import 'package:twitter_task/views/search/search_page.dart';
import 'package:twitter_task/views/search/searchresult_page.dart';

class AppbarSugesstionPage extends StatelessWidget implements PreferredSizeWidget {
  AppbarSugesstionPage({super.key});

  final TextEditingController _searchTextController = TextEditingController();
  final searchController = Get.put(SearchScreenController());


  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 16),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7ECF0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Image.asset(
                          'assets/images/appbarsearch_search.png', 
                          height: 13,
                        ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          controller: _searchTextController, 
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              searchController.searchTweets(value); 
                              searchController.saveSearchQuery(value);
                              Get.to(() => SearchResultPage(searchQuery: value));
                              _searchTextController.clear();

                            }
                          },
                          decoration: const InputDecoration(
                            hintText: "Search Twitter",
                            hintStyle: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Helveticaneue100',
                              fontWeight: FontWeight.w300,
                              letterSpacing: -0.4,
                              color: Color(0xff687684),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            isDense: true,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                   searchController.showSuggestions.value = false;
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xff4C9EEB),
                    fontSize: 17,
                    fontFamily: 'Helveticaneue100',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
