import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vyzi/features/auth/controller/auth_controller.dart';

class CreateAccountOtpController extends GetxController {
  var otpDigits = List<String>.filled(6, '').obs;
  var secondsRemaining = 30.obs;
  final otpController = TextEditingController();
  var sessionId = ''.obs;
  Timer? _timer;

  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();

    // Read passed arguments (email, type) if provided
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['email'] != null) email.value = args['email'].toString();
    }
  }

  /// ✔ Update a single OTP digit
  void updateDigit(int index, String value) {
    otpDigits[index] = value;
  }

  /// ✔ Check if all OTP boxes are filled
  bool isOtpComplete() {
    return otpDigits.every((digit) => digit.isNotEmpty);
  }

  /// Verify OTP for account creation
  Future<void> verifyAndProceed() async {
    final code = otpDigits.join();
    if (code.length < 6) {
      Get.snackbar('Errore', 'Inserisci il codice OTP completo');
      return;
    }

    final auth = Get.put(AuthController());
    try {
      await auth.verifyOtp(email: email.value, code: code, type: 'email_verification');
      Get.snackbar('Successo', 'OTP verificato');
      Get.offAllNamed('/navbarScreen');
    } catch (e) {
      Get.snackbar('Errore', auth.error.value.isNotEmpty ? auth.error.value : 'Verifica OTP fallita');
    }
  }

  /// ✔ Resend OTP logic
  void resendCode() {
    /// Clear previous OTP digits
    otpDigits.value = List<String>.filled(6, '');

    /// Restart timer
    startTimer();

    // TODO: optional API call to resend OTP
    Get.snackbar("OTP Sent", "A new OTP has been sent to your email.");
  }

  /// Start countdown timer for OTP resend
  void startTimer() {
    secondsRemaining.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
