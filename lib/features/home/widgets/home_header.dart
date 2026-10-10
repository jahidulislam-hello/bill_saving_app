import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/features/notifications/controller/notification_controller.dart';
import 'package:vyzi/routes/app_routes.dart';

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
    return Container(
      height: 163.h + topPadding,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeRegularBg),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                          'home.header.greeting'.tr,
                          style: AppStyles.h1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'home.header.subtitle'.tr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.notificationsScreen),
                    child: _buildNotificationIcon(26),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(double iconSize) {
    return GetBuilder<NotificationController>(
      init: Get.isRegistered<NotificationController>()
          ? Get.find<NotificationController>()
          : Get.put(NotificationController()),
      builder: (controller) => Obx(() {
        final count = controller.unreadCount.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              AppAssets.notification,
              width: iconSize.w,
              height: iconSize.h,
              fit: BoxFit.contain,
            ),
            if (count > 0)
              Positioned(
                top: 4.h,
                right: 4.w,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: const BoxDecoration(
                    color: AppColors.red100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : '$count',
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
        );
      }),
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
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.notificationsScreen),
                          child: Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: _buildNotificationIcon(26),
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
