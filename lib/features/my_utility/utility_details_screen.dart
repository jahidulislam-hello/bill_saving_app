import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vyzi/features/my_utility/utility_details_controller.dart';
import 'package:vyzi/features/support/support_screen.dart';


class UtilityDetailsScreen extends StatelessWidget {
  UtilityDetailsScreen({super.key});

  final UtilityDetailsController controller =
  Get.put(UtilityDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20.sp,
          ),
        ),
        title: Text(
          'utility.details_title'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            /// TOP CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB300FF),
                    Color(0xFF0AA9FF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Icon(
                      Icons.flash_on,
                      size: 90.sp,
                      color: Colors.white.withOpacity(0.10),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 7.h,
                              width: 7.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00FF84),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'utility.active_offer_badge'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 18.h),

                      Text(
                        "Next e-Business\nSunlight",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        "Business Electricity Supply",
                        style: TextStyle(
                          color: Color(0xFF1FC16B),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 26.h),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'utility.material_price'.tr,
                                  style: TextStyle(
                                    color:
                                    Colors.white.withOpacity(0.85),
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "0.124",
                                        style: TextStyle(
                                          color:
                                          const Color(0xFF00FF84),
                                          fontSize: 32.sp,
                                          fontWeight:
                                          FontWeight.w900,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " \$/kWh",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'utility.activation'.tr,
                                  style: TextStyle(
                                    color:
                                    Colors.white.withOpacity(0.85),
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "12 Mag 2023",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.h),

            /// ACTIVE OFFER
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEFE8F9),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: const Color(0xFFEFE8F9), width: 1.22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('utility.active_offer'.tr),
                  SizedBox(height: 16.h),
                  _infoRow('utility.offer_name'.tr, "fixed Rate Plan"),
                  SizedBox(height: 16.h),
                  _infoRow('utility.service_type'.tr, "Gas"),
                ],
              ),
            ),

            SizedBox(height: 22.h),

            /// SUPPLY INFO
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.location,
                        color: AppColors.primaryColor,
                        width: 20.sp,
                        height: 20.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'utility.supply_info'.tr,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFE8F9),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: const Color(0xFFD2D2D2), width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'utility.pod_code'.tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "IT001E12345678",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFC4C5D5), width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.copy_outlined,
                                size: 14.sp,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'utility.copy'.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  Row(
                    children: [
                      Expanded(
                        child: _miniInfo(
                          title: 'utility.address'.tr,
                          value: "Via Roma 123,\nMilan, IT",
                        ),
                      ),
                      Expanded(
                        child: _miniInfo(
                          title: 'utility.meter_number'.tr,
                          value: "MTR-XCFAQRT18",
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  Divider(color:  Colors.grey),

                  SizedBox(height: 18.h),

                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: const Color(0xFFD2D2D2), width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'utility.annual_consumption'.tr,
                                style: TextStyle(
                                  color:
                                  AppColors.primaryColor,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "2,800 kWh",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          AppAssets.chart,
                          color: AppColors.primaryColor,
                          width: 34.sp,
                          height: 34.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            _sectionTitle('utility.contact_support'.tr),

            SizedBox(height: 14.h),

            _supportTile(
              icon: AppAssets.sendEmail,
              title: 'utility.send_email'.tr,
              subtitle: "support@utility.com",
              onTap: () => launchUrl(Uri.parse('mailto:support@utility.com')),
            ),

            SizedBox(height: 12.h),

            _supportTile(
              icon: AppAssets.openTicket,
              title: 'utility.open_ticket'.tr,
              subtitle: 'utility.open_ticket_desc'.tr,
              onTap: () => Get.to(() => const SupportFormScreen()),
            ),

            SizedBox(height: 12.h),

            _supportTile(
              icon: AppAssets.website,
              title: 'utility.website'.tr,
              subtitle: "eniplenitude.it",
              isWebsite: true,
              onTap: () => launchUrl(Uri.parse('https://eniplenitude.it'), mode: LaunchMode.externalApplication),
            ),

            SizedBox(height: 26.h),

            _sectionTitle('utility.faq'.tr),

            SizedBox(height: 14.h),

            Obx(() {
              if (controller.isFaqLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.faqError.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          controller.faqError.value,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => controller.fetchFaqs(),
                          child: Text(
                            'utility.retry'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.faqList.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: List.generate(
                  controller.faqList.length,
                      (index) {
                    final item = controller.faqList[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
                      ),
                      child: ExpansionTile(
                        shape: const Border(),
                        tilePadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        title: Text(
                          item.question,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            child: Text(
                              item.answer,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),

            SizedBox(height: 30.h),
          ],
        ),
      ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _miniInfo({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _supportTile({
    required String icon,
    required String title,
    required String subtitle,
    bool isWebsite = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
      ),
      child: Row(
        children: [
          Container(

            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Image.asset(
                icon,
                height: 42.h,
                width: 42.w,
              ),
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            isWebsite
                ? Icons.open_in_new
                : Icons.arrow_forward_ios,
            size: 16.sp,
            color: Colors.black,
          ),
        ],
      ),
      ),
    );
  }
}
