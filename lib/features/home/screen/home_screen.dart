import 'package:vyzi/core/navbar/nav_helper.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/features/home/controller/home_controller.dart';
import 'package:vyzi/features/home/widgets/action_section.dart';
import 'package:vyzi/features/home/widgets/home_header.dart';
import 'package:vyzi/features/home/widgets/how_it_works.dart';
import 'package:vyzi/features/home/widgets/summary_card.dart';
import 'package:vyzi/features/home/widgets/upload_section.dart';
import 'package:vyzi/features/home/widgets/utilities_section.dart';
import 'package:vyzi/features/utility/select_utility_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () {
          final showOnboarding = controller.isFirstVisit.value;
          final hasUtilities = controller.serviceList.isNotEmpty;

          return CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────────────────
              if (showOnboarding)
                SliverToBoxAdapter(
                  child: HomeHeader(isOnboarding: true),
                )
              else
                _buildCollapsibleHeader(context),

              // ── Content ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 100.h),
                  child: Column(
                    children: [
                      if (showOnboarding) ...[
                        UploadSection(
                          onTap: () {
                            NavHelper.push(const SelectUtilityScreen());
                          },
                        ),
                        SizedBox(height: 16.h),
                        _buildSummaryRow(),
                        SizedBox(height: 20.h),
                        HowItWorksCard(),
                      ],
                      if (!showOnboarding) ...[
                        _buildSummaryRow(),
                        SizedBox(height: 18.h),
                        if (hasUtilities) ...[
                          UtilitiesSection(
                            services: controller.serviceList,
                          ),
                          SizedBox(height: 18.h),
                        ],
                        ActionSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Collapsible regular header ──────────────────────────────────────────
  Widget _buildCollapsibleHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 163.h,
      toolbarHeight: 80.h,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF8BA4C4),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final topPadding = MediaQuery.of(context).padding.top;
          final maxHeight = 163.h + topPadding;
          final minHeight = 80.h + topPadding;
          final t = ((constraints.maxHeight - minHeight) /
                  (maxHeight - minHeight))
              .clamp(0.0, 1.0);

          return Container(
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
                              SizedBox(height: 4.h * t),
                              AnimatedOpacity(
                                opacity: t,
                                duration: const Duration(milliseconds: 100),
                                child: Text(
                                  'home.header.subtitle'.tr,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Colors.white.withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          AppAssets.notification,
                          width: (24 + 8 * t).w,
                          height: (24 + 8 * t).h,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Summary cards row (shared by both layouts) ──────────────────────────
  Widget _buildSummaryRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SummaryCard(
              icon: Image.asset(AppAssets.down),
              iconColor: AppColors.green200,
              iconBgColor: AppColors.greenAlpha10,
              title: 'home.summary.savings_title'.tr,
              value: controller.savingAmount.value,
              valueColor: AppColors.green200,
              subtitle: 'home.summary.savings_subtitle'.tr,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SummaryCard(
              icon: Image.asset(AppAssets.cir),
              iconColor: AppColors.primaryColor,
              iconBgColor: AppColors.primaryAlpha10,
              title: 'home.summary.utilities_title'.tr,
              value: controller.activeUtilities.value
                  .toString()
                  .padLeft(2, '0'),
              valueColor: AppColors.primaryColor,
              subtitle: 'home.summary.utilities_subtitle'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
