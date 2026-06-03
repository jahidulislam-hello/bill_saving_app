import 'package:vyzi/core/appbar/custom_appbar.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF5A1ABE),
                    width: 1.22,
                  ),
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
                    const Divider(height: 1, color: Color(0xFF5A1ABE)),
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
                    const Divider(height: 1, color: Color(0xFF5A1ABE)),
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
                    const Divider(height: 1, color: Color(0xFF5A1ABE)),
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
                    const Divider(height: 1, color: Color(0xFF5A1ABE)),
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
                        // Get.to(() => TermsScreen());
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        height: 54,
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
