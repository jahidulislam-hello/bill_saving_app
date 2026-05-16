
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_images.dart';
import 'package:vyzi/core/widgets/custom_text_filled.dart';
import 'package:vyzi/core/widgets/primary_button.dart';
import 'package:vyzi/features/auth/controller/forgot_reset_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/appbar/custom_appbar.dart';




class ResetPasswordScreen extends StatelessWidget {
   ResetPasswordScreen({super.key});


  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Reimposta Password",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.04),


            // ── Password ───────────────────────
            _labeledField(
              label: 'Password *',
              child: CustomTextField(
                controller: _passwordController,
                isPassword: true,
                hintText: '••••••••••',
                validator: (v) =>
                v == null || v.length < 6 ? 'Minimo 6 caratteri' : null,
              ),
            ),

            SizedBox(height: 12.h),

            // ── Confirm Password ───────────────
            _labeledField(
              label: 'Conferma Password *',
              child: CustomTextField(
                controller: _confirmPasswordController,
                isPassword: true,
                hintText: '••••••••••',
                validator: (v) => v != _passwordController.text
                    ? 'Le password non corrispondono'
                    : null,
              ),
            ),


            // const Spacer(),
            const SizedBox(height: 32),


            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                title: "Reimposta Password",
                onPress: () {
                  controller.resetPassword(); // ✅ logic here
                },
              ),
            ),

            SizedBox(height: size.height * 0.03),
          ],
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
            fontFamily: 'Open Sans',
          ),
        ),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }
}