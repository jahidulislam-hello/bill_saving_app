
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/widgets/custom_text_filled.dart';
import 'package:vyzi/core/widgets/primary_button.dart';
import 'package:vyzi/features/auth/controller/forgot_reset_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/appbar/custom_appbar.dart';




class ResetPasswordScreen extends StatelessWidget {
   ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'auth.reset_password.title'.tr,
      ),
      body: SafeArea(
        top: false,
        child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.04),


            // ── Password ───────────────────────
            _labeledField(
              label: 'auth.reset_password.password_label'.tr,
              child: CustomTextField(
                controller: controller.passwordController,
                isPassword: true,
                hintText: '••••••••••',
                validator: (v) =>
                v == null || v.length < 6 ? 'auth.reset_password.password_error'.tr : null,
              ),
            ),

            SizedBox(height: 12.h),

            // ── Confirm Password ───────────────
            _labeledField(
              label: 'auth.reset_password.confirm_label'.tr,
              child: CustomTextField(
                controller: controller.confirmPasswordController,
                isPassword: true,
                hintText: '••••••••••',
                validator: (v) => v != controller.passwordController.text
                    ? 'auth.reset_password.mismatch'.tr
                    : null,
              ),
            ),


            // const Spacer(),
            const SizedBox(height: 32),


            SizedBox(
              width: double.infinity,
              child: Obx(() => PrimaryButton(
                title: controller.isLoading.value ? 'common.loading'.tr : 'auth.reset_password.button'.tr,
                onPress: controller.isLoading.value
                    ? () {}
                    : () {
                        controller.resetPassword();
                      },
              )),
            ),

            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
      ),
      ),
    );
  }

  Widget _labeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }
}
