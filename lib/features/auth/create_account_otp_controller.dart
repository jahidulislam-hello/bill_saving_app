import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vyzi/core/services/storage_service.dart';
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
      Get.snackbar('auth.validation.error'.tr, 'auth.otp.error_incomplete'.tr);
      return;
    }

    final auth = Get.put(AuthController());
    try {
      final res = await auth.verifyOtp(email: email.value, code: code, type: 'email_verification');

      // Persist tokens from the OTP verify response if present
      final data = res['data'] as Map<String, dynamic>?;
      if (data != null) {
        final storage = Get.find<StorageService>();
        final accessToken = data['accessToken'] as String?;
        final refreshToken = data['refreshToken'] as String?;
        final user = data['user'] as Map<String, dynamic>?;
        if (accessToken != null) await storage.setString(StorageKeys.authToken, accessToken);
        if (refreshToken != null) await storage.setString(StorageKeys.refreshToken, refreshToken);
        if (user != null) {
          if (user['id'] != null) await storage.setString(StorageKeys.userId, user['id'].toString());
          if (user['email'] != null) await storage.setString(StorageKeys.userEmail, user['email'].toString());
          if (user['firstName'] != null) await storage.setString(StorageKeys.userName, user['firstName'].toString());
        }
        await storage.setBool(StorageKeys.isLoggedIn, true);
      }

      Get.snackbar('auth.validation.success'.tr, 'auth.otp.verified_success'.tr);
      Get.offAllNamed('/navbarScreen');
    } catch (e) {
      Get.snackbar('auth.validation.error'.tr, auth.error.value.isNotEmpty ? auth.error.value : 'auth.otp.verification_failed'.tr);
    }
  }

  /// ✔ Resend OTP logic
  void resendCode() {
    /// Clear previous OTP digits
    otpDigits.value = List<String>.filled(6, '');

    /// Restart timer
    startTimer();

    // TODO: optional API call to resend OTP
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
