import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SignContractScreen extends StatelessWidget {
  const SignContractScreen({super.key});

  // ── Design Tokens ──
  static const _purple = AppColors.primaryColor;
  static const _purpleBg = Color(0xFFEEEAFB);
  static const _purpleLight = Color(0xFFF5F2FF);
  static const _bg = Color(0xFFF7F8FC);
  static const _cardBg = Colors.white;
  static const _textDark = Color(0xFF1A1A2E);
  static const _textMid = Color(0xFF636E72);
  static const _textLight = Color(0xFFB2BEC3);
  static const _divider = Color(0xFFF0F0F0);
  static const _green = Color(0xFF00B894);
  static const _greenBg = Color(0xFFE8F8F5);
  static const _infoBg = Color(0xFFF0EEFB);
  static const _infoBorder = Color(0xFFD8D0F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          _readyToSignCard(),
          const SizedBox(height: 14),
          _contractDetailsCard(),
          const SizedBox(height: 14),
          _whatHappensNextCard(),
          const SizedBox(height: 14),
          _helpCard(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, color: _textDark, size: 28),
        ),
      ),
      title: const Text(
        'Sign Your Contract',
        style: TextStyle(
          color: _textDark,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Ready to Sign Card ──
  Widget _readyToSignCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action Required badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _purple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Action Required',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Ready to Sign',
            style: TextStyle(
              color: _textDark,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your contract is ready! Sign it to complete\nyour switch to EnergyPlus.',
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

  // ── Contract Details Card ──
  Widget _contractDetailsCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contract Details',
            style: TextStyle(
              color: _textDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _detailRow('Supplier', 'EnergyPlus'),
          _dividerLine(),
          _detailRow('Monthly Price', '\$89.99'),
          _dividerLine(),
          _detailRow('Contract Duration', '24 months'),
          _dividerLine(),
          _detailRow('Activation Date', 'To be scheduled', valueColor: _purple, valueBold: true),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value,
      {Color valueColor = _textDark, bool valueBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: _textMid, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: valueBold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerLine() =>
      const Divider(color: _divider, height: 1, thickness: 1);

  // ── What Happens Next Card ──
  Widget _whatHappensNextCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What Happens Next',
            style: TextStyle(
              color: _textDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _nextStep(
            iconData: Icons.check_circle_outline,
            iconColor: _green,
            iconBg: _greenBg,
            title: 'Contract Sent',
            subtitle: 'Check your email for the signing link',
          ),
          const SizedBox(height: 14),
          _nextStep(
            iconData: Icons.description_outlined,
            iconColor: _purple,
            iconBg: _purpleBg,
            title: 'Sign Contract',
            subtitle: 'Use the link below to sign digitally',
          ),
          const SizedBox(height: 14),
          _nextStep(
            iconData: Icons.calendar_today_outlined,
            iconColor: _textMid,
            iconBg: const Color(0xFFF0F0F5),
            title: 'Activation',
            subtitle: 'Service starts on scheduled date',
          ),
        ],
      ),
    );
  }

  Widget _nextStep({
    required IconData iconData,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(iconData, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _textMid,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Help Card ──
  Widget _helpCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _infoBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _infoBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need help signing?',
            style: TextStyle(
              color: _textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: const [
                Text(
                  'View Signing Tutorial',
                  style: TextStyle(
                    color: _purple,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: _purple, size: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
