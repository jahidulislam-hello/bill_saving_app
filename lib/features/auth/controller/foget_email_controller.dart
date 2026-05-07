
import 'package:billo/features/auth/screen/forgot_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();


  Future<void> forgetPass() async {
    Get.to (()=> ForgotPasswordOtpScreen());

  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

}