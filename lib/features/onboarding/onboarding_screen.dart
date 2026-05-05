import 'package:billo/core/utils/app_images.dart';
import 'package:billo/core/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _SelectProfileScreenState createState() => _SelectProfileScreenState();
}

class _SelectProfileScreenState extends State<OnboardingScreen> {
  int selectedIndex = 0; // 0 = Private, 1 = Business

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),

              /// Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back),
              ),

              SizedBox(height: 20),



              Center(
                child: Image.asset(
                  AppImages.appLogo,
                  height: 80.h,
                  fit: BoxFit.contain,
                ),
              ),



              SizedBox(height: 20),

              /// Title
              Text(
                "Select Your Profile",
                style: AppStyles.h5(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Choose How to Register on EasyBill",
                style: AppStyles.body3(
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 30),

              /// Private Card
              _buildOptionCard(
                index: 0,
                title: "Private",
                subtitle:
                "For Personal use and management of household utilities",
                icon: Icons.person_outline,
              ),

              SizedBox(height: 16),

              /// Business Card
              _buildOptionCard(
                index: 1,
                title: "Business",
                subtitle:
                "For Companies, Professionals and Businesses with utilities",
                icon: Icons.business_outlined,
              ),

              Spacer(),

              /// Sign In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5B3FD6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    print("Sign In Clicked");
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: 16),

              /// Create Account Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF5B3FD6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    print("Create Account Clicked");
                  },
                  child: Text(
                    "Create an Account",
                    style: TextStyle(
                      color: Color(0xFF5B3FD6),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: 360,
        height: 120,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFEDEBFF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF5B3FD6) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            /// Icon Circle
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(0xFF5B3FD6)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey, size: 24.h,
              ),
            ),

            SizedBox(width: 15),

            /// Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.h5(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: AppStyles.body3(
                      color: Colors.grey,
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