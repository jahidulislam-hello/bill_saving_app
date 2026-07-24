import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:vyzi/features/profile/settings/controller/static_page_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  static const _purpleBg = Color(0xFFEEECFB);
  static const _textDark = Color(0xFF1A1A2E);
  static const _bg = Colors.white;

  final StaticPageController _controller = Get.put(
    StaticPageController(slug: 'privacy-policy'),
    tag: 'privacy-policy',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10 + MediaQuery.of(context).padding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _illustrationCard(),
            const SizedBox(height: 28),
            Obx(() {
              if (_controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (_controller.notFound.value) {
                return _buildNotFoundState();
              }

              if (_controller.error.value.isNotEmpty) {
                return _buildErrorState();
              }

              final page = _controller.page.value;
              if (page == null) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.title,
                    style: const TextStyle(
                      color: _textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Html(
                    data: page.content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(13),
                        lineHeight: LineHeight(1.65),
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, color: _textDark, size: 28),
        ),
      ),
      title: Text(
        'profile.settings.privacy'.tr,
        style: const TextStyle(
          color: _textDark,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _illustrationCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: _purpleBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
      ),
      child: Center(
        child: SizedBox(
          width: 180,
          height: 160,
          child: CustomPaint(
            painter: _PrivacyIllustrationPainter(),
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'static_page.not_available'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'static_page.error'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _controller.fetchPage(),
              child: Text('static_page.retry'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyIllustrationPainter extends CustomPainter {
  static const _purple = Color(0xFF6C5CE7);
  static const _purpleLight = Color(0xFFB8B0F5);
  static const _purpleFill = Color(0xFFD9D5F8);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 - 10;

    _drawShield(canvas, cx, cy, 70, _purple, _purpleFill);
    _drawShield(canvas, cx, cy - 2, 50, _purpleLight, Colors.white.withOpacity(0.5));

    final lockPaint = Paint()
      ..color = _purple
      ..style = PaintingStyle.fill;
    final lockStroke = Paint()
      ..color = _purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final shacklePath = Path();
    shacklePath.addArc(
      Rect.fromCenter(center: Offset(cx, cy - 8), width: 20, height: 20),
      3.14159,
      3.14159,
    );
    canvas.drawPath(shacklePath, lockStroke);

    final lockRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 4), width: 26, height: 20),
      const Radius.circular(5),
    );
    canvas.drawRRect(lockRect, lockPaint);

    canvas.drawCircle(Offset(cx, cy + 2), 4, Paint()..color = Colors.white);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy + 7.5), width: 3, height: 5),
      Paint()..color = Colors.white,
    );

    _drawPlant(canvas, cx - 58, cy + 45);
    _drawDevice(canvas, cx + 55, cy + 40);
    _drawWifi(canvas, cx + 52, cy - 20);
  }

  void _drawShield(Canvas canvas, double cx, double cy, double r,
      Color strokeColor, Color fillColor) {
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final path = _shieldPath(cx, cy, r);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, stroke);
  }

  Path _shieldPath(double cx, double cy, double r) {
    final path = Path();
    final top = cy - r * 0.9;
    final bottom = cy + r * 1.0;
    final left = cx - r * 0.75;
    final right = cx + r * 0.75;
    final midY = cy + r * 0.1;

    path.moveTo(cx, top);
    path.cubicTo(cx + r * 0.1, top, right, top + r * 0.15, right, midY);
    path.cubicTo(right, midY + r * 0.5, cx + r * 0.3, bottom - r * 0.15, cx, bottom);
    path.cubicTo(cx - r * 0.3, bottom - r * 0.15, left, midY + r * 0.5, left, midY);
    path.cubicTo(left, top + r * 0.15, cx - r * 0.1, top, cx, top);
    path.close();
    return path;
  }

  void _drawPlant(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..color = const Color(0xFF6C5CE7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(x, y), Offset(x, y - 24), paint);
    final leftLeaf = Path()
      ..moveTo(x, y - 10)
      ..cubicTo(x - 18, y - 18, x - 20, y - 30, x - 8, y - 28)
      ..cubicTo(x - 4, y - 27, x, y - 18, x, y - 10);
    canvas.drawPath(leftLeaf, paint);
    final rightLeaf = Path()
      ..moveTo(x, y - 16)
      ..cubicTo(x + 14, y - 20, x + 16, y - 30, x + 6, y - 28)
      ..cubicTo(x + 2, y - 27, x, y - 22, x, y - 16);
    canvas.drawPath(rightLeaf, paint);

    final potPaint = Paint()
      ..color = const Color(0xFF6C5CE7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    final pot = Path()
      ..moveTo(x - 10, y)
      ..lineTo(x - 7, y + 12)
      ..lineTo(x + 7, y + 12)
      ..lineTo(x + 10, y);
    canvas.drawPath(pot, potPaint);
    canvas.drawLine(Offset(x - 12, y), Offset(x + 12, y), potPaint);
  }

  void _drawDevice(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..color = const Color(0xFF6C5CE7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final box = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(x, y - 8), width: 22, height: 28),
      const Radius.circular(4),
    );
    canvas.drawRRect(box, paint);

    canvas.drawCircle(Offset(x, y - 10), 6, paint);
    canvas.drawCircle(Offset(x, y - 10), 2.5, paint);

    canvas.drawCircle(Offset(x, y + 4), 1.5, Paint()..color = const Color(0xFF6C5CE7));
  }

  void _drawWifi(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..color = const Color(0xFF6C5CE7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final r = 6.0 + i * 6.0;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(x, y + 4), width: r * 2, height: r * 2),
        -2.4,
        1.4,
        false,
        paint,
      );
    }
    canvas.drawCircle(Offset(x, y + 4), 1.8, Paint()..color = const Color(0xFF6C5CE7));
  }

  @override
  bool shouldRepaint(_PrivacyIllustrationPainter old) => false;
}
