import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';

class UtilityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const UtilityCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(14.r),
          // border: Border.all(color: const Color(0xFFD2D2D2), width: 1),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 44.h,
              width: 44.w,
              child: Image.asset(
                AppAssets.circle,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.body1.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  subtitle,
                  style: AppStyles.body3.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Spacer(),

          ],
        ),
      ),
    );
  }
}
