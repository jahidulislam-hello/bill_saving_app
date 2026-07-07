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

  bool _agreeToTerms = false;
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    selectedRole = Get.arguments?['role'] ?? 'personal';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  'Crea un account',
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
                        labelText: 'Nome *',
                        controller: _firstNameController,
                        hintText: 'Alex',
                        validator: (v) => v == null || v.isEmpty ? 'Obbligatorio' : null,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Cognome *',
                        controller: _lastNameController,
                        hintText: 'Smith',
                        validator: (v) => v == null || v.isEmpty ? 'Obbligatorio' : null,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // ── Email ──────────────────────────
                CustomTextField(
                  labelText: 'Indirizzo Email *',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'you@example.com',
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Icon(
                      Icons.mail_outline,
                      color: AppColors.primaryColor,
                      size: 20.sp,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Inserisci un\'email valida';
                    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                    if (!emailRegex.hasMatch(v)) return 'Inserisci un\'email valida';
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                // ── Phone with flag (inline) ───────
                PhoneTextField(
                  labelText: 'Numero di telefono (opzionale)',
                  controller: _phoneController,
                ),

                SizedBox(height: 12.h),

                // ── Password ───────────────────────
                CustomTextField(
                  labelText: 'Password *',
                  controller: _passwordController,
                  isPassword: true,
                  hintText: '••••••••••',
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Minimo 8 caratteri';
                    if (v.length < 8) return 'Minimo 8 caratteri';
                    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Deve contenere almeno una lettera minuscola';
                    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Deve contenere almeno una lettera maiuscola';
                    if (!RegExp(r'\d').hasMatch(v)) return 'Deve contenere almeno un numero';
                    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"|,.<>/?\\]').hasMatch(v)) return 'Deve contenere almeno un carattere speciale';
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                // ── Confirm Password ───────────────
                CustomTextField(
                  labelText: 'Conferma Password *',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  hintText: '••••••••••',
                  validator: (v) =>
                      v != _passwordController.text ? 'Le password non corrispondono' : null,
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
                            const TextSpan(
                                text: 'Accetto i Termini di Servizio e '),
                            TextSpan(
                              text: "l'Informativa sulla Privacy",
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
                  title: 'Registrati',
                  onPress: () async {
                    if (_formKey.currentState!.validate() && _agreeToTerms) {
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
                        );

                        // Navigate to OTP verification screen and pass email
                        Get.toNamed(AppRoutes.createAccountOtpScreen, arguments: {
                          'email': _emailController.text.trim(),
                          'type': 'email_verification'
                        });
                      } catch (e) {
                        String errorMessage = 'Registrazione fallita. Riprova.';
                        final rawError = auth.error.value;
                        if (rawError.contains('Email already registered')) {
                          errorMessage = 'Email già registrata';
                        } else if (rawError.contains('Password must contain')) {
                          errorMessage = 'La password non soddisfa i requisiti di sicurezza';
                        }
                        Get.snackbar('Errore', errorMessage);
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

                // ── Login Link ─────────────────────
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Hai già un account? ',
                        ),
                        TextSpan(
                          text: 'Accedi',
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

