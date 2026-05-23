import 'package:vyzi/features/home/email/email_bill_receive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EmailBillController extends GetxController {
  var email = "bills@utility-analyzer.com".obs;

  /// Copy Email
  void copyEmail() {
    Clipboard.setData(ClipboardData(text: email.value));
    Get.snackbar(
      "Copied",
      "Email copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
    );
  }

  /// Button Action
  void onEmailSent() {
    Get.to(() => EmailBillReceivedScreen());
  }
}
