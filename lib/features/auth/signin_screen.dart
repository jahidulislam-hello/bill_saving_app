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
                  'Accedi al tuo account',
                  style: AppStyles.h2,
                ),

                SizedBox(height: 20.h),


                // ── Email ──────────────────────────
                CustomTextField(
                  labelText: 'Indirizzo Email *',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'you@example.com',
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Inserisci un\'email valida';
                    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                    if (!emailRegex.hasMatch(v)) return 'Inserisci un\'email valida';
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                // ── Password ───────────────────────
                CustomTextField(
                  labelText: 'Password *',
                  controller: _passwordController,
                  isPassword: true,
                  hintText: '••••••••••',
                  validator: (v) => v == null || v.length < 8 ? 'Minimo 8 caratteri' : null,
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
                            const TextSpan(text: 'Hai dimenticato la password?    '),
                            TextSpan(
                              text: 'Reimposta ora',
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
                  title: 'Accedi',
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
                          Get.snackbar('Info', 'Email non verificata. Completa la verifica OTP.');
                          Get.toNamed(
                            AppRoutes.createAccountOtpScreen,
                            arguments: {'email': _emailController.text.trim()},
                          );
                        } else {
                          String errorMessage = 'Login fallito. Riprova.';
                          final rawError = auth.error.value;
                          if (rawError.contains('Invalid email or password')) {
                            errorMessage = 'Email o password non valida';
                          } else if (rawError.contains('suspended')) {
                            errorMessage = 'Il tuo account è stato sospeso. Contatta l\'assistenza.';
                          }
                          Get.snackbar('Errore', errorMessage);
                        }
                      } catch (e) {
                        Get.snackbar('Errore', 'Login fallito. Riprova.');
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
                        'Oppure accedi con',
                        style: AppStyles.caption,
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),

                SizedBox(height: 16.h),

                // ── Facebook ───────────────────────
                SocialButton(
                  label: 'Accedi con Facebook',
                  logo: _facebookLogo(),
                  onPress: () => _handleSocialLogin(SocialProvider.facebook),
                ),

                SizedBox(height: 10.h),

                // ── Apple ──────────────────────────
                SocialButton(
                  label: 'Accedi con Apple',
                  logo: _appleLogo(),
                  onPress: () => _handleSocialLogin(SocialProvider.apple),
                ),

                SizedBox(height: 10.h),

                // ── Google ─────────────────────────
                SocialButton(
                  label: 'Accedi con Google',
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
                        const TextSpan(text: 'Non hai un account?'),
                        TextSpan(
                          text: 'Registrati ora',
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
      String errorMessage = 'Accesso social fallito. Riprova.';
      final rawError = auth.error.value;
      if (rawError.contains('suspended')) {
        errorMessage = 'Il tuo account è stato sospeso. Contatta l\'assistenza.';
      } else if (rawError.contains('annullato')) {
        errorMessage = rawError;
      }
      Get.snackbar('Errore', errorMessage);
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

