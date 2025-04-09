import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/search_controller.dart';
import 'package:twitter_task/models/search_model.dart';
import 'package:twitter_task/widgets/appbar_sugesstionpage.dart';

class SuggestionPage extends StatelessWidget {
  const SuggestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(SearchScreenController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.fetchRecentSearches();
    });

    return Scaffold(
      backgroundColor: Color(0xffE7ECF0),
      appBar: AppbarSugesstionPage(),
      body: Obx(() {
        final recentSearches = searchController.recentSearches;

        return ListView(
          // padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffCED5DC),
                    width: 0.35,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent searches',
                      style: TextStyle(
                        fontSize: 19,
                        color: Color(0xff687684),
                        fontFamily: 'Helveticaneue100',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    IconButton(
                      onPressed: searchController.clearSearchHistory,
                      icon: Image.asset(
                        'assets/images/clearsearch.png',
                        width: 19,
                        height: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffCED5DC),
                    width: 0.33,
                  ),
                ),
              ),
              child: Container(
                color: Colors.white,
                height: 125,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestedUsers.length,
                  itemBuilder: (context, index) {
                    final user = suggestedUsers[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 20 : 0,
                        right: index == suggestedUsers.length - 1 ? 20 : 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(user.imagePath),
                          ),
                          const SizedBox(height: 9),
                          SizedBox(
                            width: 82,
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Helveticaneue100',
                                color: Colors.black,
                                letterSpacing: -0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 82,
                            child: Text(
                              user.username,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Helveticaneue100',
                                color: Color(0XFF687684),
                                letterSpacing: -0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            if (recentSearches.isNotEmpty) ...[
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffCED5DC),
                      width: 0.35,
                    ),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    final keyword = recentSearches[index];
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.only(left: 20, right: 30),
                      title: Text(
                        keyword,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Helveticaneue100',
                          color: Color(0xff1D1D1F),
                          letterSpacing: -0.2,
                        ),
                      ),
                      trailing: Image.asset(
                        'assets/images/suggestion_history.png',
                        width: 11,
                        height: 11,
                      ),
                      onTap: () => searchController.selectHistory(keyword),
                    );
                  },
                ),
              ),
            ],

          ],
        );
      }),
    );
  }
}
