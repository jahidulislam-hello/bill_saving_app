import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/dumb/my_utility_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vyzi/features/my_utility/utility_details_screen.dart';



class UtilityModel {
  final String name;
  final String type;
  final String monthID;
  final String offerType;
  final String activeSince;

  const UtilityModel({
    required this.name,
    required this.type,
    required this.monthID,
    required this.offerType,
    required this.activeSince,
  });
}




class MyUtilitiesScreen extends StatelessWidget {
  const MyUtilitiesScreen({super.key});

  static final _utilities = [
    const UtilityModel(
      name: 'EnergyPlus',
      type: 'Gas',
      monthID: 'IT001EXXXXXXXXX',
      offerType: 'Piano a Tariffa Fissa',
      activeSince: '26/03/2026',
    ),
    const UtilityModel(
      name: 'EnergyPlus',
      type: 'Gas',
      monthID: 'IT001EXXXXXXXXX',
      offerType: 'Piano a Tariffa Fissa',
      activeSince: '26/03/2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
          Text('Le Mie Utenze',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4)),
          SizedBox(height: 4),
          Text('Gestisci i tuoi servizi attivi',
              style: TextStyle(color: Colors.black, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _saveBanner() {
    return Container(
      width: double.infinity,
      height: 192.h,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: Color(0xFF001C13),
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
              const Text('Risparmia sulla tua prossima bolletta',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text(
                'Analizziamo i tuoi consumi per\ntrovare tariffe migliori ogni mese.',
                style: TextStyle(
                    color: Colors.white60, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  decoration: BoxDecoration(
                    color: Color(0xFF64FBCB),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text('Carica Bolletta',
                      style: TextStyle(
                          color: Colors.black,
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
          builder: (_) => UtilityDetailsScreen(),
        ),
      ),
      child: Container(
        height: 163,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E8E8)),
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
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(utility.type,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12)),
                    ],
                  ),
                ),
                // Active Since (Moved to Row 1)
                _meta('Attivo dal', utility.activeSince,
                    align: CrossAxisAlignment.end),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE8E8E8), height: 1.22),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _meta('Tipo di Offerta', utility.offerType),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('POD',
                        style: TextStyle(color: Colors.black, fontSize: 11)),
                    Text(utility.monthID,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),

                  ],
                ),
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
            style: const TextStyle(color: Colors.black, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

