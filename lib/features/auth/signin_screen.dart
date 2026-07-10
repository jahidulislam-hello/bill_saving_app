import 'package:vyzi/core/appbar/custom_appbar.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/widgets/custom_text_filled.dart';
import 'package:vyzi/core/widgets/primary_button.dart';
import 'package:vyzi/core/widgets/social_button.dart';
import 'package:vyzi/core/services/social_auth_service.dart';
import 'package:vyzi/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vyzi/core/exceptions/app_exceptions.dart';
import 'package:vyzi/features/auth/controller/auth_controller.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        showBackButton: true,
        onLeadingPressed: () {
          if (Navigator.of(context).canPop()) {
            Get.back();
          } else {
            Get.offAllNamed(AppRoutes.onboardScreen);
          }
        },
        actions: [
          IconButton(
            icon: Icon(Icons.close, size: 22.sp, color: AppColors.textPrimary),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Get.offAllNamed(AppRoutes.onboardScreen);
              }
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
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
                  'auth.login.title'.tr,
                  style: AppStyles.h2,
                ),

                SizedBox(height: 20.h),


                // ── Email ──────────────────────────
                CustomTextField(
                  labelText: 'auth.login.email_label'.tr,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'auth.login.email_hint'.tr,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'auth.login.email_error'.tr;
                    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                    if (!emailRegex.hasMatch(v)) return 'auth.login.email_error'.tr;
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                // ── Password ───────────────────────
                CustomTextField(
                  labelText: 'auth.login.password_label'.tr,
                  controller: _passwordController,
                  isPassword: true,
                  hintText: 'auth.login.password_hint'.tr,
                  validator: (v) => v == null || v.length < 8 ? 'auth.login.password_error'.tr : null,
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
                          style: AppStyles.body3,
                          children: [
                            TextSpan(text: '${'auth.login.forgot_password'.tr}    '),
                            TextSpan(
                              text: 'auth.login.reset_now'.tr,
                              style: AppStyles.body3.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
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
                  title: 'auth.login.button'.tr,
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      final auth = Get.put(AuthController());
                      try {
                        await auth.login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                        // Navigate to navbar only if login is successful
                        Get.offNamed(AppRoutes.navbarScreen);
                      } on ServerException catch (e) {
                        if (e.statusCode == 403 && e.message.contains('not verified')) {
                          Get.snackbar('auth.validation.info'.tr, 'auth.login.error.not_verified'.tr);
                          Get.toNamed(
                            AppRoutes.createAccountOtpScreen,
                            arguments: {'email': _emailController.text.trim()},
                          );
                        } else {
                          String errorMessage = 'auth.login.error.failed'.tr;
                          final rawError = auth.error.value;
                          if (rawError.contains('Invalid email or password')) {
                            errorMessage = 'auth.login.error.invalid_credentials'.tr;
                          } else if (rawError.contains('suspended')) {
                            errorMessage = 'auth.login.error.suspended'.tr;
                          }
                          Get.snackbar('auth.validation.error'.tr, errorMessage);
                        }
                      } catch (e) {
                        Get.snackbar('auth.validation.error'.tr, 'auth.login.error.failed'.tr);
                      }
                    }
                  },
                ),

                SizedBox(height: 20.h),

                // ── Divider ────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        'auth.login.divider'.tr,
                        style: AppStyles.caption,
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),

                SizedBox(height: 16.h),

                // ── Facebook ───────────────────────
                SocialButton(
                  label: 'auth.login.facebook'.tr,
                  logo: _facebookLogo(),
                  onPress: () => _handleSocialLogin(SocialProvider.facebook),
                ),

                SizedBox(height: 10.h),

                // ── Apple ──────────────────────────
                SocialButton(
                  label: 'auth.login.apple'.tr,
                  logo: _appleLogo(),
                  onPress: () => _handleSocialLogin(SocialProvider.apple),
                ),

                SizedBox(height: 10.h),

                // ── Google ─────────────────────────
                SocialButton(
                  label: 'auth.login.google'.tr,
                  logo: _googleLogo(),
                  onPress: () => _handleSocialLogin(SocialProvider.google),
                ),

                SizedBox(height: 20.h),

                // ── Create Account Link ─────────────────────
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: AppStyles.body3,
                      children: [
                        TextSpan(text: 'auth.login.no_account'.tr),
                        TextSpan(
                          text: 'auth.login.signup'.tr,
                          style: AppStyles.body3.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }


  Future<void> _handleSocialLogin(SocialProvider provider) async {
    final auth = Get.put(AuthController());
    try {
      await auth.socialLogin(provider);
      Get.offAllNamed(AppRoutes.navbarScreen);
    } catch (e) {
      String errorMessage = 'auth.login.error.social_failed'.tr;
      final rawError = auth.error.value;
      if (rawError.contains('suspended')) {
        errorMessage = 'auth.login.error.suspended'.tr;
      } else if (rawError.contains('annullato')) {
        errorMessage = rawError;
      }
      Get.snackbar('auth.validation.error'.tr, errorMessage);
    }
  }

  // ── Labeled field wrapper ──────────────────
  Widget _labeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppStyles.caption,
        ),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }

  // ── Brand Logos ────────────────────────────
  Widget _facebookLogo() {
    return Image.asset(
      AppAssets.facebook,
      width: 24.w,
      height: 24.h,
    );
  }

  Widget _appleLogo() {
    return Image.asset(
      AppAssets.apple,
      width: 24.w,
      height: 24.h,
    );
  }

  Widget _googleLogo() {
    return Image.asset(
      AppAssets.google,
      width: 24.w,
      height: 24.h,
    );
  }
}

