import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_task/controller/lists_controller.dart';
import 'package:twitter_task/widgets/toggle_switch.dart';

class CreateListPage extends StatelessWidget {
  CreateListPage({super.key});
  final ListsController controller = Get.put(ListsController());

  @override
  Widget build(BuildContext context) {
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
                'Create List',
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() {
                  return CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0XFFE7ECF0),
                    backgroundImage: controller.imageBase64.value.isNotEmpty
                        ? MemoryImage(base64Decode(controller.imageBase64.value))
                        : const AssetImage('assets/images/bottomicon_camera.png') as ImageProvider,
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.nameController,
                cursorColor: Color(0xff4C9EEB),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Helveticaneue',
                    fontWeight: FontWeight.w700,
                    color: Color(0xff687684),
                  ),
                  hintText: 'Enter list name',
                  hintStyle: TextStyle(
                    fontSize: 17,
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
                cursorColor: Color(0xff4C9EEB),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descriptions',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Helveticaneue',
                    fontWeight: FontWeight.w700,
                    color: Color(0xff687684),
                  ),
                  hintText: 'Enter descriptions',
                  hintStyle: TextStyle(
                    fontSize: 17,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Private',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Helveticaneue',
                          fontWeight: FontWeight.w800,
                          color: Color(0xff687684),
                        ),
                      ),
                      Text('If you make Lists Private, only you can see it.',
                        style: 
                          TextStyle(
                            fontSize: 15,
                            fontFamily: 'Helveticaneue',
                            fontWeight: FontWeight.w500,
                            color: Color(0xff687684),
                            letterSpacing: -0.15,
                          ),
                        ),
                    ],
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
              
              SizedBox(height: 300),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: controller.createList,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4C9EEB),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Helveticaneue',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
