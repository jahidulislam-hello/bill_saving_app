import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/widgets/primary_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vyzi/features/auth/create_account_otp_controller.dart';
import 'package:vyzi/routes/app_routes.dart';

import '../../../../../core/appbar/custom_appbar.dart';

class CreateAccountOtpScreen extends StatelessWidget {
  final CreateAccountOtpController controller = Get.put(
    CreateAccountOtpController(),
  );

  CreateAccountOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'auth.otp.title'.tr, showBackButton: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              /// OTP Input Boxes
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Obx(() {
                        final isFilled = controller.otpDigits[index].isNotEmpty;

                        return Container(
                          width: 40,
                          height: 52,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isFilled
                                  ? AppColors.primaryColor
                                  : AppColors.divider,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: TextField(
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
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
              ),

              const SizedBox(height: 24),

              /// Resend Section (Right aligned now)
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() {
                  if (controller.secondsRemaining.value == 0) {
                    return GestureDetector(
                      onTap: controller.resendCode,
                      child: Text(
                        'auth.otp.resend'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  } else {
                    final seconds = controller.secondsRemaining.value;
                    final timerText =
                        "00:${seconds.toString().padLeft(2, '0')}";
                    return RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                        ),
                        children: [
                          TextSpan(
                            text: '${'auth.otp.resend'.tr} ',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: timerText,
                            style: const TextStyle(
                              color: AppColors.red100,
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
                  title: 'auth.otp.button'.tr,
                  onPress: () {
                    if (controller.isOtpComplete()) {
                      controller.verifyAndProceed();
                    } else {
                      Get.snackbar(
                        'auth.validation.error'.tr,
                        'auth.otp.error_incomplete'.tr,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
