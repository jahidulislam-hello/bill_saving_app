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
      Get.snackbar('Errore', 'Inserisci le password');
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar('Errore', 'La password deve essere almeno 6 caratteri');
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Errore', 'Le password non corrispondono');
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
      Get.snackbar('Successo', 'Password reimpostata');
    } catch (e) {
      Get.snackbar('Errore', 'Impossibile reimpostare la password');
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
