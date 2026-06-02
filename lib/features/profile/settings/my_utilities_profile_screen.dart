import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyUtilitiesProfileScreen extends StatelessWidget {
  const MyUtilitiesProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Text(
                'My Utilities',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Manage your active utility services',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),

              // ── Empty State Card ──
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ── Image fills top of card ──
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=600&q=80',
                        width: double.infinity,
                        height: 180.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: double.infinity,
                          height: 180.h,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.bolt_rounded,
                              size: 48.sp,
                              color: AppColors.primaryColor.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── Text + Button ──
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 24.h),
                      child: Column(
                        children: [
                          Text(
                            'No Active Utilities',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                              height: 1.22,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Once you complete a switch,\nyour utilities will appear here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF9E9E9E),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: 140.w,
                            height: 44.h,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Start Saving',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}