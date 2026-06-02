import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeBg),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [

                  Image.asset(
                    AppAssets.homeLogo,
                    width: 48.w,
                    height: 48.h,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(),
                  Image.asset(
                    AppAssets.notification,
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                "Ciao, Ja! 👋",
                style: AppStyles.h1.copyWith(color: Colors.white),
              ),
              SizedBox(height: 8.h),
              Text(
                "Pronto a risparmiare sulle tue utenze?",
                style: AppStyles.body2.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
