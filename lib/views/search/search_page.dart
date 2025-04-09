import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/views/search/suggestion_page.dart';
import 'package:twitter_task/widgets/appbar_search.dart';
import 'package:twitter_task/widgets/bottom_navbar.dart';
import 'package:twitter_task/controller/search_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchScreenController controller = Get.put(SearchScreenController());

   @override
  Widget build(BuildContext context) {
    return Obx(() => controller.showSuggestions.value
      ? const SuggestionPage()
      : Scaffold(
          backgroundColor: const Color(0xffE7ECF0),
          appBar: AppBarSearch(controller: controller),
          body: Column(
            children: [
              _buildHeader(),
              _buildNoTrendsMessage(),
              const Divider(
                color: Color(0xffCED5DC),
                height: 0.33,
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(),
        ),
    );
  }


  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Trends for you',
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'Helveticaneue900',
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const Divider(
            color: Color(0xffCED5DC),
            height: 0.33,
          ),
        ],
      ),
    );
  }

  Widget _buildNoTrendsMessage() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'No new trends for you',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontFamily: 'Helveticaneue900',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'It seems like there\'s not a lot to show you right \n now, but you can see trends for other areas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff687684),
              fontFamily: 'Helveticaneue',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildChangeLocationButton(),
        ],
      ),
    );
  }

  Widget _buildChangeLocationButton() {
    return GestureDetector(
      onTap: () {
        print("Button Change Location diklik");
      },
      child: Container(
        height: 34,
        width: 136,
        decoration: BoxDecoration(
          color: const Color(0xff4C9EEB),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'Change location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Helvetica Neue',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
