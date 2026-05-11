import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/request/complete_request/complete_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OfferDetailsController extends ChangeNotifier {
  // Offer data
  final String supplierName = 'EnergyPlus';
  final String planName = 'Standard Residential Plan';
  final String badge = 'Best Value';
  final String savingsAmount = '€306';
  final String savingsLabel = 'Annual Savings';

  // Detail rows
  final List<OfferDetailRow> detailRows = [
    OfferDetailRow(
      label: 'Contractual binding',
      value: 'No binding',
      linkText: null,
    ),
    OfferDetailRow(
      label: 'Price type',
      value: 'Indexed price',
      linkText: "What does it mean?",
      linkColor: AppColors.linkBlue,
    ),
    OfferDetailRow(
      label: 'Energy price',
      value: 'PUN GME + 0.01 €/kWh',
      linkText: 'How is it calculated?',
      linkColor: AppColors.linkGreen,
    ),
    OfferDetailRow(
      label: 'Fixed energy matter costs',
      value: '14 \$/month',
      linkText: null,
    ),
    OfferDetailRow(
      label: 'Payment method',
      value: 'Direct debit from current account',
      linkText: null,
    ),
    OfferDetailRow(
      label: 'Contract duration',
      value: 'Indefinite duration',
      linkText: null,
    ),
  ];

  // FAQ state
  final Set<int> expandedFAQ = {};

  void toggleFAQ(int index) {
    if (expandedFAQ.contains(index)) {
      expandedFAQ.remove(index);
    } else {
      expandedFAQ.add(index);
    }
    notifyListeners();
  }

  void selectOffer() {
    Get.to(() => const CompleteRequestScreen());
  }
}

class OfferDetailRow {
  final String label;
  final String value;
  final String? linkText;
  final Color linkColor;

  const OfferDetailRow({
    required this.label,
    required this.value,
    this.linkText,
    this.linkColor = AppColors.linkBlue,
  });
}

// ─────────────────────────────────────────────
// SCREEN 1 – OFFER DETAILS
// ─────────────────────────────────────────────
class OfferDetailsScreen extends StatefulWidget {
  const OfferDetailsScreen({super.key});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  final _ctrl = OfferDetailsController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Scrollable content
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              _supplierCard(),
              const SizedBox(height: 14),
              _savingsCard(),
              const SizedBox(height: 6),
              ..._ctrl.detailRows.map((row) => _detailRow(row)),
              const SizedBox(height: 10),
              _economicConditionsCard(),
              const SizedBox(height: 10),
              _easyBanner(),
              const SizedBox(height: 16),
            ],
          ),
          // Fixed bottom button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _bottomButton(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.chevron_left, color: AppColors.textDark, size: 28),
        ),
      ),
      title: const Text(
        'Offer Details',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OfferInfoScreen()),
          ),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textLight, width: 1.5),
            ),
            child: const Icon(Icons.info_outline, color: AppColors.textDark, size: 18),
          ),
        ),
      ],
    );
  }

  // ── Supplier Card ──
  Widget _supplierCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A0A4C), Color(0xFF3A1F8C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_ctrl.supplierName,
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(_ctrl.planName,
                    style:
                    const TextStyle(color: AppColors.textMid, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _ctrl.badge,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ── Savings Hero Card ──
  Widget _savingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B2FB9), Color(0xFF7B5FE9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text(
            'MAXIMUM POTENTIAL BENEFIT',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _ctrl.savingsAmount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _ctrl.savingsLabel,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Detail Row ──
  Widget _detailRow(OfferDetailRow row) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Text(
                      row.label,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward,
                        size: 13, color: AppColors.textLight),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Value
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      row.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                    if (row.linkText != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        row.linkText!,
                        style: TextStyle(
                          color: row.linkColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.divider, height: 1),
      ],
    );
  }

  // ── Economic Conditions Card ──
  Widget _economicConditionsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.description_outlined,
                color: AppColors.purple, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Economic conditions',
              style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight, size: 22),
        ],
      ),
    );
  }

  // ── Easy Saving Banner ──
  Widget _easyBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.star_outline, color: AppColors.textMid, size: 17),
          SizedBox(width: 8),
          Text(
            'Attivazione con Easy Saving',
            style: TextStyle(
                color: AppColors.textMid,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ── Fixed Bottom Button ──
  Widget _bottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
      decoration: BoxDecoration(
        color: AppColors.bg,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _ctrl.selectOffer,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: const Text(
            'Select this Offer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 2 – OFFER INFO
// ─────────────────────────────────────────────
class OfferInfoScreen extends StatefulWidget {
  const OfferInfoScreen({super.key});

  @override
  State<OfferInfoScreen> createState() => _OfferInfoScreenState();
}

class _OfferInfoScreenState extends State<OfferInfoScreen> {
  final Set<int> _expandedFAQ = {};

  static const _features = [
    (
    '100% renewable energy',
    'Carbon-neutral electricity sourced from wind and solar farms.'
    ),
    (
    'No hidden fees',
    'Transparent billing with zero unexpected administrative charges.'
    ),
    (
    'Fixed price guarantee',
    'Your energy rate is locked in for the entire contract term.'
    ),
    (
    '24/7 customer support',
    'Access to expert energy concierge services at any time.'
    ),
  ];

  static const _faqs = [
    ('How does the switching process work?',
    'We handle the full switch on your behalf. Once you sign, we coordinate with your current and new supplier.'),
    ('Will my service be interrupted?',
    'No. Your service continues uninterrupted throughout the switching process.'),
    ('What if I\'m still under contract?',
    'We check for exit fees and let you know before proceeding. Some suppliers waive fees in certain situations.'),
    ('How long does it take to receive my contract?',
    'Your contract is typically ready within 24 hours of completing your request.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          _whatsIncludedCard(),
          const SizedBox(height: 20),
          _aboutCard(),
          const SizedBox(height: 20),
          _faqSection(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.chevron_left, color: AppColors.textDark, size: 28),
        ),
      ),
      title: const Text(
        'Offer Info',
        style: TextStyle(
            color: AppColors.textDark, fontSize: 17, fontWeight: FontWeight.w700),
      ),
    );
  }

  // ── What's Included ──
  Widget _whatsIncludedCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's Included",
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          ..._features.map((f) => _featureItem(f.$1, f.$2)),
        ],
      ),
    );
  }

  Widget _featureItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle,
                color: AppColors.green, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textMid,
                        fontSize: 12,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── About EnergyPlus ──
  Widget _aboutCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About EnergyPlus',
          style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'EnergyPlus is a trusted energy provider committed to delivering reliable service and competitive rates. They specialize in renewable energy solutions and have a proven track record of customer satisfaction.',
            style: TextStyle(
              color: AppColors.textMid,
              fontSize: 13,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }

  // ── FAQ Section ──
  Widget _faqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: List.generate(_faqs.length, (i) {
              final isExpanded = _expandedFAQ.contains(i);
              final isLast = i == _faqs.length - 1;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      if (isExpanded) {
                        _expandedFAQ.remove(i);
                      } else {
                        _expandedFAQ.add(i);
                      }
                    }),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _faqs[i].$1,
                              style: const TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(Icons.keyboard_arrow_down,
                                color: AppColors.textLight, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Text(
                        _faqs[i].$2,
                        style: const TextStyle(
                            color: AppColors.textMid,
                            fontSize: 12,
                            height: 1.55),
                      ),
                    ),
                  if (!isLast)
                    const Divider(
                        color: AppColors.divider, height: 1, indent: 16, endIndent: 16),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}