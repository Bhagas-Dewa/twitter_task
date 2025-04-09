import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/lists_controller.dart';
import 'package:twitter_task/views/sidebar/lists/detail_lists_page.dart';

class MemberOfListView extends StatelessWidget {
  final ListsController controller = Get.find<ListsController>();

  MemberOfListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final lists = controller.memberOfLists;

      if (lists.isEmpty) {
        return Center(
          child: Text(
            "Anda belum menjadi anggota dari daftar mana pun.",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Helvetica Neue',
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      return Container(
        color: Color(0xffE7ECF0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: lists.length,
          itemBuilder: (context, index) {
            final list = lists[index];
            final name = list['name'] ?? 'Nama Tidak Diketahui';
            final createdByName = list['createdByName'] ?? 'Pembuat Tidak Diketahui';
            final description = list['description'] ?? '';
            final imageBytes = _decodeBase64Image(list['image']);

            return GestureDetector(
              onTap: () {
                Get.to(() => DetailListPage(), arguments: list);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xffCED5DC),
                        width: 0.33,  
                      ),
                    ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            createdByName,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Helveticaneue100',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              letterSpacing: -0.15,
                            ),
                          ), 
                          Text(
                            name,
                            style: TextStyle(
                              fontFamily: 'Helveticaneue100',
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              letterSpacing: -0.15,
                            ),
                          ),
                          if (description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                description,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Helveticaneue',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff687684),
                                ),
                              ),
                            ),
                          Text(
                            '3000 members   20 subscribers',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Helveticaneue',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff687684),
                                ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: imageBytes != null
                          ? Image.memory(
                              imageBytes,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/suggestion_pp1.png',
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
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
