import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// ENTRY POINT (for testing)
// ─────────────────────────────────────────────
void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'SF Pro Display'),
      home: const MyUtilitiesScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────
class UtilityModel {
  final String name;
  final String type;
  final double monthlyPrice;
  final String offerType;
  final String activeSince;

  const UtilityModel({
    required this.name,
    required this.type,
    required this.monthlyPrice,
    required this.offerType,
    required this.activeSince,
  });
}

// ─────────────────────────────────────────────
// SHARED DESIGN TOKENS
// ─────────────────────────────────────────────
class _T {
  static const purple = Color(0xFF5B3FD9);
  static const purpleDark = Color(0xFF1A0A4C);
  static const purpleLight = Color(0xFFEEEAFB);
  static const green = Color(0xFF00C896);
  static const greenBg = Color(0xFFE6FBF5);
  static const bg = Color(0xFFF7F8FC);
  static const cardBg = Colors.white;
  static const textDark = Color(0xFF1A1A2E);
  static const textMid = Color(0xFF636E72);
  static const textLight = Color(0xFFB2BEC3);
  static const divider = Color(0xFFF0F0F5);
  static const darkCard = Color(0xFF12083A);
}

// ─────────────────────────────────────────────
// SCREEN 1 – MY UTILITIES
// ─────────────────────────────────────────────
class MyUtilitiesScreen extends StatelessWidget {
  const MyUtilitiesScreen({super.key});

