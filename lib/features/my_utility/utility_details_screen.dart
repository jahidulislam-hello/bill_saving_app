import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vyzi/features/my_utility/utility_details_controller.dart';


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
          "Utility Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                              "ACTIVE OFFER",
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
                                  "MATERIAL PRICE",
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
                                  "ACTIVATION",
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
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Active Offer"),
                  SizedBox(height: 16.h),
                  _infoRow("Offer Name", "fixed Rate Plan"),
                  SizedBox(height: 16.h),
                  _infoRow("Service Type", "Gas"),
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
                        "Supply Information",
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
                                "POD CODE",
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
                            border: Border.all(color: const Color(0xFF5A1ABE), width: 1),
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
                                "Copy",
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
                          title: "Address",
                          value: "Via Roma 123,\nMilan, IT",
                        ),
                      ),
                      Expanded(
                        child: _miniInfo(
                          title: "Meter Number",
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
                                "ANNUAL CONSUMPTION",
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

            _sectionTitle("Contact Support"),

            SizedBox(height: 14.h),

            _supportTile(
              icon: AppAssets.sendEmail,
              title: "Send Email",
              subtitle: "support@utility.com",
            ),

            SizedBox(height: 12.h),

            _supportTile(
              icon: AppAssets.openTicket,
              title: "Open Ticket",
              subtitle: "Get help via app support",
            ),

            SizedBox(height: 12.h),

            _supportTile(
              icon: AppAssets.website,
              title: "Website",
              subtitle: "eniplenitude.it",
              isWebsite: true,
            ),

            SizedBox(height: 26.h),

            _sectionTitle("Frequently Asked Questions"),

            SizedBox(height: 14.h),

            Obx(
                  () => Column(
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
              ),
            ),

            SizedBox(height: 30.h),
          ],
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
  }) {
    return Container(
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
    );
  }
}
