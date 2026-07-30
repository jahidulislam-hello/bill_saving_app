import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/services/deep_link_service.dart';
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

    final storage = Get.find<StorageService>();
    final deepLinkService = Get.find<DeepLinkService>();

    final isLoggedIn = storage.getBool(StorageKeys.isLoggedIn) ?? false;
    final authToken = storage.getString(StorageKeys.authToken);

    // Mark splash as done so future warm-start links navigate immediately
    deepLinkService.markSplashCompleted();

    if (isLoggedIn && authToken != null && authToken.isNotEmpty) {
      // User has active session
      Get.offNamed(AppRoutes.navbarScreen);
      // If a referral deep link was pending, show dialog
      final pendingCode = deepLinkService.pendingReferralCode;
      if (pendingCode != null && pendingCode.isNotEmpty) {
        deepLinkService.showReferralNotAvailableDialog();
        await deepLinkService.clearPendingReferralCode();
      }
    } else {
      // No active session
      final pendingCode = deepLinkService.pendingReferralCode;
      if (pendingCode != null && pendingCode.isNotEmpty) {
        // Deep link referral — go straight to registration
        await deepLinkService.clearPendingReferralCode();
        Get.offNamed(AppRoutes.signUpScreen, arguments: {'referralCode': pendingCode});
      } else {
        // Normal flow — go to onboarding
        Get.offNamed(AppRoutes.warmOnboardScreen);
      }
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
