import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/lists_controller.dart';
import 'package:twitter_task/views/sidebar/lists/create_list_page.dart';
import 'package:twitter_task/widgets/bottom_navbar.dart';
import 'package:twitter_task/widgets/lists_member.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ListsController controller = Get.put(ListsController());

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    controller.resetFields();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      // statusBarIconBrightness: Brightness.dark,
    ), 
      child: Scaffold(
        backgroundColor: Color(0xffE7ECF0),
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: kToolbarHeight,
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xff4C9EEB)),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Lists',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'Helveticaneue900',
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xff4C9EEB),
                unselectedLabelColor: Color(0xff687684),
                indicatorColor: const Color(0xff4C9EEB),
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Helveticaneue100',
                  fontSize: 16,
                  letterSpacing: -0.3,
                ),
                tabs: const [
                  Tab(text: "Subscribed to"),
                  Tab(text: "Member of"),
                ],
              ),
            ),
          ],
        ),
      ),

        body: TabBarView(
          controller: _tabController,
          children: [
            _buildEmptyState(),
            MemberOfListView(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.resetFields();
             Get.to(() => CreateListPage());
          },
          backgroundColor: Color(0xff4C9EEB),
          shape: CircleBorder(),
          elevation: 2,
          child: Image.asset(
            'assets/images/fab_list.png', 
            height: 22,
            width: 22,
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You haven’t created or subscribed to any Lists",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Helveticaneue900',
                fontWeight: FontWeight.w900,
                letterSpacing: -0.15,
              ),
            ), SizedBox(height: 14),
            Text(
              "When you do, they’ll show up here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff687684),
                fontFamily: 'Helveticaneue',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print("Button create list diklik");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff4C9EEB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Create a List",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
