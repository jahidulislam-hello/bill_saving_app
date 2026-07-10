import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
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
          final hasUtilities = controller.serviceList.isNotEmpty;

          return SingleChildScrollView(
            child: Column(
              children: [
                const HomeHeader(),

                SizedBox(height: 18.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      /// No utilities → show upload section + summary + how it works
                      if (!hasUtilities) ...[
                        UploadSection(
                          onTap: () {
                            Get.to(() => const SelectUtilityScreen());
                          },
                        ),

                        SizedBox(height: 16.h),

                        IntrinsicHeight(
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
                                  title: 'home.summary.requests_title'.tr,
                                  value: controller.activeRequest.value
                                      .toString()
                                      .padLeft(2, '0'),
                                  valueColor: AppColors.primaryColor,
                                  subtitle: 'home.summary.requests_subtitle'.tr,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        HowItWorksCard(),
                      ],

                      /// Has utilities → show summary + utilities (max 3) + actions
                      if (hasUtilities) ...[
                        IntrinsicHeight(
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
                                  title: 'home.summary.requests_title'.tr,
                                  value: controller.activeRequest.value
                                      .toString()
                                      .padLeft(2, '0'),
                                  valueColor: AppColors.primaryColor,
                                  subtitle: 'home.summary.requests_subtitle'.tr,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 18.h),

                        UtilitiesSection(
                          services: controller.serviceList,
                        ),

                        SizedBox(height: 18.h),

                        ActionSection(),
                      ],

                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
