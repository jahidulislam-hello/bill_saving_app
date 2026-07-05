
import 'package:vyzi/core/services/auth_service.dart';
import 'package:vyzi/features/auth/screen/forgot_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final AuthService _auth = AuthService();
  var isLoading = false.obs;

  Future<void> forgetPass() async {
    final email = emailController.text.trim();
    
    if (email.isEmpty) {
      Get.snackbar('Errore', 'Inserisci un\'email valida');
      return;
    }

    isLoading.value = true;
    try {
      await _auth.forgotPassword(email: email);
      Get.to(() => ForgotPasswordOtpScreen(), 
        arguments: {'email': email}
      );
      Get.snackbar('Successo', 'OTP inviato alla tua email');
    } catch (e) {
      Get.snackbar('Errore', 'Impossibile inviare OTP');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
