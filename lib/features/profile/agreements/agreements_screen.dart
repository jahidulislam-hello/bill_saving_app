import 'package:billo/features/profile/agreements/agreements_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'agreements_controller.dart';


class AgreementsScreen extends StatefulWidget {
  const AgreementsScreen({super.key});

  @override
  State<AgreementsScreen> createState() => _AgreementsScreenState();
}

class _AgreementsScreenState extends State<AgreementsScreen> {
  final AgreementsController _controller = AgreementsController();

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
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Your Benefits banner ──
            _buildBenefitsBanner(),
            SizedBox(height: 16.h),

            // ── Agreement list ──
            ..._controller.agreements.map(
                  (item) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _buildAgreementCard(item),
              ),
            ),

            SizedBox(height: 16.h),
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agreements',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              height: 1.22,
            ),
          ),
          Text(
            'Exclusive discounts for you',
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF9E9E9E),
              height: 1.22,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
      ),
    );
  }

  // ── Your Benefits banner ──
  Widget _buildBenefitsBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFB2DFCC), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: const Color(0xFF27AE60),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.local_offer_rounded,
                color: Colors.white, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Benefits',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                    height: 1.22,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Enjoy exclusive discounts at our partner restaurants as a valued member.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF555555),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Agreement card ──
  Widget _buildAgreementCard(AgreementModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AgreementDetailsScreen(
              agreement: item,
              controller: _controller,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Thumbnail ──
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                bottomLeft: Radius.circular(14.r),
              ),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                item.imageUrl,
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imagePlaceholder(),
              )
                  : _imagePlaceholder(),
            ),

            SizedBox(width: 12.w),

            // ── Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                      height: 1.22,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    item.city,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9E9E9E),
                      height: 1.22,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Discount pill
                  Row(
                    children: [
                      Icon(Icons.local_offer_rounded,
                          size: 12.sp,
                          color: const Color(0xFF27AE60)),
                      SizedBox(width: 4.w),
                      Text(
                        item.discount,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF27AE60),
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Chevron ──
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Icon(Icons.chevron_right_rounded,
                  color: Colors.grey.shade400, size: 20.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 80.w,
      height: 80.w,
      color: Colors.grey.shade100,
      child: Icon(Icons.restaurant_rounded,
          color: Colors.grey.shade300, size: 28.sp),
    );
  }
}