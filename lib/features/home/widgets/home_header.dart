import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vyzi/core/services/storage_service.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';

class HomeHeader extends StatelessWidget {
  final bool isOnboarding;

  const HomeHeader({super.key, this.isOnboarding = false});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return isOnboarding
        ? _buildOnboardingHeader(topPadding)
        : _buildRegularHeader(topPadding);
  }

  Widget _buildRegularHeader(double topPadding) {
    final storage = Get.find<StorageService>();
    final userName = storage.getString(StorageKeys.userName) ?? '';

    return Container(
      height: 163.h + topPadding,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeRegularBg),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'home.header.greeting'.trParams({'name': userName}),
                          style: AppStyles.h1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'home.header.subtitle'.tr,
                          style: AppStyles.body2.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    AppAssets.notification,
                    width: 28.w,
                    height: 28.h,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingHeader(double topPadding) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ClipRect(
        child: Stack(
          children: [
            // Decorative semi-transparent circle on the right
            Positioned(
              right: -40.w,
              top: -20.h,
              child: Container(
                width: 220.w,
                height: 220.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryColor.withValues(alpha: 0.25),
                ),
              ),
            ),
            // Content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo + Notification row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo container
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.r),
                            child: Image.asset(
                              AppAssets.homeLogo,
                              width: 48.w,
                              height: 48.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Notification with badge
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                AppAssets.notification,
                                width: 26.w,
                                height: 26.h,
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: Container(
                                  width: 16.w,
                                  height: 16.w,
                                  decoration: const BoxDecoration(
                                    color: AppColors.red100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Greeting
                    Text(
                      'home.header.onboarding_greeting'.tr,
                      style: AppStyles.h1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 26.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Subtitle
                    Text(
                      'home.header.onboarding_subtitle'.tr,
                      style: AppStyles.body2.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
