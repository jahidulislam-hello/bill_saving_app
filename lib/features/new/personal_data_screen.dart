import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONTROLLER
// ─────────────────────────────────────────────────────────────────────────────
class PersonalDataController extends GetxController {
  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController(text: 'alexsmith.mobbin@gmail.com');
  final phoneController = TextEditingController();
  final referralCodeController = TextEditingController(text: 'RSSMRA231X1WDF52');

  // Form key
  final formKey = GlobalKey<FormState>();

  // Observable states
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasChanges = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Listen for changes
    firstNameController.addListener(_onFieldChanged);
    lastNameController.addListener(_onFieldChanged);
    emailController.addListener(_onFieldChanged);
    phoneController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    hasChanges.value = true;
  }

  Future<void> pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        profileImage.value = File(picked.path);
        hasChanges.value = true;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not pick image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    hasChanges.value = false;

    Get.snackbar(
      'Success',
      'Your profile has been updated.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A1A2E),
      colorText: Colors.white,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
    );
  }

  void cancelAndDiscard() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.text = 'alexsmith.mobbin@gmail.com';
    phoneController.clear();
    profileImage.value = null;
    hasChanges.value = false;
    Get.back();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    referralCodeController.dispose();
    super.onClose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN (entry point)
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Personal Data',
          theme: ThemeData(
            fontFamily: 'SF Pro Display',
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1A1A2E),
            ),
          ),
          home: const PersonalDataScreen(),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW
// ─────────────────────────────────────────────────────────────────────────────
class PersonalDataScreen extends StatelessWidget {
  const PersonalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalDataController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            SizedBox(height: 6.h),

            // Subtitle
            Text(
              'Update your account information and how\nwe contact you.',
              style: TextStyle(
                fontSize: 13.5.sp,
                color: const Color(0xFF6B7280),
                height: 1.55,
              ),
            ),

            SizedBox(height: 24.h),

            // ── Profile card ──────────────────────────────────────────
            _ProfileCard(controller: controller),

            SizedBox(height: 28.h),

            // ── Form fields ───────────────────────────────────────────
            _FormField(
              label: 'First Name',
              controller: controller.firstNameController,
              hintText: '',
              validator: (v) =>
              v == null || v.isEmpty ? 'Enter your first name' : null,
            ),
            SizedBox(height: 20.h),

            _FormField(
              label: 'Last Name',
              controller: controller.lastNameController,
              hintText: '',
              validator: (v) =>
              v == null || v.isEmpty ? 'Enter your last name' : null,
            ),
            SizedBox(height: 20.h),

            _FormField(
              label: 'Email',
              controller: controller.emailController,
              hintText: 'alexsmith.mobbin@gmail.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your email';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            SizedBox(height: 20.h),

            _FormField(
              label: 'Phone Number',
              controller: controller.phoneController,
              hintText: '',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20.h),

            // Referral code (read-only)
            _ReferralField(controller: controller),

            SizedBox(height: 20.h),

            // Privacy banner
            _PrivacyBanner(),

            SizedBox(height: 32.h),

            // Save button
            _SaveButton(controller: controller),

            SizedBox(height: 12.h),

            // Cancel
            _CancelButton(controller: controller),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: EdgeInsets.only(left: 16.w),
          child: Icon(
            Icons.arrow_back_rounded,
            color: const Color(0xFF1A1A2E),
            size: 22.sp,
          ),
        ),
      ),
      title: Text(
        'Personal Data',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
          letterSpacing: -0.3,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Divider(
          height: 1,
          color: const Color(0xFFF3F4F6),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.controller});
  final PersonalDataController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with edit badge
          GestureDetector(
            onTap: controller.pickImage,
            child: Stack(
              children: [
                Obx(() {
                  return Container(
                    width: 90.w,
                    height: 90.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: controller.profileImage.value != null
                          ? Image.file(
                        controller.profileImage.value!,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        'https://i.pravatar.cc/300?img=47',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF1A1A2E),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                // Edit badge
                Positioned(
                  bottom: 2.h,
                  right: 2.w,
                  child: Container(
                    width: 26.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Name
          Text(
            'Alex Harrison',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            'Member since January 2024',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF9CA3AF),
            ),
          ),

          SizedBox(height: 10.h),

          // Change photo text button
          GestureDetector(
            onTap: controller.pickImage,
            child: Text(
              'Change photo',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF10B981),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FORM FIELD
// ─────────────────────────────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 7.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          validator: validator,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFFD1D5DB),
            ),
            filled: true,
            fillColor: readOnly
                ? const Color(0xFFF9FAFB)
                : const Color(0xFFF9FAFB),
            suffixIcon: suffixIcon,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: const Color(0xFFE5E7EB),
                width: 1.2.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: const Color(0xFFE5E7EB),
                width: 1.2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: const Color(0xFF1A1A2E),
                width: 1.5.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: Colors.red.shade300,
                width: 1.2.w,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 1.5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REFERRAL / CODE FIELD
// ─────────────────────────────────────────────────────────────────────────────
class _ReferralField extends StatelessWidget {
  const _ReferralField({required this.controller});
  final PersonalDataController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
            ),
            children: const [
              TextSpan(text: 'Paste from divriots'),
              TextSpan(
                text: 'Paste from divriots Code',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        SizedBox(height: 7.h),
        TextFormField(
          controller: controller.referralCodeController,
          readOnly: true,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            suffixIcon: GestureDetector(
              onTap: () {
                // Copy to clipboard
                Get.snackbar(
                  'Copied!',
                  'Code copied to clipboard.',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                  backgroundColor: const Color(0xFF1A1A2E),
                  colorText: Colors.white,
                  margin: EdgeInsets.all(16.w),
                  borderRadius: 12.r,
                );
              },
              child: Icon(
                Icons.copy_rounded,
                color: const Color(0xFF9CA3AF),
                size: 18.sp,
              ),
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: const Color(0xFFE5E7EB),
                width: 1.2.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: const Color(0xFFE5E7EB),
                width: 1.2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: const Color(0xFFE5E7EB),
                width: 1.2.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVACY BANNER
// ─────────────────────────────────────────────────────────────────────────────
class _PrivacyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFDDE3F8),
          width: 1.w,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: const Color(0xFF4B6BFB),
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy First',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Your data is encrypted and managed according to our premium guardian standards. We never share your personal details with third-party providers without consent.',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF6B7280),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SAVE BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.controller});
  final PersonalDataController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: controller.isLoading.value ? null : controller.saveChanges,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: controller.isLoading.value
                ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CANCEL BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.controller});
  final PersonalDataController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.cancelAndDiscard,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            'Cancel and discard',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}