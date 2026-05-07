import 'package:billo/core/utils/app_images.dart';
import 'package:billo/core/utils/app_style.dart';
import 'package:billo/core/widgets/primary_button.dart';
import 'package:billo/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

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
        child: SingleChildScrollView(
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

                SizedBox(height: 50),



                Center(
                  child: Image.asset(
                    AppImages.appLogo,
                    height: 80.h,
                    width: 80.w,
                    fit: BoxFit.contain,
                  ),
                ),



                SizedBox(height: 40),

                /// Title
                Text(
                  "Seleziona il tuo profilo",
                  style: AppStyles.h5(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Scegli come registrarti su EasyBill",
                  style: AppStyles.body3(
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 50),

                /// Private Card
                _buildOptionCard(
                  index: 0,
                  title: "Privato",
                  subtitle:
                  "Per uso personale e gestione delle utenze domestiche",
                  icon: Icons.person_outline,
                ),

                SizedBox(height: 16),

                /// Business Card
                _buildOptionCard(
                  index: 1,
                  title: "Azienda",
                  subtitle:
                  "Per aziende, professionisti eattività con utenze",
                  icon: Icons.business_outlined,
                ),

                SizedBox(height: 150),

                /// Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: PrimaryButton(
                    title: "Accedi",
                    onPress: () {

                      Get.offNamed(AppRoutes.signInScreen);

                    },
                  )
                ),

                SizedBox(height: 16),

                /// Create Account Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF5B3FD6)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.offNamed(AppRoutes.signUpScreen);

                    },
                    child: Text(
                      "Crea un Account",
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
        width: double.infinity,
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