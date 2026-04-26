import 'package:flutter/material.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({super.key});

  // ── Design Tokens ──
  static const _purple = Color(0xFF6C5CE7);
  static const _purpleBg = Color(0xFFF0EEFB);
  static const _green = Color(0xFF00B894);
  static const _greenBg = Color(0xFFE8F8F5);
  static const _orange = Color(0xFFFFAB00);
  static const _orangeBg = Color(0xFFFFF8E1);
  static const _grey = Color(0xFFB2BEC3);
  static const _greyBg = Color(0xFFF5F6FA);
  static const _textDark = Color(0xFF2D3436);
  static const _textMid = Color(0xFF636E72);
  static const _textLight = Color(0xFFB2BEC3);
  static const _cardBg = Colors.white;
  static const _bg = Color(0xFFF7F8FC);
  static const _divider = Color(0xFFEEEEEE);
  static const _infoBg = Color(0xFFEFF2FF);
  static const _infoBorder = Color(0xFFD0D8FF);
  static const _yellowBadgeBg = Color(0xFFFFF8E1);
  static const _yellowBadgeText = Color(0xFFFFAB00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      leadingWidth: 40,
      leading: const Padding(
        padding: EdgeInsets.only(left: 12),
        child: Icon(Icons.chevron_left, color: _textDark, size: 28),
      ),
      title: const Text(
        'Request Details',
        style: TextStyle(
          color: _textDark,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Processing Card ──
  Widget _processingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Processing Your Request',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "We're working on your switch. No action\nneeded from you right now.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textMid,
              fontSize: 13,
              height: 1.55,
            ),
          ),
        ],
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
                    fontWeight: FontWeight.w700),
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
                      'Electricity',
                      style: TextStyle(
                          color: _textMid,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Sorgenia',
                      style: TextStyle(
                          color: _textMid,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Next e-Business Sunlight',
                  style: TextStyle(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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
                children: const [
                  Text(
                    'SUBMISSION DATE',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '3/30/2026',
                    style: TextStyle(
                      color: _textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
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
                  children: const [
                    Icon(Icons.circle, color: _yellowBadgeText, size: 8),
                    SizedBox(width: 5),
                    Text(
                      'In Analysis',
                      style: TextStyle(
                        color: _yellowBadgeText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),
          const Divider(color: _divider, height: 1),
          const SizedBox(height: 22),

          // Steps
          _timelineStep(
            icon: Icons.check,
            iconColor: Colors.white,
            iconBg: _green,
            connectorColor: _green,
            title: 'Submitted',
            subtitle: 'Request received successfully',
            isActive: true,
            isLast: false,
          ),
          _timelineStep(
            icon: Icons.sync,
            iconColor: _orange,
            iconBg: _orangeBg,
            connectorColor: _grey,
            title: 'Analyzing',
            subtitle: 'Our experts are verifying data',
            isActive: true,
            isLast: false,
            isCurrentStep: true,
          ),
          _timelineStep(
            icon: Icons.hourglass_empty,
            iconColor: _grey,
            iconBg: _greyBg,
            connectorColor: Colors.transparent,
            title: 'Contract',
            subtitle: 'Final switch confirmation',
            isActive: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _timelineStep({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
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
            width: 44,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                    border: isCurrentStep
                        ? Border.all(color: _orange.withOpacity(0.3), width: 3)
                        : null,
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
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
                  top: 8, bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isActive ? _textDark : _textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive ? _textMid : _textLight,
                      fontSize: 12,
                      height: 1.4,
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
        border: Border.all(color: _infoBorder),
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
              border: Border.all(color: _infoBorder),
            ),
            child: const Icon(Icons.info_outline, color: _purple, size: 16),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'The verification process typically takes 3-5 business days. We will notify you once completed.',
              style: TextStyle(
                color: _purple,
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}