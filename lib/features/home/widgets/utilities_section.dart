
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:get/get.dart';

import 'package:vyzi/core/utils/app_colors.dart';
import 'single_utility_card.dart';

class UtilitiesSection extends StatelessWidget {
  final RxList<Map<String, dynamic>> utilities;

  const UtilitiesSection({
    super.key,
    required this.utilities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Le tue Utenze",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                "Visualizza Tutto",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: utilities.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, index) {
              final item = utilities[index];

              return UtilityCard(
                title: item['title'],
                subtitle: item['subtitle'],
                price: item['price'],
                onTap: () {
                  // Handle utility card tap
                  print("Utility tapped: ${item['title']}");
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
