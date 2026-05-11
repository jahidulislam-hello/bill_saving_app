
import 'package:vyzi/core/appbar/custom_appbar.dart';
import 'package:vyzi/core/utils/app_icons.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: "Settings", showBackButton: true),
            const SizedBox(height: 32),

            // Settings List wrapped in a single card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0x1A333333),
                    width: 1.22,
                  ),
                ),
                child: Column(
                  children: [
                    SettingTile(
                      iconWidget: Image.asset(
                        AppIcons.privacy,
                        width: 24,
                        height: 24,
                      ),
                      title: "Privacy Policy",
                      trailingIcon: Image.asset(
                        AppIcons.arrow,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        Get.to(() => PrivacyPolicyScreen());
                      },
                    ),
                    const Divider(height: 1, color: Color(0x1A333333)),
                    SettingTile(
                      iconWidget: Image.asset(
                        AppIcons.about,
                        width: 24,
                        height: 24,
                      ),
                      title: "Terms & Condition",
                      onTap: () {
                        Get.to(() => TermsCondition());
                      },
                    ),
                    const Divider(height: 1, color: Color(0x1A333333)),
                    SettingTile(
                      iconWidget: Image.asset(
                        AppIcons.terms,
                        width: 24,
                        height: 24,
                      ),
                      title: "About Easy Saving",
                      trailingIcon: Image.asset(
                        AppIcons.arrow,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        Get.to(() => AboutUs());
                      },
                    ),
                    const Divider(height: 1, color: Color(0x1A333333)),
                    SettingTile(
                      iconWidget: Image.asset(
                        AppIcons.terms,
                        width: 24,
                        height: 24,
                      ),
                      title: "Faq",
                      trailingIcon: Image.asset(
                        AppIcons.arrow,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {
                        Get.to(() => SupportoScreen());
                      },
                    ),
                    const Divider(height: 1, color: Color(0x1A333333)),
                    SettingTile(
                      iconWidget: Image.asset(
                        AppIcons.delete,
                        width: 24,
                        height: 24,
                      ),
                      title: "Delete Account",
                      trailingIcon: Image.asset(
                        AppIcons.arrow,
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailingIcon ?? const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
