import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vyzi/core/services/auth_service.dart';

class ForgotPasswordOtpController extends GetxController {
  var otpDigits = List<String>.filled(6, '').obs;
  var secondsRemaining = 30.obs;
  final otpController = TextEditingController();
  var sessionId = ''.obs;
  Timer? _timer;
  var email = ''.obs;
  final AuthService _auth = AuthService();

  @override
  void onInit() {
    super.onInit();
    startTimer();
    
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

  /// Verify OTP and proceed to reset password
  Future<void> verifyAndProceed() async {
    final code = otpDigits.join();
    if (code.length < 6) {
      Get.snackbar('auth.validation.error'.tr, 'auth.otp.error_incomplete'.tr);
      return;
    }

    try {
      await _auth.verifyOtp(email: email.value, code: code, type: 'password_reset');
      Get.snackbar('auth.validation.success'.tr, 'auth.otp.verified_success'.tr);
      Get.toNamed('/resetPasswordScreen', arguments: {
        'email': email.value,
        'code': code,
      });
    } catch (e) {
      Get.snackbar('auth.validation.error'.tr, 'auth.otp.verification_failed'.tr);
    }
  }

  /// ✔ Resend OTP logic
  void resendCode() {
    /// Clear previous OTP digits
    otpDigits.value = List<String>.filled(6, '');

    /// Restart timer
    startTimer();

    Get.snackbar('auth.otp.resend_title'.tr, 'auth.otp.resend_message'.tr);
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
