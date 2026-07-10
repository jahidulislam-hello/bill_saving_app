import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/features/auth/controller/auth_controller.dart';
import 'package:vyzi/features/profile/agreements/agreements_screen.dart';
import 'package:vyzi/features/profile/controller/profile_controller.dart';
import 'package:vyzi/features/profile/invite_friends/invite_friends.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vyzi/features/profile/settings/my_requests_profile.dart';
import 'package:vyzi/features/profile/settings/my_utilities_profile_screen.dart';
import 'package:vyzi/features/support/support_screen.dart';

import 'personal_data_screen.dart';
import 'settings/more_screen.dart';
import 'widgets/upgrade_to_business_sheet.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = ProfileController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  MENU DATA
  // ─────────────────────────────────────────────

  // Account Management — 3 items
  final List<_MenuItem> _accountItems = [
    _MenuItem(
      assetIcon: AppAssets.menuPersonal,
      titleKey: 'profile.menu.personal_data',
      subtitleKey: 'profile.menu.personal_data_desc',
      route: 'personal_data',
    ),

    _MenuItem(
      assetIcon: AppAssets.menuUtilities,
      titleKey: 'profile.menu.utilities',
      subtitleKey: 'profile.menu.utilities_desc',
      route: 'utilities',
    ),

    _MenuItem(
      assetIcon: AppAssets.menuRequests,
      titleKey: 'profile.menu.requests',
      subtitleKey: 'profile.menu.requests_desc',
      route: 'requests',
    ),


  ];

// Invite and Rewards — 1 item
  final List<_MenuItem> _inviteItems = [
    _MenuItem(
      assetIcon: AppAssets.menuInvite,
      titleKey: 'profile.menu.invite',
      subtitleKey: 'profile.menu.invite_desc',
      route: 'invite',
    ),
  ];

// Others — 3 items
  final List<_MenuItem> _otherItems = [

    _MenuItem(
      assetIcon: AppAssets.menuSupport,
      titleKey: 'profile.menu.support',
      subtitleKey: 'profile.menu.support_desc',
      route: 'supports',
    ),
    _MenuItem(
      assetIcon: AppAssets.menuAgreements,
      titleKey: 'profile.menu.agreements',
      subtitleKey: 'profile.menu.agreements_desc',
      route: 'agreements',
    ),
    _MenuItem(
      assetIcon: AppAssets.menuMore,
      titleKey: 'profile.menu.more',
      subtitleKey: 'profile.menu.more_desc',
      route: 'more',
    ),
  ];

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageHeader(),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(),
                    SizedBox(height: 24.h),
                    _buildSectionLabel('profile.section.account'.tr),
                    SizedBox(height: 10.h),
                    _buildMenuCard(_accountItems),
                    SizedBox(height: 24.h),
                    _buildSectionLabel('profile.section.invite'.tr),
                    SizedBox(height: 10.h),
                    _buildMenuCard(_inviteItems),
                    SizedBox(height: 24.h),
                    _buildSectionLabel('profile.section.other'.tr),
                    SizedBox(height: 10.h),
                    _buildMenuCard(_otherItems),
                    SizedBox(height: 24.h),
                    _buildLogoutButton(),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Page header with divider ──
  Widget _buildPageHeader() {
    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile.title'.tr,
                  style: AppStyles.h2.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 2.h),
                Text(
                  'profile.subtitle'.tr,
                  style: AppStyles.body3.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }

  // ── Purple profile card ──
  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.background.withOpacity(0.24), width: 1),
      ),
      child: Column(
        children: [
          // Top: avatar + name + email
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Avatar circle
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.background,
                    size: 30,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _controller.name,
                        style: AppStyles.h4.copyWith(color: AppColors.background, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        _controller.email,
                        style: AppStyles.body4.copyWith(color: AppColors.background.withOpacity(0.9), fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider inside card
          Divider(
            height: 1.22,
             thickness: 1,
            color: AppColors.background.withOpacity(0.24),
          ),

          // Bottom: Account type + switch button
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'profile.account_type_label'.tr,
                      style: AppStyles.caption.copyWith(color: AppColors.background.withOpacity(0.85), fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _controller.accountType,
                      style: AppStyles.body1.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.background,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (_controller.accountType == 'Privato') {
                      showUpgradeToBusinessSheet(
                        context,
                        onConfirm: () => _controller.switchToBusiness(),
                      );
                    } else {
                      _controller.switchToBusiness();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppAssets.swapIcon,
                          width: 14.sp,
                          height: 14.sp,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          _controller.accountType == 'Privato'
                              ? 'profile.switch_to_business'.tr
                              : 'profile.switch_to_personal'.tr,
                          style: AppStyles.label.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ──
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppStyles.body2.copyWith(
        fontWeight: FontWeight.w900,
        color: AppColors.textDark,
      ),
    );
  }

  // ── White menu card with list of items ──
  Widget _buildMenuCard(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderPurple, width: 1.22),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          return Column(
            children: [
              _buildMenuItem(item),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 14.w,
                  endIndent: 14.w,
                  color: AppColors.divider,
                ),
            ],
          );
        }),
      ),
    );
  }

  // ── Single menu row ──
  Widget _buildMenuItem(_MenuItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: () => _handleMenuTap(item.route),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 14.h,
        ),
        child: Row(
          children: [
            // Asset Icon
            Container(
              width: 42.w,
              height: 42.w,
              alignment: Alignment.center,
              child: Image.asset(
                item.assetIcon,
                width: 42.w,
                height: 42.w,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(width: 14.w),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.titleKey.tr,
                    style: AppStyles.body2.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Text(
                    item.subtitleKey.tr,
                    style: AppStyles.body4.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textDark,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  // ── Log Out button ──
  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderPurple, width: 1.22),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('profile.menu.logout'.tr),
              content: Text('profile.logout.confirm'.tr),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('common.cancel'.tr),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    final auth = Get.put(AuthController());
                    auth.logout();
                  },
                  child: Text('profile.menu.logout'.tr, style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded,
                  color: AppColors.error, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                'profile.menu.logout'.tr,
                style: AppStyles.body2.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Navigation handler ──
  void _handleMenuTap(String route) {
    if (route == 'personal_data') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PersonalDataScreen(controller: _controller),
        ),
      );
    }
    if (route == 'agreements') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AgreementsScreen(),
        ),
      );
    }
    if (route == 'invite') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InviteScreen(),
        ),
      );
    }
    if (route == 'more') {
     Navigator.push(
       context,
       MaterialPageRoute(
           builder: (_) => MoreScreen(),
    ),
  );
}
    if (route == 'utilities') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MyUtilitiesProfileScreen(),
        ),
      );
    }
    if (route == 'requests') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MyRequestsProfile(),
        ),
      );
    }
    if (route == 'supports') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SupportoScreen(),
        ),
      );
    }


    // Add other routes as needed
  }
}


// ── Menu item data class ──
class _MenuItem {
  final String assetIcon;
  final String titleKey;
  final String subtitleKey;
  final String route;

  const _MenuItem({
    required this.assetIcon,
    required this.titleKey,
    required this.subtitleKey,
    required this.route,
  });
}
