import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/lists_controller.dart';
import 'package:twitter_task/widgets/toggle_switch.dart';

class EditListPage extends StatelessWidget {
  final String listId;
  EditListPage({super.key, required this.listId});

  final ListsController controller = Get.find<ListsController>();
  bool _hasLoadedData = false;

  @override
  Widget build(BuildContext context) {
    if (!_hasLoadedData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadListData(listId);
      });
      _hasLoadedData = true;
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: -8,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 20, color: Color(0xff4C9EEB)),
                onPressed: () => Get.back(),
              ),
            ),
            Center(
              child: Text(
                'Edit List',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Helveticaneue100',
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: controller.pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0XFFE7ECF0),
                  backgroundImage: controller.imageBase64.value.isNotEmpty
                      ? MemoryImage(base64Decode(controller.imageBase64.value))
                      : const AssetImage('assets/images/bottomicon_camera.png') as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.nameController,
                cursorColor: const Color(0xff4C9EEB),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter list name',
                  labelStyle: TextStyle(
                    fontFamily: 'Helveticaneue',
                    fontWeight: FontWeight.w700,
                    color: Color(0xff687684),
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'Helveticaneue',
                    fontWeight: FontWeight.w800,
                    color: Color(0xff687684),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff687684), width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff4C9EEB), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.descriptionController,
                cursorColor: const Color(0xff4C9EEB),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descriptions',
                  hintText: 'Enter descriptions',
                  labelStyle: TextStyle(
                    fontFamily: 'Helveticaneue',
                    fontWeight: FontWeight.w700,
                    color: Color(0xff687684),
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'Helveticaneue',
                    fontWeight: FontWeight.w800,
                    color: Color(0xff687684),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff687684), width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff4C9EEB), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Private',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Helveticaneue',
                            fontWeight: FontWeight.w800,
                            color: Color(0xff687684),
                          ),
                        ),
                        Text(
                          'If you make Lists Private, only you can see it.',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Helveticaneue',
                            fontWeight: FontWeight.w500,
                            color: Color(0xff687684),
                            letterSpacing: -0.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Obx(() => CustomToggleSwitch(
                        isOn: controller.isPrivate.value,
                        onChanged: (val) {
                          controller.isPrivate.value = val;
                        },
                      )),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      print("Deleting list...");
                      await controller.deleteList(listId);
                      Get.back();
                    },
                    child: const Text(
                      'Delete List',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontFamily: 'Helveticaneue',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print("Saving list...");
                      await controller.updateList(listId);
                      Get.back(); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4C9EEB),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Helveticaneue',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
