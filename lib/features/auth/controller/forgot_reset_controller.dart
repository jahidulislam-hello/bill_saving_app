
import 'package:vyzi/features/auth/password_succesfull.dart';
import 'package:vyzi/features/auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var ispasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  /// 🔐 sessionId passed from OTP verification screen
  var sessionId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get sessionId passed via Get.toNamed() or Get.arguments
    sessionId.value = Get.arguments ?? '';
    print("✅ Session ID received: ${sessionId.value}");
  }

  void toggleNewPasswordVisibility() {
    ispasswordHidden.value = !ispasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void resetPassword() {

    Get.offAll(()=>PasswordUpdateSuccessScreen());

  }



  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
