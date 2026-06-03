import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vyzi/core/appbar/custom_appbar.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';

class FaqUtiliesScreen extends StatefulWidget {
  const FaqUtiliesScreen({super.key});

  @override
  State<FaqUtiliesScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqUtiliesScreen> {
  // tracks which FAQ item is expanded (-1 = none)
  int _expandedIndex = -1;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How does the switching process work?',
      'answer':
          'Switching is simple and hassle-free. Once you select an offer and complete your request, we handle everything with your current supplier. The entire process typically takes 2–4 weeks with no interruption to your service.',
    },
    {
      'question': 'Will my service be interrupted?',
      'answer':
          'No. Your gas or electricity supply will never be interrupted during the switch. The changeover happens seamlessly in the background — you won\'t notice a thing.',
    },
    {
      'question': 'What if I\'m still under contract?',
      'answer':
          'If you are still within a fixed-term contract, switching early may incur exit fees from your current supplier. We recommend checking your existing contract terms before proceeding.',
    },
    {
      'question': 'How long does it take to receive my contract?',
      'answer':
          'After activating your offer, you will receive your contract via email within 24 hours. Please review and sign it digitally to complete the process.',
    },
    {
      'question': 'Can I switch both gas and electricity?',
      'answer':
          'Yes! You can switch gas, electricity, or both at the same time. Many of our offers are dual-fuel, which can save you even more on your annual bills.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'FAQ (How to get started)',
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero Image ──
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          AppAssets.faqThree,
                          width: double.infinity,
                          height: 320.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imageFallback(),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── Section title ──
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Frequently Asked Questions',
                        style: AppStyles.h4.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // ── FAQ accordion items ──
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: List.generate(_faqs.length, (i) {
                          return _buildFaqItem(i);
                        }),
                      ),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Single FAQ accordion tile ──
  Widget _buildFaqItem(int index) {
    final isExpanded = _expandedIndex == index;
    final faq = _faqs[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF5A1ABE),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Question row ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq['question']!,
                      style: AppStyles.body3.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),

            // ── Answer (animated expand) ──
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider),
                    SizedBox(height: 12.h),
                    Text(
                      faq['answer']!,
                      style: AppStyles.body4.copyWith(
                        height: 1.6,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 220),
            ),
          ],
        ),
      ),
    );
  }

  // ── Fallback when image fails to load ──
  Widget _imageFallback() {
    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work_outlined,
                size: 52.sp,
                color: AppColors.primaryColor.withOpacity(0.5)),
            SizedBox(height: 8.h),
            Text(
              'Utility Services',
              style: AppStyles.body2.copyWith(
                color: AppColors.primaryColor.withOpacity(0.7),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
