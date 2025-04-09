import 'package:get/get.dart';

class MailController extends GetxController {
  final receiveMessages = false.obs;
  final qualityFilter = false.obs;
  final readReceipts = false.obs;

  void setReceiveMessages(bool value) {
    receiveMessages.value = value;
  }

  void setQualityFilter(bool value) {
    qualityFilter.value = value;
  }

  void setReadReceipts(bool value) {
    readReceipts.value = value;
  }
}
