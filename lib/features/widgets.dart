import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONTROLLER
// ─────────────────────────────────────────────────────────────────────────────
class UpgradeToBusinessController extends GetxController {
  final companyNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxBool agreedToTerms = false.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedRole = ''.obs;
  final RxBool isDropdownOpen = false.obs;
  final RxBool companyNameFocused = false.obs;

  final List<String> roles = [
    'CEO / Founder',
    'Manager',
    'Developer',
    'Designer',
    'Marketing',
    'Finance',
    'HR',
    'Other',
  ];

  void selectRole(String role) {
    selectedRole.value = role;
    isDropdownOpen.value = false;
  }

  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }

  void toggleTerms() {
    agreedToTerms.value = !agreedToTerms.value;
  }

  Future<void> completeSwitchAndContinue() async {
    if (!formKey.currentState!.validate()) return;
    if (!agreedToTerms.value) {
      Get.snackbar(
        'Agreement Required',
        'Please agree to the Business Terms & Conditions.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.r,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.back(); // close sheet
    Get.snackbar(
      'Upgraded! 🎉',
      'Your account has been switched to Business.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A1A2E),
      colorText: Colors.white,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
    );
  }

  @override
  void onClose() {
    companyNameController.dispose();
    super.onClose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHOW HELPER — call this from anywhere
// ─────────────────────────────────────────────────────────────────────────────
void showUpgradeToBusinessSheet(BuildContext context) {
  final controller = Get.put(UpgradeToBusinessController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (_) => _UpgradeToBusinessSheet(controller: controller),
  ).then((_) => Get.delete<UpgradeToBusinessController>());
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM SHEET WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _UpgradeToBusinessSheet extends StatelessWidget {
  const _UpgradeToBusinessSheet({required this.controller});
  final UpgradeToBusinessController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Pushes sheet up when keyboard appears
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag handle ──────────────────────────────────────
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 6.h),

              // ── Header row (title + close) ────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 32), // balance
                    Text(
                      'Upgrade to Business',
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A2E),
                        letterSpacing: -0.4,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              // ── Subtitle ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Text(
                  'We already have your personal info.\nJust add your company details.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                    height: 1.55,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // ── Company Name field ────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _CompanyNameField(controller: controller),
              ),

              SizedBox(height: 12.h),

              // ── Job Role dropdown ─────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _JobRoleDropdown(controller: controller),
              ),

              SizedBox(height: 20.h),

              // ── Terms checkbox ────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _TermsRow(controller: controller),
              ),

              SizedBox(height: 24.h),

              // ── CTA button ────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _CompleteButton(controller: controller),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPANY NAME FIELD
// ─────────────────────────────────────────────────────────────────────────────
class _CompanyNameField extends StatefulWidget {
  const _CompanyNameField({required this.controller});
  final UpgradeToBusinessController controller;

  @override
  State<_CompanyNameField> createState() => _CompanyNameFieldState();
}

class _CompanyNameFieldState extends State<_CompanyNameField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _isFocused
              ? const Color(0xFF1A1A2E)
              : const Color(0xFFD1D5DB),
          width: _isFocused ? 1.6.w : 1.2.w,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Company Name ',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.red.shade400,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: widget.controller.companyNameController,
            focusNode: _focusNode,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF1A1A2E),
              fontWeight: FontWeight.w500,
            ),
            validator: (v) =>
            v == null || v.trim().isEmpty ? 'Company name is required' : null,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: 'e.g., Rossi Consulting S.r.l.',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFB0B8C4),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// JOB ROLE DROPDOWN
// ─────────────────────────────────────────────────────────────────────────────
class _JobRoleDropdown extends StatelessWidget {
  const _JobRoleDropdown({required this.controller});
  final UpgradeToBusinessController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOpen = controller.isDropdownOpen.value;
      final selected = controller.selectedRole.value;

      return Column(
        children: [
          GestureDetector(
            onTap: controller.toggleDropdown,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: isOpen
                    ? BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                )
                    : BorderRadius.circular(12.r),
                border: Border.all(
                  color: isOpen
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFD1D5DB),
                  width: isOpen ? 1.6.w : 1.2.w,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '(Job Role) ',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: '[Optional]',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFFB0B8C4),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          selected.isEmpty ? 'Select your role' : selected,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: selected.isEmpty
                                ? const Color(0xFFB0B8C4)
                                : const Color(0xFF1A1A2E),
                            fontWeight: selected.isEmpty
                                ? FontWeight.w400
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF6B7280),
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dropdown list
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                border: Border(
                  left: BorderSide(
                      color: const Color(0xFF1A1A2E), width: 1.6.w),
                  right: BorderSide(
                      color: const Color(0xFF1A1A2E), width: 1.6.w),
                  bottom: BorderSide(
                      color: const Color(0xFF1A1A2E), width: 1.6.w),
                ),
              ),
              child: Column(
                children: controller.roles.map((role) {
                  final isSelected = controller.selectedRole.value == role;
                  return GestureDetector(
                    onTap: () => controller.selectRole(role),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 11.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFF0F4FF)
                            : Colors.white,
                        border: Border(
                          top: BorderSide(
                              color: const Color(0xFFF3F4F6), width: 1.w),
                        ),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          color: isSelected
                              ? const Color(0xFF1A1A2E)
                              : const Color(0xFF374151),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            crossFadeState: isOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TERMS CHECKBOX ROW
// ─────────────────────────────────────────────────────────────────────────────
class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.controller});
  final UpgradeToBusinessController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final agreed = controller.agreedToTerms.value;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom checkbox
          GestureDetector(
            onTap: controller.toggleTerms,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: agreed
                    ? const Color(0xFF1DB954)
                    : Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: agreed
                      ? const Color(0xFF1DB954)
                      : const Color(0xFFD1D5DB),
                  width: 1.5.w,
                ),
              ),
              child: agreed
                  ? Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 14.sp,
              )
                  : null,
            ),
          ),

          SizedBox(width: 12.w),

          // Rich text
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF6B7280),
                  height: 1.55,
                ),
                children: [
                  const TextSpan(text: 'I agree to '),
                  TextSpan(
                    text: 'Business Terms & Conditions',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF10B981),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to terms
                        Get.snackbar(
                          'Terms',
                          'Opening Business Terms & Conditions...',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      },
                  ),
                  const TextSpan(
                    text:
                    ' and data processing for corporate account management.',
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPLETE BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class _CompleteButton extends StatelessWidget {
  const _CompleteButton({required this.controller});
  final UpgradeToBusinessController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: controller.isLoading.value
            ? null
            : controller.completeSwitchAndContinue,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            color: controller.isLoading.value
                ? const Color(0xFF374151)
                : const Color(0xFF1A1A2E),
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
              'Complete Switch & Continue',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN — demo wrapper showing Personal Data page with bottom nav
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
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Upgrade to Business',
          theme: ThemeData(
            fontFamily: 'SF Pro Display',
            useMaterial3: true,
          ),
          home: const _DemoShell(),
        );
      },
    );
  }
}

class _DemoShell extends StatelessWidget {
  const _DemoShell();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back_rounded,
            color: const Color(0xFF1A1A2E), size: 22.sp),
        title: Text(
          'Personal Data',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Divider(height: 1, color: const Color(0xFFF3F4F6)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upgrade_rounded,
                size: 64.sp, color: const Color(0xFFD1D5DB)),
            SizedBox(height: 16.h),
            Text(
              'Tap the button below\nto open the Business upgrade sheet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: () => showUpgradeToBusinessSheet(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 28.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Upgrade to Business',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}