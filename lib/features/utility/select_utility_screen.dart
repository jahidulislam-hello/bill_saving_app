import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/utility/controller/select_utility_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'upload_bill_screen.dart';

class SelectUtilityScreen extends StatefulWidget {
  const SelectUtilityScreen({super.key});

  @override
  State<SelectUtilityScreen> createState() => _SelectUtilityScreenState();
}

class _SelectUtilityScreenState extends State<SelectUtilityScreen> {
  final SelectUtilityController _controller = SelectUtilityController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 28.h),

            // ── Heading ──
            Text(
              'Which users do you want to\noptimize?',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
                height: 1.28,
              ),
            ),
            SizedBox(height: 8.h),

            // ── Subtitle ──
            Text(
              'Select the service for which you want to find the best deals',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF9E9E9E),
                height: 1.22,
              ),
            ),
            SizedBox(height: 24.h),

            // ── Utility selection cards ──
            Row(
              children: [
                Expanded(
                  child: _buildUtilityCard(
                    type: UtilityType.luce,
                    icon: Icons.bolt_rounded,
                    label: 'LUCE',
                    sublabel: 'Optimize your power bill',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildUtilityCard(
                    type: UtilityType.gas,
                    icon: Icons.local_fire_department_rounded,
                    label: 'GAS',
                    sublabel: 'Reduce your gas expenses',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // ── Tip banner ──
            _buildTipBanner(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded,
            color: const Color(0xFF1A1A2E), size: 22.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Select Utility',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
          height: 1.22,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
            height: 1, thickness: 1, color: Colors.grey.shade200),
      ),
    );
  }

  // ── Utility card (selected = purple, unselected = white) ──
  Widget _buildUtilityCard({
    required UtilityType type,
    required IconData icon,
    required String label,
    required String sublabel,
  }) {
    final isSelected = _controller.selectedUtility == type;

    return GestureDetector(
      onTap: () {
        _controller.selectUtility(type);
        // Navigate to upload bill screen after a short delay
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UploadBillScreen(utilityType: type),
              ),
            );
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: const Color(0xFFC8CCFD),
            width: 1.5,
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 130.h,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6C52D9) : Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF6C52D9)
                  : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFF6C52D9).withOpacity(0.22)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Checkmark top-right
              Positioned(
                top: 10.h,
                right: 10.w,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          size: 13.sp,
                          color: const Color(0xFF6C52D9),
                        )
                      : const SizedBox.shrink(),
                ),
              ),

              // Center content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon container
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : const Color(0xFFF0EEFF),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        icon,
                        size: 26.sp,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6C52D9),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected ? Colors.white : const Color(0xFF1A1A2E),
                        height: 1.22,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      sublabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : const Color(0xFF9E9E9E),
                        height: 1.22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tip banner ──
  Widget _buildTipBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEFF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💡', style: TextStyle(fontSize: 14.sp)),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF6C52D9),
                  height: 1.22,
                ),
                children: const [
                  TextSpan(
                    text: 'Tip: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text:
                    'You can upload more bills later to compare all your utilities.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}