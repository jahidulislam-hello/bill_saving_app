import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/features/profile/agreements/agreements_screen.dart';
import 'package:vyzi/features/profile/controller/profile_controller.dart';
import 'package:vyzi/features/profile/invite_friends/invite_friends.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final List<_MenuItem> _accountItems = const [
    _MenuItem(
      assetIcon: AppAssets.menuPersonal,
      title: 'Dati Personali',
      subtitle: 'Modifica le informazioni del tuo profilo',
      route: 'personal_data',
    ),

    _MenuItem(
      assetIcon: AppAssets.menuUtilities,
      title: 'Le tue utenze',
      subtitle: 'Visualizza i servizi attivi',
      route: 'utilities',
    ),

    _MenuItem(
      assetIcon: AppAssets.menuRequests,
      title: 'Le tue richieste',
      subtitle: 'Segui i tuoi passaggi',
      route: 'requests',
    ),


  ];

// Invite and Rewards — 1 item
  final List<_MenuItem> _inviteItems = const [
    _MenuItem(
      assetIcon: AppAssets.menuInvite,
      title: 'Invita e Guadagna',
      subtitle: 'Condividi il tuo link e guadagna 10',
      route: 'invite',
    ),
  ];

// Others — 3 items
  final List<_MenuItem> _otherItems = const [

    _MenuItem(
      assetIcon: AppAssets.menuSupport,
      title: 'Supporto',
      subtitle: 'Ricevi aiuto e contattaci',
      route: 'supports',
    ),
    _MenuItem(
      assetIcon: AppAssets.menuAgreements,
      title: 'Convenzioni',
      subtitle: 'Sconti esclusivi dei partner',
      route: 'agreements',
    ),
    _MenuItem(
      assetIcon: AppAssets.menuMore,
      title: 'Altro',
      subtitle: 'Privacy Legale',
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
                    _buildSectionLabel('Gestione Account'),
                    SizedBox(height: 10.h),
                    _buildMenuCard(_accountItems),
                    SizedBox(height: 24.h),
                    _buildSectionLabel('Invita e Premi'),
                    SizedBox(height: 10.h),
                    _buildMenuCard(_inviteItems),
                    SizedBox(height: 24.h),
                    _buildSectionLabel('Altro'),
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
                  'Profilo',
                  style: AppStyles.h2.copyWith(color: AppColors.textDark),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Gestisci le impostazioni del tuo account',
                  style: AppStyles.body3,
                ),
              ],
            ),
          ),
          Divider(
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
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
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
                        style: AppStyles.h4.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        _controller.email,
                        style: AppStyles.body4.copyWith(color: Colors.white.withOpacity(0.8)),
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
            color: AppColors.accentBlue,
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
                      'Tipo di account',
                      style: AppStyles.caption.copyWith(color: Colors.white.withOpacity(0.7)),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _controller.accountType,
                      style: AppStyles.body1.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
                      color: AppColors.lightPurple,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.borderPurple,
                        width: 1,
                      ),
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
                              ? 'Passa ad Azienda'
                              : 'Passa a Privato',
                          style: AppStyles.label.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.darkPurple,
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
        fontWeight: FontWeight.w600,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                    item.title,
                    style: AppStyles.body2.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Text(
                    item.subtitle,
                    style: AppStyles.body4,
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.neutral400,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded,
                  color: AppColors.error, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                'Disconnetti',
                style: AppStyles.body2.copyWith(
                  fontWeight: FontWeight.w600,
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
  final String title;
  final String subtitle;
  final String route;

  const _MenuItem({
    required this.assetIcon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
