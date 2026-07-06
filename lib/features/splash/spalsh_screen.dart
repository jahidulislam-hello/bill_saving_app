import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/services/storage_service.dart';
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
    _checkUserSession();
  }

  Future<void> _checkUserSession() async {
    await Future.delayed(const Duration(seconds: 3));
    
    // Use the singleton StorageService registered in main.dart
    final storage = Get.find<StorageService>();
    
    final isLoggedIn = storage.getBool(StorageKeys.isLoggedIn) ?? false;
    final authToken = storage.getString(StorageKeys.authToken);
    
    if (isLoggedIn && authToken != null && authToken.isNotEmpty) {
      // User has active session - go to navbar
      Get.offNamed(AppRoutes.navbarScreen);
    } else {
      // No active session - go to onboarding
      Get.offNamed(AppRoutes.warmOnboardScreen);
    }
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
