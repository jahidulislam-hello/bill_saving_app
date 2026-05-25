
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vyzi/routes/app_routes.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _SelectProfileScreenState createState() => _SelectProfileScreenState();
}

class _SelectProfileScreenState extends State<OnboardingScreen> {
  int selectedIndex = 0; // 0 = Private, 1 = Business
  final List<Map<String, dynamic>> accountTypes = [
    {
      "title": "Private",
      "subtitle":
      "For Personal use and management\nof household utilities",
      "icon": Icons.person,
      "points": [
        "Manage your home electricity & gas",
        "Compare personal energy offers",
        "Track savings and consumption",
      ]
    },
    {
      "title": "Business",
      "subtitle":
      "For Companies, Professionals and\nBusinesses with utilities",
      "icon": Icons.business_center_outlined,
      "points": [
        "Manage multiple business utilities",
        "Business-specific energy offers",
        "VAT/P.IVA and company details",
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  children: [
                    SizedBox(height: 18.h),

                    /// LOGO
                    Container(
                      height: 76.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E2F3),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [
                                Color(0xFF0D63FF),
                                Color(0xFF00D2FF),
                              ],
                            ).createShader(bounds);
                          },
                          child: Icon(
                            Icons.flash_on,
                            size: 42.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "VYZI",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF122A72),
                        letterSpacing: 1,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      "How do you want to use VYZI?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF333333),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "Choose how to register on VYZI",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    /// CARDS
                    ListView.builder(
                      itemCount: accountTypes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = accountTypes[index];
                        final isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 24.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFB400FF)
                                    : const Color(0xFFD9C7EB),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 48.h,
                                      width: 48.w,
                                      decoration: BoxDecoration(
                                        color:
                                        const Color(0xFFF0E8FA),
                                        borderRadius:
                                        BorderRadius.circular(16.r),
                                      ),
                                      child: Icon(
                                        item["icon"],
                                        color: const Color(0xFF8E24FF),
                                        size: 24.sp,
                                      ),
                                    ),

                                    SizedBox(width: 16.w),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["title"],
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight:
                                              FontWeight.w700,
                                              color:
                                              const Color(0xFF333333),
                                            ),
                                          ),

                                          SizedBox(height: 4.h),

                                          Text(
                                            item["subtitle"],
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              height: 1.4,
                                              color:
                                              const Color(0xFF7C7C7C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      height: 24.h,
                                      width: 24.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFFB400FF)
                                              : const Color(0xFFC8C8C8),
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? const Color(0xFFB400FF)
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 14.sp,
                                      )
                                          : null,
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10.h),

                                Divider(
                                  color: const Color(0xFFE5E5E5),
                                  thickness: 1,
                                ),

                                SizedBox(height: 8.h),

                                Column(
                                  children: List.generate(
                                    item["points"].length,
                                        (i) => Padding(
                                      padding:
                                      EdgeInsets.only(bottom: 14.h),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 16.h,
                                            width: 16.w,
                                            decoration:
                                            const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                              Color(0xFF23C16B),
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 12.sp,
                                            ),
                                          ),

                                          SizedBox(width: 12.w),

                                          Expanded(
                                            child: Text(
                                              item["points"][i],
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: const Color(
                                                    0xFF666666),
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),


            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 18.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(34.r),
                  topRight: Radius.circular(34.r),
                ),
              ),
              child: Column(
                children: [
                  /// Sign In Button
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.signInScreen);
                    },
                    child: Container(
                      height: 52.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9C00FF),
                            Color(0xFFC300FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// Create Account Button
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.signUpScreen);
                    },
                    child: Container(
                      height: 52.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFB400FF),
                          width: 1.6,
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Create an Account",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFB400FF),
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
      ),
    );
  }
}
