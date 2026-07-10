import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';

class UtilityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? logoUrl;
  final String? trailingText;
  final VoidCallback? onTap;

  const UtilityCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoUrl,
    this.trailingText,
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
        ),
        child: Row(
          children: [
            SizedBox(
              height: 44.h,
              width: 44.w,
              child: _buildLogo(),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
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
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: AppStyles.body1.copyWith(fontWeight: FontWeight.w800),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          logoUrl!,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Image.asset(
            AppAssets.circle,
            fit: BoxFit.contain,
          ),
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Image.asset(AppAssets.circle, fit: BoxFit.contain);
          },
        ),
      );
    }
    return Image.asset(AppAssets.circle, fit: BoxFit.contain);
  }
}
