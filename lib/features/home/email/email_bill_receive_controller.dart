import 'dart:async';
import 'package:vyzi/core/navbar/navbar_screen.dart';
import 'package:vyzi/features/request/request_screen.dart';
import 'package:get/get.dart';

class EmailBillReceivedController extends GetxController {
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
    Get.to(() => const RequestScreen());
  }

  void backToHome() {
    Get.offAll(() =>  CustomBottomNavBar());
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
