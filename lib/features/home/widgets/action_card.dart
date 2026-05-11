import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isHighlighted; // dark bg icon variant
  final bool showBadge;     // "Nuovo" badge
  final String? badgeText;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
    this.isHighlighted = false,
    this.showBadge = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isHighlighted
                ? color.withOpacity(0.35)
                : Color(0xFFE8E8E8),
            width: isHighlighted ? 1.5 : 1.0,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Left Icon 56×56 ──
                Container(
                  height: 56.h,
                  width: 56.w,
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ?  Color(0xFF1A1A2E) // dark bg
                        : color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    icon,
                    color: isHighlighted ? Colors.white : color,
                    size: 26.sp,
                  ),
                ),

                SizedBox(width: 14.w),

                // ── Title + Subtitle ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // ── Right Chevron 24×24 ──
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 24.sp,
                  ),
                ),
              ],
            ),

            // ── "Nuovo" Badge (top-right of card) ──
            if (showBadge)
              Positioned(
                top: -20.h,
                right: -6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C896),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    badgeText ?? 'Nuovo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}