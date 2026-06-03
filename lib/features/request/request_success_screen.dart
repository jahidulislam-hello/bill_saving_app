import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestSuccessScreen extends StatelessWidget {
  const RequestSuccessScreen({super.key});

  static const _purple = Color(0xFF5A1ABE);
  static const _textDark = Colors.black;
  static const _textGrey = Colors.black;
  static const _cardBg = Color(0xFFF4F5FB);
  static const _infoBg = Color(0xFFEFF2FF);
  static const _infoBorder = Color(0xFF5A1ABE);
  static const _bg = Colors.white;
  static const _iconGrey = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 52),
              _badgeIcon(),
              const SizedBox(height: 28),
              const Text(
                'Richiesta Inviata con Successo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Abbiamo ricevuto la tua richiesta di\nattivazione.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textGrey,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
              _whatHappensCard(),
              const SizedBox(height: 14),
              _infoBox(),
              const Spacer(),
              _viewButton(context),
              const SizedBox(height: 14),
              _backButton(context),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  // ── Badge Icon ──
  Widget _badgeIcon() {
    return SizedBox(
      width: 110,
      height: 110,
      child: CustomPaint(
        painter: _BadgePainter(color: _purple),
        child: const Center(
          child: Icon(Icons.check, color: Colors.white, size: 44),
        ),
      ),
    );
  }

  // ── What Happens Now Card ──
  Widget _whatHappensCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _infoBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cosa succede ora',
            style: TextStyle(
              color: _textDark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _stepItem(
            icon: Icons.fact_check_outlined,
            title: 'Verifichiamo i dati inseriti',
            subtitle: 'I nostri sistemi automatizzati verificano l\'accuratezza delle tue informazioni.',
          ),
          _stepItem(
            icon: Icons.handshake_outlined,
            title: 'Prepariamo la pratica',
            subtitle: 'Ci coordiniamo con i fornitori di servizi per avviare la tua richiesta.',
          ),
          _stepItem(
            icon: Icons.description_outlined,
            title: 'Il contratto sarà disponibile entro 24 ore',
            subtitle: 'La tua documentazione sarà generata e inviata per la firma.',
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _stepItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool last = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 8 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _infoBorder, width: 1),
            ),
            child: Icon(icon, color: _iconGrey, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _textGrey,
                    fontSize: 12,
                    height: 1.45,
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

  // ── Info Box ──
  Widget _infoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _infoBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _infoBorder, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _infoBorder),
            ),
            child: const Icon(Icons.info_outline, color: _purple, size: 17),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Come completerai la richiesta?',
                  style: TextStyle(
                    color: _textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Riceverai le istruzioni per firmare il contratto via SMS, email o link dedicato, in base al fornitore scelto.',
                  style: TextStyle(
                    color: _textGrey,
                    fontSize: 12,
                    height: 1.45,
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

  // ── Buttons ──
  Widget _viewButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to requests tab or details
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: const Text(
          'Visualizza la Mia Richiesta',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: TextButton(
        onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
        style: TextButton.styleFrom(
          foregroundColor: _textDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text(
          'Torna alla Home',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Custom Badge / Seal Shape Painter
// ─────────────────────────────────────────────
class _BadgePainter extends CustomPainter {
  final Color color;
  const _BadgePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2;
    final innerR = outerR * 0.78;
    const points = 16;
    final angleStep = (math.pi * 2) / points;

    final path = Path();
    for (int i = 0; i < points; i++) {
      final outerAngle = i * angleStep - math.pi / 2;
      final innerAngle = outerAngle + angleStep / 2;
      final ox = cx + outerR * _cos(outerAngle);
      final oy = cy + outerR * _sin(outerAngle);
      final ix = cx + innerR * _cos(innerAngle);
      final iy = cy + innerR * _sin(innerAngle);
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double a) => math.cos(a);
  double _sin(double a) => math.sin(a);

  @override
  bool shouldRepaint(_BadgePainter old) => old.color != color;
}
