
import 'package:billo/core/utils/app_colors.dart';
import 'package:billo/features/home/screen/home_screen.dart';
import 'package:billo/features/my_utility/my_utiliets.dart';
import 'package:billo/features/new/select_utility_screen.dart';
import 'package:billo/features/profile/profile_screen.dart';
import 'package:billo/features/request/request_screen.dart';
import 'package:billo/features/utility/select_utility_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';




class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    RequestScreen(),
    MyUtilitiesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Floating Action Button
  Widget _buildFloatingActionButton() {
    return SizedBox(
      height: 50.h,
      width: 50.w,
      child: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        onPressed: () {
          Get.to(() => SelectUtilityScreen());
        },

        shape: const CircleBorder(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40.r),
          child: Image.asset(
            "assets/icons/flash.png",
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
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          SizedBox(width: 50.w), // Space for FAB
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
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Image.asset(
          isSelected ? activeImage : passiveImage,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}