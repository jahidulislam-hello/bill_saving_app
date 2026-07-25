import 'package:vyzi/core/navbar/navbar_screen.dart';
import 'package:vyzi/features/request/request_screen.dart';
import 'package:get/get.dart';

class EmailBillReceivedController extends GetxController {
  void goToRequests() {
    Get.to(() => const RequestScreen());
  }

  void backToHome() {
    Get.offAll(() => CustomBottomNavBar());
  }
}
