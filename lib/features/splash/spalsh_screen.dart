import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.warmOnboardScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Image.asset(
          AppAssets.logo,
          width: 180.w,
          height: 180.h,
        ),
      ),
    );
  }
}
