import 'package:vyzi/core/appbar/custom_appbar.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vyzi/features/support/support_screen.dart';
import 'about_us.dart';
import 'faq_question.dart';
import 'privacy_policy.dart';
import 'terms_condition.dart';

class MoreScreen extends StatelessWidget {
  MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: "Impostazioni", showBackButton: true),
            const SizedBox(height: 32),

            // Settings List wrapped in a single card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0x1A333333),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SettingTile(
                      iconWidget: Image.asset(
                        AppAssets.privacy,
                        width: 24,
                        height: 24,
                      ),
                      title: "Informativa sulla Privacy",
                      trailingIcon: Image.asset(
                        AppAssets.arrowRight,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        Get.to(() => PrivacyPolicyScreen());
                      },
                    ),
                    const SizedBox(height: 12),
                    SettingTile(
                      iconWidget: Image.asset(
                        AppAssets.terms,
                        width: 24,
                        height: 24,
                      ),
                      title: "Termini e Condizioni",
                      onTap: () {
                        Get.to(() => TermsCondition());
                      },
                    ),
                    const SizedBox(height: 12),
                    SettingTile(
                      iconWidget: Image.asset(
                        AppAssets.about,
                        width: 24,
                        height: 24,
                      ),
                      title: "Su Easy Saving",
                      trailingIcon: Image.asset(
                        AppAssets.arrowRight,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        Get.to(() => AboutUs());
                      },
                    ),
                    const SizedBox(height: 12),
                    SettingTile(
                      iconWidget: Image.asset(
                        AppAssets.menuSupport,
                        width: 24,
                        height: 24,
                      ),
                      title: "Faq",
                      trailingIcon: Image.asset(
                        AppAssets.arrowRight,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        Get.to(() => SupportoScreen());
                      },
                    ),
                    const SizedBox(height: 12),
                    SettingTile(
                      iconWidget: Image.asset(
                        AppAssets.close,
                        width: 24,
                        height: 24,
                      ),
                      title: "Elimina Account",
                      trailingIcon: Image.asset(
                        AppAssets.arrowRight,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Elimina Account'),
                            content: const Text(
                              'Sei sicuro di voler eliminare il tuo account? Questa azione è irreversibile.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Annulla'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  final auth = Get.put(AuthController());
                                  auth.logout();
                                },
                                child: const Text(
                                  'Elimina',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final Widget? iconWidget;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailingIcon;

  const SettingTile({
    super.key,
    this.iconWidget,
    required this.title,
    this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            iconWidget ?? const SizedBox.shrink(),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppStyles.body2.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
              ),
            ),
            trailingIcon ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