  static final _utilities = [
    const UtilityModel(
      name: 'EnergyPlus',
      type: 'Gas',
      monthlyPrice: 89.99,
      offerType: 'Fixed Rate Plan',
      activeSince: '26/03/2026',
    ),
    const UtilityModel(
      name: 'EnergyPlus',
      type: 'Gas',
      monthlyPrice: 89.99,
      offerType: 'Fixed Rate Plan',
      activeSince: '26/03/2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _T.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                children: [
                  ..._utilities.map((u) => _UtilityTile(utility: u)),
                  const SizedBox(height: 16),
                  _saveBanner(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 20, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Utilities',
              style: TextStyle(
                  color: _T.textDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4)),
          SizedBox(height: 4),
          Text('Manage your active utility services',
              style: TextStyle(color: _T.textMid, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _saveBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: _T.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Background bolt decoration
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(Icons.bolt,
                size: 110, color: Colors.white.withOpacity(0.05)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Save on your next bill',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text(
                'We analyze your consumption to\nfind better rates every month.',
                style: TextStyle(
                    color: Colors.white60, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  decoration: BoxDecoration(
                    color: _T.green,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text('Upload Bill',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Utility Tile ──
class _UtilityTile extends StatelessWidget {
  final UtilityModel utility;
  const _UtilityTile({required this.utility});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UtilityDetailsScreen(utility: utility),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _T.cardBg,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1A0A4C), Color(0xFF3A1F8C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(width: 12),
                // Name + type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(utility.name,
                          style: const TextStyle(
                              color: _T.textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(utility.type,
                          style: const TextStyle(
                              color: _T.textMid, fontSize: 12)),
                    ],
                  ),
                ),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${utility.monthlyPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: _T.textDark,
                            fontSize: 17,
                            fontWeight: FontWeight.w800)),
                    const Text('per month',
                        style: TextStyle(color: _T.textLight, fontSize: 11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: _T.divider, height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _meta('Offer Type', utility.offerType),
                _meta('Active Since', utility.activeSince,
                    align: CrossAxisAlignment.end),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _meta(String label, String value,
      {CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label,
            style: const TextStyle(color: _T.textLight, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: _T.textMid, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 2 – UTILITY DETAILS
// ─────────────────────────────────────────────
class UtilityDetailsScreen extends StatefulWidget {
  final UtilityModel utility;
  const UtilityDetailsScreen({super.key, required this.utility});

  @override
  State<UtilityDetailsScreen> createState() => _UtilityDetailsScreenState();
}

class _UtilityDetailsScreenState extends State<UtilityDetailsScreen> {
  final Set<int> _expandedFAQ = {};

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
      backgroundColor: _T.bg,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          _heroCard(),
          const SizedBox(height: 14),
          _activeOfferCard(),
          const SizedBox(height: 14),
          _supplyInfoCard(),
          const SizedBox(height: 20),
          _sectionTitle('Contact Support'),
          const SizedBox(height: 10),
          _contactCard(),
          const SizedBox(height: 20),
          _sectionTitle('Frequently Asked Questions'),
          const SizedBox(height: 10),
          _faqCard(),
          const SizedBox(height: 30),
        ],
      ),
      bottomNavigationBar: _downloadBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _T.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.chevron_left, color: _T.textDark, size: 28),
        ),
      ),
      title: const Text('Utility Details',
          style: TextStyle(
              color: _T.textDark, fontSize: 17, fontWeight: FontWeight.w700)),
    );
  }

  // ── Hero Card ──
  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _T.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            top: -16,
            child: Icon(Icons.bolt,
                size: 120, color: Colors.white.withOpacity(0.07)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _T.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _T.green.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.circle, color: _T.green, size: 7),
                    SizedBox(width: 5),
                    Text('ACTIVE OFFER',
                        style: TextStyle(
                            color: _T.green,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text('Next e-Business\nSunlight',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.3)),
              const SizedBox(height: 6),
              const Text('Business Electricity Supply',
                  style: TextStyle(color: _T.green, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 18),
              Row(
                children: [
                  _heroStat('MATERIAL PRICE', '0.124 €/kWh'),
                  const SizedBox(width: 32),
                  _heroStat('ACTIVATION', '12 Mag 2023'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: _T.green,
                fontSize: 14,
                fontWeight: FontWeight.w800)),
      ],
    );
  }

  // ── Active Offer Card ──
  Widget _activeOfferCard() {
    return _infoCard(
      title: 'Active Offer',
      rows: const [
        ('Offer Name', 'Fixed Rate Plan'),
        ('Service Type', 'Gas'),
      ],
    );
  }

  // ── Supply Info Card ──
  Widget _supplyInfoCard() {
    return _infoCard(
      title: 'Supply Information',
      rows: const [
        ('Meter Number', 'MTR-XCFAQBT18'),
        ('Supply Point', 'SP-AMXQLAF7H99'),
      ],
    );
  }

  Widget _infoCard(
      {required String title, required List<(String, String)> rows}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: _T.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _T.divider, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: _T.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...rows.map((r) => _infoRow(r.$1, r.$2)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(
      children: [
        const Divider(color: _T.divider, height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style:
                  const TextStyle(color: _T.textMid, fontSize: 13)),
              Text(value,
                  style: const TextStyle(
                      color: _T.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            color: _T.textDark, fontSize: 15, fontWeight: FontWeight.w700));
  }

  // ── Contact Card ──
  Widget _contactCard() {
    final contacts = [
      (Icons.chat_bubble_outline, _T.purple, const Color(0xFFEEEAFB),
      'Send Message', 'Get help via support form'),
      (Icons.call_outlined, _T.green, const Color(0xFFE6FBF5), 'Call Us',
      '1-800-UTILITY'),
      (Icons.mail_outline, const Color(0xFFE67E22), const Color(0xFFFEF3E8),
      'Email', 'support@utility.com'),
    ];

    return Column(
      children: contacts
          .map((c) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _T.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: c.$3,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(c.$1, color: c.$2, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.$4,
                    style: const TextStyle(
                        color: _T.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                Text(c.$5,
                    style: const TextStyle(
                        color: _T.textMid, fontSize: 12)),
              ],
            ),
          ],
        ),
      ))
          .toList(),
    );
  }

  // ── FAQ Card ──
  Widget _faqCard() {
    return Container(
      decoration: BoxDecoration(
        color: _T.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
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
                      horizontal: 16, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(_faqs[i].$1,
                            style: const TextStyle(
                                color: _T.textDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.4)),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: _T.textLight,
                          size: 20),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Text(_faqs[i].$2,
                      style: const TextStyle(
                          color: _T.textMid,
                          fontSize: 12,
                          height: 1.55)),
                ),
              if (!isLast) const Divider(color: _T.divider, height: 1),
            ],
          );
        }),
      ),
    );
  }

  // ── Download Bar ──
  Widget _downloadBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
      decoration: BoxDecoration(
        color: _T.cardBg,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_outlined, size: 18),
          label: const Text('Download Contract',
              style:
              TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          style: OutlinedButton.styleFrom(
            foregroundColor: _T.purple,
            side: const BorderSide(color: _T.purple, width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
}