import 'dart:ui';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/my_utility/my_utiliets.dart';
import 'package:flutter/material.dart';



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
      backgroundColor: AppColors.background,
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
      // bottomNavigationBar: _downloadBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.chevron_left, color: Colors.black, size: 28),
        ),
      ),
      title: const Text('Dettagli Utenza',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700)),
    );
  }

  // ── Hero Card ──
  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF0E0437),
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
                  color:  Color(0xFF40DEB0).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary50.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.circle, color: Color(0xFF40DEB0), size: 7),
                    SizedBox(width: 5),
                    Text('OFFERTA ATTIVA',
                        style: TextStyle(
                            color: Color(0xFF40DEB0),
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
              const Text('Fornitura Elettrica Business',
                  style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 18),
              Row(
                children: [
                  _heroStat('PREZZO MATERIA', '0.124 €/kWh', valueColor: const Color(0xFF40DEB0)),
                  const SizedBox(width: 32),
                  _heroStat('ATTIVAZIONE', '12 Mag 2023'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String label, String value, {Color? valueColor}) {
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
            style: TextStyle(
                color: valueColor ?? AppColors.primary50,
                fontSize: 14,
                fontWeight: FontWeight.w800)),
      ],
    );
  }

  // ── Active Offer Card ──
  Widget _activeOfferCard() {
    return _infoCard(
      title: 'Offerta Attiva',
      rows: const [
        ('Nome Offerta', 'Piano a Tariffa Fissa'),
        ('Tipo di Servizio', 'Gas'),
      ],
    );
  }

  // ── Supply Info Card ──
  Widget _supplyInfoCard() {
    return _infoCard(
      title: 'Informazioni di Fornitura',
      rows: const [
        ('Numero Contatore', 'MTR-XCFAQBT18'),
        ('Punto di Fornitura', 'SP-AMXQLAF7H99'),
      ],
    );
  }

  Widget _infoCard(
      {required String title, required List<(String, String)> rows}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary50, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.black,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style:
                  const TextStyle(color: Colors.black, fontSize: 13)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.black12,
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
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700));
  }

  // ── Contact Card ──
  Widget _contactCard() {
    final contacts = [
      (Icons.chat_bubble_outline, AppColors.primary50, const Color(0xFFEEEAFB),
      'Invia Messaggio', 'Ottieni aiuto tramite il modulo di supporto'),
      (Icons.call_outlined, AppColors.primary50, const Color(0xFFE6FBF5), 'Chiamaci',
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
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
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                Text(c.$5,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 12)),
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
    return Column(
      children: List.generate(_faqs.length, (i) {
        final isExpanded = _expandedFAQ.contains(i);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E8E8)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
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
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.4)),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.black,
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
                          color: Colors.black,
                          fontSize: 12,
                          height: 1.55)),
                ),
            ],
          ),
        );
      }),
    );
  }

  // // ── Download Bar ──
  // Widget _downloadBar() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
  //     decoration: BoxDecoration(
  //       color: AppColors.background,
  //       boxShadow: [
  //         BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 10,
  //             offset: const Offset(0, -3)),
  //       ],
  //     ),
  //     child: SizedBox(
  //       width: double.infinity,
  //       height: 52,
  //       child: OutlinedButton.icon(
  //         onPressed: () {},
  //         icon: const Icon(Icons.download_outlined, size: 18),
  //         label: const Text('Download Contract',
  //             style:
  //             TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
  //         style: OutlinedButton.styleFrom(
  //           foregroundColor: Colors.black,
  //           side: const BorderSide(color: Colors.black, width: 1.5),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(14)),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}