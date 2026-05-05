import 'package:billo/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/utils/app_colors.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 876),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Billo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: AppColors.background,
            textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: GoogleFonts.openSans(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Bindings are handled by DependencyInjection.init() in main.dart
          initialBinding: BindingsBuilder(() {
            // Controllers are already lazy loaded via DI
          }),
          home: child,
        );
      },
      child:  OnboardingScreen(),
    );
  }
}
