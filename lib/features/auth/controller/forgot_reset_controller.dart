import 'package:vyzi/core/services/auth_service.dart';
import 'package:vyzi/features/auth/password_succesfull.dart';
import 'package:vyzi/features/auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthService _auth = AuthService();

  var ispasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;

  var email = ''.obs;
  var code = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      email.value = args['email'] ?? '';
      code.value = args['code'] ?? '';
    }
  }

  void toggleNewPasswordVisibility() {
    ispasswordHidden.value = !ispasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> resetPassword() async {
    final newPassword = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('auth.validation.error'.tr, 'auth.reset_password.empty_error'.tr);
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar('auth.validation.error'.tr, 'auth.reset_password.min_length_error'.tr);
      return;
    }

    if (!RegExp(r'[a-z]').hasMatch(newPassword)) {
      Get.snackbar('auth.validation.error'.tr, 'auth.reset_password.lowercase_error'.tr);
      return;
    }

    if (!RegExp(r'[A-Z]').hasMatch(newPassword)) {
      Get.snackbar('auth.validation.error'.tr, 'auth.reset_password.uppercase_error'.tr);
      return;
    }

    if (!RegExp(r'\d').hasMatch(newPassword)) {
      Get.snackbar('auth.validation.error'.tr, 'auth.reset_password.number_error'.tr);
      return;
    }

    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"|,.<>/?\\]').hasMatch(newPassword)) {
      Get.snackbar('auth.validation.error'.tr, 'auth.reset_password.special_char_error'.tr);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('auth.validation.error'.tr, 'auth.reset_password.mismatch'.tr);
      return;
    }

    isLoading.value = true;
    try {
      await _auth.resetPassword(
        email: email.value,
        code: code.value,
        newPassword: newPassword,
      );
      Get.offAll(() => PasswordUpdateSuccessScreen());
      Get.snackbar('auth.validation.success'.tr, 'auth.reset_password.success_message'.tr);
    } catch (e) {
      Get.snackbar('auth.validation.error'.tr, 'auth.reset_password.failed_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
