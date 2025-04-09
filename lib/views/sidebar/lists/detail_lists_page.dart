import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/views/sidebar/lists/edit_list_page.dart';

class DetailListPage extends StatelessWidget {
  final Map<String, dynamic> listData = Get.arguments;

  DetailListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = listData['name'] ?? '';
    final description = listData['description'] ?? '';
    final createdByName = listData['createdByName'] ?? 'Pengguna';
    final createdByUsername = listData['createdByUsername'] ?? 'Pengguna';
    final image = listData['image'];
    final imageBytes = _decodeBase64Image(image);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                child:
                    imageBytes != null
                        ? Image.memory(imageBytes, fit: BoxFit.cover)
                        : Image.asset(
                          'assets/images/default_banner.png',
                          fit: BoxFit.cover,
                        ),
              ),

              Positioned(
                top: 40,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    'assets/images/detail_list_back.png',
                    width: 38,
                    height: 38,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 70,
                child: Image.asset(
                  'assets/images/detail_list_share.png',
                  width: 38,
                  height: 38,
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: Image.asset(
                  'assets/images/detail_list_menu.png',
                  width: 38,
                  height: 38,
                ),
              ),
            ],
          ),

          // Konten
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Helveticaneue900',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        createdByName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '@$createdByUsername',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => EditListPage(listId: listData['id']));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff4C9EEB),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Edit List",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Helveticaneue',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 150),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Waiting for Posts",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Helveticaneue900',
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Posts from people on this List can be viewed here.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff687684),
                            fontWeight: FontWeight.w500,
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Uint8List? _decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }
}
