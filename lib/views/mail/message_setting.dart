import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_task/widgets/appbar_messagesetting.dart';
import 'package:twitter_task/widgets/toggle_switch.dart';
import 'package:twitter_task/controller/mail_controller.dart'; 

class MessageSetting extends StatelessWidget {
  MessageSetting({super.key});

  final MailController mailController = Get.find<MailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE7ECF0),
      appBar: AppbarMessagesetting(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Privacy"),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Column(
                  children: [
                    _buildSettingOption(
                      title: "Receive message from anyone",
                      description:
                          "You will be able to receive Direct Message requests from anyone on Twitter, even if you don't follow them.",
                      toggleValue: mailController.receiveMessages,
                      onChanged: (value) {
                        mailController.receiveMessages.value = value;
                      },
                    ),
                    _buildSettingOption(
                      title: "Quality filter",
                      description:
                          "Filters lower-quality messages from your Direct Message requests.",
                      toggleValue: mailController.qualityFilter,
                      onChanged: (value) {
                        mailController.qualityFilter.value = value;
                      },
                    ),
                    _buildSettingOption(
                      title: "Show read receipts",
                      description:
                          "When someone sends you a message, people in the conversation will know when you've seen it. If you turn off this setting, you won't be able to see read receipts from others.",
                      toggleValue: mailController.readReceipts,
                      onChanged: (value) {
                        mailController.readReceipts.value = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffE7ECF0),
        boxShadow: [
          BoxShadow(
            color: Color(0xffCED5DC),
            offset: Offset(0, 0.33),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          color: Color(0xff687684),
          fontFamily: 'Helveticaneue100',
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    required String description,
    required RxBool toggleValue,
    required Function(bool) onChanged,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Helveticaneuel00',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  Obx(() => CustomToggleSwitch(
                        isOn: toggleValue.value,
                        onChanged: onChanged,
                      )),
                ],
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$description ",
                      style: const TextStyle(
                        color: Color(0xff687684),
                        fontSize: 14,
                        fontFamily: 'Helveticaneue',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextSpan(
                      text: "Learn more",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff4C9EEB),
                        fontFamily: 'Helveticaneue',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Color(0xffCED5DC),
          thickness: 0.35,
        ),
      ],
    );
  }
}
