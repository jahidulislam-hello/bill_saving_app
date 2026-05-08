
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UtilityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback? onTap;

  const UtilityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              height: 44.h,
              width: 44.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Icon(
                Icons.bolt,
                color: Colors.amber,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              price,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}