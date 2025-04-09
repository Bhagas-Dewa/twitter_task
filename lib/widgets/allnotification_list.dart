import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/controller/notification_controller.dart';
import 'package:twitter_task/models/notification_model.dart';

class NotificationList extends StatelessWidget {
  final NotificationController controller = Get.find<NotificationController>();

  NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.notifications.isEmpty) {
        return const Center(
          child: Text('No notifications'),
        );
      }

      return ListView.separated(
        itemCount: controller.notifications.length,
        separatorBuilder: (context, index) => const Divider(
          thickness: 0.33,
          color: Color(0xffCED5DC),
        ),
        itemBuilder: (context, index) {
          return NotificationItem(
            notification: controller.notifications[index],
          );
        },
      );
    });
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 20, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Image.asset(
                notification.starImage,
                width: 24,
                height: 24,
              ),
              Container(
                width: 2,
                height: 25,
                color: Colors.transparent,
              ),
            ],
          ),

          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    notification.profileImage,
                    width: 37,
                    height: 37,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 8),

                // Content Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          color: Color(0xFF687684), 
                          fontSize: 16,
                          fontFamily: 'Helveticaneue',
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          const TextSpan(text: 'In case you missed '),
                          TextSpan(
                            text: notification.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Helveticaneue100',
                              color: Colors.black,
                            ),
                          ),
                          const TextSpan(text: '\'s Tweet'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Tweet Content
                    Text(
                      notification.content,
                      style: const TextStyle(
                        color: Color(0xFF687684),
                        fontSize: 16,
                        fontFamily: 'Helveticaneue',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                    ),

                    // Link
                    if (notification.link != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        notification.link!,
                        style: const TextStyle(
                          color: Color(0xFF687684),
                          fontSize: 16,
                          fontFamily: 'Helveticaneue',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    // Hashtag
                    if (notification.username == 'UX Upper') ...[
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 4,
                        children: [
                          Text(
                            '#ux #uxdesign #uxresearch #userresearch #research #productdesign '
                            '#webdesign #userexperience #startup #digital #design #diseño '
                            '#psychology #servicedesign #conversion',
                            style: const TextStyle(
                              color: Color(0xFF687684),
                              fontSize: 16,
                              fontFamily: 'Helveticaneue',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

              ],
            ),
          ),
          Image.asset('assets/images/tweet_downarrow.png', height: 8, width: 10),
        ],
      ),
    );
  }
}
