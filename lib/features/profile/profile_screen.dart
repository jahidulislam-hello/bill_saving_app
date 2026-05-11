
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/profile/agreements/agreements_screen.dart';
import 'package:vyzi/features/profile/controller/profile_controller.dart';
import 'package:vyzi/features/profile/invite_friends/invite_friends.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      icon: Icons.person_outline_rounded,
      iconBg: Color(0xFFEAF0FF),
      iconColor: Color(0xFF5B7FD8),
      title: 'Dati Personali',
      subtitle: 'Modifica le informazioni del tuo profilo',
      route: 'personal_data',
    ),
    _MenuItem(
      icon: Icons.bolt_rounded,
      iconBg: Color(0xFFE8F8EF),
      iconColor: Color(0xFF27AE60),
      title: 'Le tue utenze',
      subtitle: 'Visualizza i servizi attivi',
      route: 'utilities',
    ),
    _MenuItem(
      icon: Icons.description_outlined,
      iconBg: Color(0xFFF3EEFF),
      iconColor: Color(0xFF9B59B6),
      title: 'Le tue richieste',
      subtitle: 'Segui i tuoi passaggi',
      route: 'requests',
    ),
    _MenuItem(
      icon: Icons.contact_support,
      iconBg: Color(0xFFF3EEFF),
      iconColor: Color(0xFFFFEDD4),
      title: 'Supporto',
      subtitle: 'Ricevi aiuto e contattaci',
      route: 'supports',
    ),
  ];

  // Invite and Rewards — 1 item
  final List<_MenuItem> _inviteItems = const [
    _MenuItem(
      icon: Icons.person_add_outlined,
      iconBg: Color(0xFFEAF0FF),
      iconColor: Color(0xFF5B7FD8),
      title: 'Invita e Guadagna',
      subtitle: 'Condividi il tuo link e guadagna 10',
      route: 'invite',
    ),
  ];

  // Others — 2 items
  final List<_MenuItem> _otherItems = const [
    _MenuItem(
      icon: Icons.local_offer_outlined,
      iconBg: Color(0xFFE8F8EF),
      iconColor: Color(0xFF27AE60),
      title: 'Convenzioni',
      subtitle: 'Sconti esclusivi dei partner',
      route: 'agreements',
    ),
    _MenuItem(
      icon: Icons.apps_rounded,
      iconBg: Color(0xFFF3EEFF),
      iconColor: Color(0xFF9B59B6),
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
                    SizedBox(height: 30.h),
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
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                    height: 1.22,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Manage your account settings',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF9E9E9E),
                    height: 1.22,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade200,
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
          colors: [Color(0xFF664AE1), Color(0xFF38287B)],
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
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.22,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        _controller.email,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider inside card
          Divider(
            height: 1,
            // thickness: 1,
            color: Colors.white.withOpacity(0.2),
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
                      'Account Type',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.22,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _controller.accountType,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.22,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (_controller.accountType == 'Personal') {
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
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.swap_horiz_rounded,
                            color: Colors.white, size: 14.sp),
                        SizedBox(width: 5.w),
                        Text(
                          _controller.accountType == 'Personal'
                              ? 'Switch to Business'
                              : 'Switch to Personal',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
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
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A2E),
        height: 1.22,
      ),
    );
  }

  // ── White menu card with list of items ──
  Widget _buildMenuCard(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                  color: Colors.grey.shade100,
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
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20.sp),
            ),
            SizedBox(width: 14.w),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                      height: 1.22,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9E9E9E),
                      height: 1.22,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.grey.shade400, size: 20.sp),
          ],
        ),
      ),
    );
  }

  // ── Log Out button ──
  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                  color: const Color(0xFFE53935), size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE53935),
                  height: 1.22,
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
    // Add other routes as needed
  }
}

// ── Menu item data class ──
class _MenuItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String route;

  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}