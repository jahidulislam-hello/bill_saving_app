
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
      height: 64.h,
      width: 64.w,
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
              icon: Icons.home_outlined,
              label: 'navbar.home',
            ),
          ),
          Expanded(
            child: _buildNavItem(
              index: 1,
              icon: Icons.description_outlined,
              label: 'navbar.request',
            ),
          ),
          SizedBox(width: 72.w), // Space for FAB notch
          Expanded(
            child: _buildNavItem(
              index: 2,
              icon: Icons.flash_on_outlined,
              label: 'navbar.utilities',
            ),
          ),
          Expanded(
            child: _buildNavItem(
              index: 3,
              icon: Icons.person_outline,
              label: 'navbar.profile',
            ),
          ),
        ],
      ),
    );
  }

  /// Navigation Item with Icon and Translated Label
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    return Obx(() {
      final bool isSelected = _controller.selectedIndex == index;
      final color = isSelected ? AppColors.primaryColor : Colors.grey;
      return InkResponse(
        onTap: () => _controller.changeIndex(index),
        child: SizedBox(
          height: 56.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24.w, color: color),
              SizedBox(height: 2.h),
              Text(
                label.tr,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: color,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
