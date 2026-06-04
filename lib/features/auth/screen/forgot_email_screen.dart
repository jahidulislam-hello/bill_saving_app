
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/widgets/custom_text_filled.dart';
import 'package:vyzi/core/widgets/primary_button.dart';
import 'package:vyzi/features/auth/controller/foget_email_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../../../../core/appbar/custom_appbar.dart';



class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  ForgotPasswordScreen({super.key});
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Password Dimenticata',
        showBackButton: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // ── Email ──────────────────────────
                _labeledField(
                  label: 'Indirizzo Email *',
                  child: CustomTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'you@example.com',
                    validator: (v) =>
                    v == null || !v.contains('@') ? 'Inserisci un\'email valida' : null,
                  ),
                ),


                const SizedBox(height: 24),

                /// Button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    title: "Ottieni OTP",
                    onPress: controller.forgetPass,

                  ),
                ),
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
