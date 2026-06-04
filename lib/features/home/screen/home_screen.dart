import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/home/controller/home_controller.dart';
import 'package:vyzi/features/home/widgets/action_section.dart';
import 'package:vyzi/features/home/widgets/home_header.dart';
import 'package:vyzi/features/home/widgets/how_it_works.dart';
import 'package:vyzi/features/home/widgets/summary_card.dart';
import 'package:vyzi/features/home/widgets/upload_section.dart';
import 'package:vyzi/features/home/widgets/utilities_section.dart';
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
            () => SingleChildScrollView(
          child: Column(
            children: [
              const HomeHeader(),

              SizedBox(height: 18.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    /// IF NO DATA
                    if (!controller.hasData.value) ...[
                      UploadSection(
                        onTap: () {
                          controller.startSavingFlow();
                        },
                      ),

                      SizedBox(height: 16.h),

                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: SummaryCard(
                                icon: Image.asset(
                                  AppAssets.down,
                                ),
                                iconColor: AppColors.green200,
                                iconBgColor: AppColors.greenAlpha10,
                                title: "Risparmi\nPotenziali",
                                value: "€128,50",
                                valueColor: AppColors.green200,
                                subtitle: "all'anno",
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: SummaryCard(
                                icon: Image.asset(
                                  AppAssets.cir,
                                ),
                                iconColor: AppColors.primaryColor,
                                iconBgColor: AppColors.primaryAlpha10,
                                title: "Richiesta Attiva",
                                value: "00",
                                valueColor: AppColors.primaryColor,
                                subtitle: "in corso",
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      const HowItWorksCard(),
                    ],

                    /// IF DATA AVAILABLE
                    if (controller.hasData.value) ...[
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: SummaryCard(
                                icon: Image.asset(
                                  AppAssets.down,
                                ),
                                iconColor: AppColors.green200,
                                iconBgColor: AppColors.greenAlpha10,
                                title: "Risparmi\nPotenziali",
                                value: "€128,50",
                                valueColor: AppColors.green200,
                                subtitle: "all'anno",
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: SummaryCard(
                                icon: Image.asset(
                                  AppAssets.cir,
                                ),
                                iconColor: AppColors.primaryColor,
                                iconBgColor: AppColors.primaryAlpha10,
                                title: "Richiesta Attiva",
                                value: "00",
                                valueColor: AppColors.primaryColor,
                                subtitle: "in corso",
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 18.h),

                      UtilitiesSection(
                        utilities: controller.utilityList,
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
        ),
      ),
    );
  }
}
