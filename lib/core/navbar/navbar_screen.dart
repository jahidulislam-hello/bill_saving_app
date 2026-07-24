
import 'package:vyzi/core/navbar/navbar_controller.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/home/screen/home_screen.dart';
import 'package:vyzi/features/my_utility/my_utiliets.dart';
import 'package:vyzi/features/profile/profile_screen.dart';
import 'package:vyzi/features/request/request_screen.dart';
import 'package:vyzi/features/utility/select_utility_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final NavbarController _controller = Get.put(NavbarController());

  final List<Widget> _screens = [
    HomeScreen(),
    RequestScreen(),
    MyUtilitiesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        body: _screens[_controller.selectedIndex],
        bottomNavigationBar: _buildBottomNavigationBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  /// Floating Action Button
  Widget _buildFloatingActionButton() {
    return SizedBox(
      height: 56.h,
      width: 56.w,
      child: FloatingActionButton(
        backgroundColor: AppColors.lightPurple,
        elevation: 2,
        onPressed: () => Get.to(() => SelectUtilityScreen()),
        shape: const CircleBorder(),
        child: ClipOval(
          child: Image.asset(
            "assets/images/VYZI.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: AppColors.background,
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: _buildNavItem(
              index: 0,
              activeImage: "assets/images/home_act.png",
              passiveImage: "assets/images/home.png",
            ),
          ),
          Expanded(
            child: _buildNavItem(
              index: 1,
              activeImage: "assets/images/rich_act.png",
              passiveImage: "assets/images/rich.png",
            ),
          ),
          SizedBox(width: 68.w), // Space for FAB notch
          Expanded(
            child: _buildNavItem(
              index: 2,
              activeImage: "assets/images/utili_act.png",
              passiveImage: "assets/images/utili.png",
            ),
          ),
          Expanded(
            child: _buildNavItem(
              index: 3,
              activeImage: "assets/images/profil_act.png",
              passiveImage: "assets/images/profil.png",
            ),
          ),
        ],
      ),
    );
  }

  /// Navigation Item with Image Icons
  Widget _buildNavItem({
    required int index,
    required String activeImage,
    required String passiveImage,
  }) {
    return Obx(() {
      final bool isSelected = _controller.selectedIndex == index;
      return InkResponse(
        onTap: () => _controller.changeIndex(index),
        child: SizedBox(
          height: 48.h,
          child: Center(
            child: Image.asset(
              isSelected ? activeImage : passiveImage,
              width: 40.w,
              height: 40.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    });
  }
}
