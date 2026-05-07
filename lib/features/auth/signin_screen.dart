import 'package:billo/core/utils/app_colors.dart';
import 'package:billo/core/widgets/custom_text_filled.dart';

import 'package:billo/core/widgets/primary_button.dart';
import 'package:billo/core/widgets/social_button.dart';
import 'package:billo/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _agreeToTerms = false;

  @override
  void dispose() {

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),

                // ── Title ──────────────────────────
                Text(
                  'Accedi al tuo account',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontFamily: 'Open Sans',
                  ),
                ),

                SizedBox(height: 20.h),


                // ── Email ──────────────────────────
                _labeledField(
                  label: 'Indirizzo Email *',
                  child: CustomTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'you@example.com',
                    validator: (v) =>
                    v == null || !v.contains('@') ? 'Enter valid email' : null,
                  ),
                ),



                // ── Password ───────────────────────
                _labeledField(
                  label: 'Password *',
                  child: CustomTextField(
                    controller: _passwordController,
                    isPassword: true,
                    hintText: '••••••••••',
                    validator: (v) =>
                    v == null || v.length < 6 ? 'Min 6 characters' : null,
                  ),
                ),

                SizedBox(height: 12.h),


                // ── Terms Checkbox ─────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 10.w),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                            fontFamily: 'Open Sans',
                          ),
                          children: [
                            const TextSpan(text: 'Hai dimenticato la password?    '),
                            TextSpan(
                              text: 'Reimposta ora',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offNamed(AppRoutes.forgotPasswordScreen);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ── Register Button ────────────────
                PrimaryButton(

                  title: 'Accedi',
                  onPress: () {
                      Get.offNamed(AppRoutes.navbarScreen);
                  },
                ),

                SizedBox(height: 20.h),

                // ── Divider ────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFEEEEEE))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        'Oppure accedi con',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          fontFamily: 'Open Sans',
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFEEEEEE))),
                  ],
                ),

                SizedBox(height: 16.h),

                // ── Facebook ───────────────────────
                SocialButton(
                  label: 'Accedi con Facebook',
                  logo: _facebookLogo(),
                  onPress: () {},
                ),

                SizedBox(height: 10.h),

                // ── Apple ──────────────────────────
                SocialButton(
                  label: 'Accedi con Apple',
                  logo: _appleLogo(),
                  onPress: () {},
                ),

                SizedBox(height: 10.h),

                // ── Google ─────────────────────────
                SocialButton(
                  label: 'Accedi con Google',
                  logo: _googleLogo(),
                  onPress: () {},
                ),

                SizedBox(height: 20.h),

                // ── Create Account Link ─────────────────────
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                        fontFamily: 'Open Sans',
                      ),
                      children: [
                        const TextSpan(text: 'Non hai un account?'),
                        TextSpan(
                          text: 'Registrati ora',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offNamed(AppRoutes.signUpScreen);
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Custom AppBar ──────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(56.h),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new,
                    size: 20.sp, color: AppColors.textPrimary),
                onPressed: () => Navigator.maybePop(context),
              ),
              IconButton(
                icon: Icon(Icons.close,
                    size: 22.sp, color: AppColors.textPrimary),
                onPressed: () => Navigator.maybePop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Labeled field wrapper ──────────────────
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

  // ── Brand Logos ────────────────────────────
  Widget _facebookLogo() {
    return Image.asset(
      'assets/icons/facebook.png',
      width: 24.w,
      height: 24.h,
    );
  }

  Widget _appleLogo() {
    return Image.asset(
      'assets/icons/apple.png',
      width: 24.w,
      height: 24.h,
    );
  }

  Widget _googleLogo() {
    return Image.asset(
      'assets/icons/gogle.png',
      width: 24.w,
      height: 24.h,
    );
  }
}
