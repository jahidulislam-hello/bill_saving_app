import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vyzi/features/home/sign_contract/sign_contract.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({super.key});

  // ── Design Tokens ──
  static const _purple = AppColors.primaryColor;
  static const _purpleBg = AppColors.primary100;
  static const _green = AppColors.green;
  static const _greenBg = AppColors.primaryPurple;
  static const _orange = AppColors.yellow200;
  static const _grey = AppColors.neutral500;
  static const _textDark = AppColors.textDark;
  static const _textMid = AppColors.textMid;
  static const _cardBg = AppColors.cardBg;
  static const _bg = AppColors.background;
  static const _infoBg = AppColors.primaryPurple;
  static const _yellowBadgeBg = AppColors.yellowAlpha10;
  static const _yellowBadgeText = AppColors.yellow200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 14 + MediaQuery.of(context).padding.bottom),
        children: [
          _processingCard(),
          const SizedBox(height: 14),
          _productCard(),
          const SizedBox(height: 14),
          _timelineCard(),
          const SizedBox(height: 14),
          _infoBox(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.chevron_left, color: _textDark, size: 28),
        ),
      ),
      title: Text(
        'request.details.title'.tr,
        style: const TextStyle(
          color: _textDark,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  // ── Processing Card ──
  Widget _processingCard() {
    return GestureDetector(
      onTap: () => Get.to(() => const SignContractScreen()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        decoration: BoxDecoration(
          color: _greenBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFE8F9), width: 1.22),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            // Icon badge
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: _purpleBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.description_outlined,
                  color: _purple, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'request.details.processing_title'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _textDark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'request.details.processing_desc'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _textMid,
                fontSize: 13,
                height: 1.55,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Product Card ──
  Widget _productCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFFF), width: 1.22),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          // Logo placeholder
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'sorgenia',
                style: TextStyle(
                    fontSize: 6,
                    color: Color(0xFF009966),
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, color: Color(0xFF00B0FF), size: 14),
                    const SizedBox(width: 3),
                    const Text(
                      'Elettricità',
                      style: TextStyle(
                          color: _textMid,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 22),
                    const Text(
                      'Sorgenia',
                      style: TextStyle(
                          color: _textMid,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Next e-Business Sunlight',
                  style: TextStyle(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Timeline Card ──
  Widget _timelineCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF), width: 1.22),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'request.details.submission_date'.tr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    '3/30/2026',
                    style: TextStyle(
                      color: _textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              // Status badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _yellowBadgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: _yellowBadgeText, size: 8),
                    const SizedBox(width: 5),
                    Text(
                      'request.details.in_analysis'.tr,
                      style: const TextStyle(
                        color: _yellowBadgeText,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // const SizedBox(height: 22),
          // const Divider(color: _divider, height: 1),
          const SizedBox(height: 22),

          // Steps
          _timelineStep(
            assetIcon: 'assets/images/thik.png',
            connectorColor: _green,
            title: 'request.status.sent'.tr,
            subtitle: 'request.status.sent_desc'.tr,
            isActive: true,
            isLast: false,
          ),
          _timelineStep(
            assetIcon: 'assets/images/reverse.png',
            connectorColor: _grey,
            title: 'request.status.analyzing'.tr,
            subtitle: 'request.status.analyzing_desc'.tr,
            isActive: true,
            isLast: false,
            isCurrentStep: true,
          ),
          _timelineStep(
            assetIcon: 'assets/images/cont.png',
            connectorColor: Colors.transparent,
            title: 'request.status.contract'.tr,
            subtitle: 'request.status.contract_desc'.tr,
            isActive: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _timelineStep({
    required String assetIcon,
    required Color connectorColor,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isLast,
    bool isCurrentStep = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + connector column
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isCurrentStep
                        ? Border.all(
                      color: _orange.withOpacity(0.3),
                      width: 3,
                    )
                        : null,
                  ),
                  child: Center(
                    child: Image.asset(
                      assetIcon,
                      width: 48.w,
                      height: 48.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: connectorColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: isLast ? 0 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Info Box ──
  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _infoBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB396E1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEFE8F9)),
            ),
            child: const Icon(Icons.info_outline, color: _purple, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'request.details.info_message'.tr,
              style: const TextStyle(
                color: _grey,
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
