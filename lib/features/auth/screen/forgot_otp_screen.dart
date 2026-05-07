
import 'package:billo/core/utils/app_colors.dart';
import 'package:billo/core/widgets/primary_button.dart';
import 'package:billo/features/auth/controller/forgot_otp_controller.dart';
import 'package:billo/features/auth/screen/forgot_reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/appbar/custom_appbar.dart';




class ForgotPasswordOtpScreen extends StatelessWidget {
  final ForgotPasswordOtpController controller = Get.put(ForgotPasswordOtpController());

  ForgotPasswordOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Verify OTP',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),


              /// OTP Input Boxes
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Obx(() {
                      final isFilled = controller.otpDigits[index].isNotEmpty;

                      return Container(
                        width: 44,
                        height: 57,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isFilled
                                ? const Color(0xFF00D65C)
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: TextField(
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white70),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              controller.updateDigit(index, val);
                              if (val.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              } else if (index == 5) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),
                        ),
                      );
                    });
                  }),
                ),
              ),

              const SizedBox(height: 24),

              /// Resend Section (Right aligned now)
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() {
                  if (controller.secondsRemaining.value == 0) {
                    return GestureDetector(
                      onTap: controller.resendCode,
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary50,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  } else {
                    final seconds = controller.secondsRemaining.value;
                    final timerText =
                        "00:${seconds.toString().padLeft(2, '0')}";
                    return RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14),
                        children: [
                          const TextSpan(
                            text: 'Resend OTP ',
                            style: TextStyle(
                              color: AppColors.primary50,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: timerText,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
              ),

              const SizedBox(height: 32),

              /// Verify Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  title: "Verify OTP",
                  onPress: () {
                    Get.to(()=> ResetPasswordScreen());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}