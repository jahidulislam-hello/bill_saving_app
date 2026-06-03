import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'invite_controller.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final InviteController _controller = InviteController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F8),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero section ──
            _buildHeroSection(),

            SizedBox(height: 16.h),

            // ── Referral link card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildReferralCard(),
            ),

            SizedBox(height: 12.h),

            // ── You earn / Friend gets row ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildRewardRow(),
            ),

            SizedBox(height: 24.h),

            // ── Invite Statistics label ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Statistiche Inviti',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1A1A2E),
                  height: 1.22,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // ── Statistics card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildStatisticsCard(),
            ),

            SizedBox(height: 12.h),

            // ── Total Earnings card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildEarningsCard(),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  APP BAR
  // ─────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded,
            color: const Color(0xFF1A1A2E), size: 22.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Invita i tuoi amici',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1A1A2E),
          height: 1.22,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: const Color(0xFF5A1ABE)),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  HERO SECTION  (icon + title + subtitle)
  // ─────────────────────────────────────────────

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF0F0F8),
      padding: EdgeInsets.only(top: 30.h, bottom: 10.h),
      child: Column(
        children: [
          // Gift icon in teal circle
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7F4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              size: 32.sp,
              color: const Color(0xFF00B8A0),
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'Condividi il risparmio',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E),
              height: 1.22,
            ),
          ),

          SizedBox(height: 8.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              'Aiuta i tuoi amici a ridurre le bollette e\nricevi un premio per ogni attivazione riuscita.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  REFERRAL LINK CARD
  // ─────────────────────────────────────────────

  Widget _buildReferralCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label ──
          Text(
            'Link di invito personale',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              height: 1.22,
            ),
          ),

          SizedBox(height: 10.h),

          // ── Link row with copy icon ──
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FB),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFF5A1ABE),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _controller.referralLink,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w700,
                      height: 1.22,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => _controller.copyLink(context),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _controller.isCopied
                        ? Icon(
                      Icons.check_rounded,
                      key: const ValueKey('check'),
                      color: const Color(0xFF4CAF50),
                      size: 20.sp,
                    )
                        : Icon(
                      Icons.copy_rounded,
                      key: const ValueKey('copy'),
                      color: AppColors.primaryColor,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // ── Share link button ──
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: () => _controller.shareLink(context),
              icon: Icon(Icons.share_rounded, size: 18.sp),
              label: Text(
                'Condividi link',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.22,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  REWARD ROW  (You earn | Friend gets)
  // ─────────────────────────────────────────────

  Widget _buildRewardRow() {
    return Row(
      children: [
        Expanded(
          child: _buildRewardCard(
            icon: Icons.person_add_alt_1_rounded,
            iconBg: const Color(0xFFE8F8EF),
            iconColor: const Color(0xFF27AE60),
            topLabel: 'Tu guadagni',
            amount: _controller.youEarn,
            bottomLabel: 'Quando il loro contratto viene\nattivato',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildRewardCard(
            icon: Icons.group_rounded,
            iconBg: const Color(0xFFEAF0FF),
            iconColor: const Color(0xFF5B7FD8),
            topLabel: 'L\'amico riceve',
            amount: _controller.friendGets,
            bottomLabel: 'Applicato alla loro prima\nattivazione',
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String topLabel,
    required String amount,
    required String bottomLabel,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),

          SizedBox(height: 10.h),

          // Top label
          Text(topLabel,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              height: 1.22,
            ),
          ),

          SizedBox(height: 4.h),

          // Amount
          Text(
            amount,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E),
              height: 1.22,
            ),
          ),

          SizedBox(height: 6.h),

          // Bottom label
          Text(
            bottomLabel,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  STATISTICS CARD
  // ─────────────────────────────────────────────

  Widget _buildStatisticsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatRow(
            icon: Icons.mail_outline_rounded,
            iconBg: const Color(0xFFEAF0FF),
            iconColor: const Color(0xFF5B7FD8),
            title: 'Inviti inviati',
            subtitle: 'Link totali condivisi',
            value: _controller.invitesSent,
            isLast: false,
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 58.w,
            color: const Color(0xFF5A1ABE),
          ),
          _buildStatRow(
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFE8F8EF),
            iconColor: const Color(0xFF27AE60),
            title: 'Inviti completati',
            subtitle: 'Attivati con successo',
            value: _controller.completedInvites,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required int value,
    required bool isLast,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          // Icon box
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 14.w),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A2E),
                    height: 1.22,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ],
            ),
          ),

          // Value badge
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFF),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryColor,
                height: 1.22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  TOTAL EARNINGS CARD
  // ─────────────────────────────────────────────

  Widget _buildEarningsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: label + AVAILABLE badge ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Guadagni Totali',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1A1A2E),
                  height: 1.22,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EF),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7.w,
                      height: 7.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      _controller.earningsStatus,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF27AE60),
                        height: 1.22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // ── Amount ──
          Text(
            '€${_controller.totalEarnings.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E),
              height: 1.22,
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            _controller.earningsType,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              height: 1.22,
            ),
          ),

          SizedBox(height: 16.h),

          // ── Progress bar ──
          _buildProgressBar(),
        ],
      ),
    );
  }

  // ── Progress bar with Amazon arrow style ──
  Widget _buildProgressBar() {
    return Column(
      children: [
        // Bar
        Stack(
          children: [
            // Track
            Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            // Fill — about 25% to match screenshot
            FractionallySizedBox(
              widthFactor: 0.25,
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9900), // Amazon orange
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 6.h),

        // Arrow label at 25%
        Align(
          alignment: const Alignment(-0.5, 0),
          child: Column(
            children: [
              Icon(Icons.arrow_upward_rounded,
                  size: 14.sp, color: const Color(0xFFFF9900)),
              Text(
                _controller.progressAmount,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFF9900),
                  height: 1.22,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
