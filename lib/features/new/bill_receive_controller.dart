import 'dart:async';
import 'package:get/get.dart';

class BillReceivedController extends GetxController {
  var progress = 45.obs;

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startFakeProgress();
  }

  void startFakeProgress() {
    timer = Timer.periodic(const Duration(seconds: 2), (t) {
      if (progress.value < 100) {
        progress.value += 5;
      } else {
        t.cancel();
      }
    });
  }

  void goToRequests() {
    Get.toNamed('/requests'); // adjust route
  }

  void backToHome() {
    Get.offAllNamed('/home'); // adjust route
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}