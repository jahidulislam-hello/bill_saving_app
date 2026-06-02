import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';

class UploadSection extends StatelessWidget {
  final VoidCallback onTap;

  const UploadSection({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(
        color: AppColors.primaryColor,
        strokeWidth: 1.w,
        dashPattern: [8.w, 8.w],
        borderRadius: 12.r,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.upload,
              width: 48.sp,
              height: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              "Carica la tua Prima\nBolletta",
              textAlign: TextAlign.center,
              style: AppStyles.h2.copyWith(height: 1.2),
            ),
            SizedBox(height: 12.h),
            Text(
              "Lasciaci analizzare il tuo piano\nattuale e trovare offerte migliori",
              textAlign: TextAlign.center,
              style: AppStyles.body2.copyWith(color: Colors.grey, height: 1.4),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 14.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  "Inizia a Risparmiare",
                  style: AppStyles.buttonText.copyWith(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;
  final double borderRadius;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashPattern,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);

    for (PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      int i = 0;
      while (distance < metric.length) {
        final double len = dashPattern[i % dashPattern.length];
        if (draw) {
          canvas.drawPath(
            metric.extractPath(distance, distance + len),
            paint,
          );
        }
        distance += len;
        draw = !draw;
        i++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DottedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}

