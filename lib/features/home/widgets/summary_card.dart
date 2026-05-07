import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20.sp,
          ),

          SizedBox(height: 10.h),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13.sp,
            ),
          ),

          SizedBox(height: 12.h),

          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}