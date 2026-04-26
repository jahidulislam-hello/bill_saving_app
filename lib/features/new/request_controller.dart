import 'package:get/get.dart';

class RequestController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void uploadBill() {
    // Navigate or trigger upload
    Get.toNamed('/upload-bill');
  }
}