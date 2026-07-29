import 'package:get/get.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/widgets/custom_text_filled.dart';
import 'package:vyzi/core/widgets/phone_filled.dart';
import 'package:vyzi/core/widgets/primary_button.dart';
import 'package:vyzi/core/widgets/social_button.dart';
import 'package:vyzi/core/services/social_auth_service.dart';
import 'package:vyzi/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:vyzi/features/auth/controller/auth_controller.dart';



// ─────────────────────────────────────────────
//  Register Screen
// ─────────────────────────────────────────────
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralCodeController = TextEditingController();

  bool _agreeToTerms = false;
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    selectedRole = Get.arguments?['role'] ?? 'personal';
    final refCode = Get.arguments?['referralCode'] as String?;
    if (refCode != null && refCode.isNotEmpty) {
      _referralCodeController.text = refCode;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
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
                  'auth.signup.title'.tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 20.h),

                // ── First Name + Last Name (inline) ─
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'auth.signup.first_name_label'.tr,
                        controller: _firstNameController,
                        hintText: 'auth.signup.first_name_hint'.tr,
                        validator: (v) => v == null || v.isEmpty ? 'Obbligatorio' : null,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'auth.signup.last_name_label'.tr,
                        controller: _lastNameController,
                        hintText: 'auth.signup.last_name_hint'.tr,
                        validator: (v) => v == null || v.isEmpty ? 'Obbligatorio' : null,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // ── Email ──────────────────────────
                CustomTextField(
                  labelText: 'auth.signup.email_label'.tr,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'auth.signup.email_hint'.tr,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Icon(
                      Icons.mail_outline,
                      color: AppColors.primaryColor,
                      size: 20.sp,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'auth.login.email_error'.tr;
                    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                    if (!emailRegex.hasMatch(v)) return 'auth.login.email_error'.tr;
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                // ── Phone with flag (inline) ───────
                PhoneTextField(
                  labelText: 'auth.signup.phone_label'.tr,
                  controller: _phoneController,
                ),

                SizedBox(height: 12.h),

                // ── Password ───────────────────────
                CustomTextField(
                  labelText: 'auth.signup.password_label'.tr,
                  controller: _passwordController,
                  isPassword: true,
                  hintText: 'auth.signup.password_hint'.tr,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'auth.login.password_error'.tr;
                    if (v.length < 8) return 'auth.login.password_error'.tr;
                    if (!RegExp(r'[a-z]').hasMatch(v)) return 'auth.signup.password_lowercase'.tr;
                    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'auth.signup.password_uppercase'.tr;
                    if (!RegExp(r'\d').hasMatch(v)) return 'auth.signup.password_number'.tr;
                    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"|,.<>/?\\]').hasMatch(v)) return 'auth.signup.password_special'.tr;
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                // ── Confirm Password ───────────────
                CustomTextField(
                  labelText: 'auth.signup.confirm_password_label'.tr,
                  controller: _confirmPasswordController,
                  isPassword: true,
                  hintText: 'auth.signup.confirm_password_hint'.tr,
                  validator: (v) =>
                      v != _passwordController.text ? 'auth.signup.password_mismatch'.tr : null,
                ),

                SizedBox(height: 12.h),

                // ── Referral Code (optional) ──────
                CustomTextField(
                  labelText: 'auth.signup.referral_code_label'.tr,
                  controller: _referralCodeController,
                  hintText: 'auth.signup.referral_code_hint'.tr,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 20,
                ),

                SizedBox(height: 16.h),

                // ── Terms Checkbox ─────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _agreeToTerms = !_agreeToTerms),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: _agreeToTerms
                              ? AppColors.primaryColor
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: _agreeToTerms
                            ? Icon(Icons.check,
                            size: 14.sp, color: AppColors.background)
                            : null,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                                text: 'auth.signup.terms_label'.tr),
                            TextSpan(
                              text: 'auth.signup.privacy_label'.tr,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                            const TextSpan(text: ' *'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ── Register Button ────────────────
                PrimaryButton(
                  title: 'auth.signup.button'.tr,
                  onPress: () async {
                    if (!_agreeToTerms) {
                      Get.snackbar(
                        'auth.validation.warning'.tr,
                        'auth.signup.terms_required'.tr,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      final auth = Get.put(AuthController());
                      try {
                        await auth.register(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          phone: _phoneController.text.trim(),
                          role: selectedRole,
                          referralCode: _referralCodeController.text.trim().isEmpty
                              ? null
                              : _referralCodeController.text.trim(),
                        );

                        // Navigate to OTP verification screen and pass email
                        Get.toNamed(AppRoutes.createAccountOtpScreen, arguments: {
                          'email': _emailController.text.trim(),
                          'type': 'email_verification'
                        });
                      } catch (e) {
                        String errorMessage = 'auth.signup.registration_failed_default'.tr;
                        final rawError = auth.error.value;
                        if (rawError.contains('Email already registered')) {
                          errorMessage = 'auth.signup.error.email_exists'.tr;
                        } else if (rawError.contains('Password must contain')) {
                          errorMessage = 'auth.signup.password_requirements_unmet'.tr;
                        }
                        Get.snackbar('auth.validation.error'.tr, errorMessage);
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
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
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

                // ── Login Link ─────────────────────
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'auth.signup.have_account'.tr,
                        ),
                        TextSpan(
                          text: 'auth.signup.login'.tr,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offNamed(AppRoutes.signInScreen);
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
                onPressed: () => Get.back(),
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

