import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'agreements_controller.dart';

class AgreementDetailsScreen extends StatefulWidget {
  final AgreementModel agreement;
  final AgreementsController controller;

  const AgreementDetailsScreen({
    super.key,
    required this.agreement,
    required this.controller,
  });

  @override
  State<AgreementDetailsScreen> createState() => _AgreementDetailsScreenState();
}

class _AgreementDetailsScreenState extends State<AgreementDetailsScreen> {
  AgreementModel get _a => widget.agreement;
  AgreementsController get _c => widget.controller;

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        slivers: [
          // ── Pinned AppBar ──
          _buildSliverAppBar(),

          // ── Body ──
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),

                // ── Hero Image in Body ──
                _buildBodyImage(),

                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Restaurant name & description ──
                      _buildRestaurantHeader(),
                      SizedBox(height: 16.h),

                      // ── Green discount card ──
                      _buildDiscountCard(),
                      SizedBox(height: 12.h),

                      // ── Location card ──
                      _buildLocationCard(),
                      SizedBox(height: 12.h),

                      // ── How to use card ──
                      _buildHowToUseCard(),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Simple Pinned Sliver AppBar ──
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(Icons.arrow_back_rounded,
                color: const Color(0xFF1A1A2E), size: 18.sp),
          ),
        ),
      ),
      title: Text(
        'Dettagli Convenzione',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  // ── Hero image section for body ──
  Widget _buildBodyImage() {
    return Container(
      height: 200.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: _a.imageUrl.isNotEmpty
          ? Image.network(
              _a.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Icon(
        Icons.restaurant_rounded,
        color: Colors.grey.shade400,
        size: 48.sp,
      ),
    );
  }

  // ── Restaurant name + description + offer date ──
  Widget _buildRestaurantHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _a.fullName,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A2E),
            height: 1.22,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          _a.description,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF555555),
            height: 1.5,
          ),
        ),
        SizedBox(height: 8.h),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.22,
            ),
            children: [
              TextSpan(
                text: 'Data Offerta : ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              TextSpan(
                text: _a.offerDate,
                style: const TextStyle(color: Color(0xFF555555)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Green discount card ──
  Widget _buildDiscountCard() {
    final isCopied =
        _c.isCopied && _c.copiedCode == _a.discountCode;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF27AE60),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Your Exclusive Discount label ──
          Row(
            children: [
              Icon(Icons.local_offer_rounded,
                  color: Colors.white.withOpacity(0.85), size: 14.sp),
              SizedBox(width: 6.w),
              Text(
                'Il Tuo Sconto Esclusivo',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                  height: 1.22,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // ── Discount amount ──
          Text(
            _a.discount,
            style: TextStyle(
              fontSize: 34.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.22,
            ),
          ),

          SizedBox(height: 14.h),

          // ── Discount code box ──
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Codice Sconto',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF9E9E9E),
                          height: 1.22,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _a.discountCode,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A2E),
                          letterSpacing: 1.5,
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                ),

                // Copy button
                GestureDetector(
                  onTap: () => _c.copyCode(context, _a.discountCode),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 9.h),
                    decoration: BoxDecoration(
                      color: isCopied
                          ? const Color(0xFFE8F8EF)
                          : const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isCopied
                            ? const Color(0xFF27AE60)
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isCopied
                              ? Icon(Icons.check_rounded,
                              key: const ValueKey('check'),
                              color: const Color(0xFF27AE60),
                              size: 15.sp)
                              : Icon(Icons.copy_rounded,
                              key: const ValueKey('copy'),
                              color: const Color(0xFF555555),
                              size: 15.sp),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          isCopied ? 'Copiato!' : 'Copia',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isCopied
                                ? const Color(0xFF27AE60)
                                : const Color(0xFF555555),
                            height: 1.22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Location card ──
  Widget _buildLocationCard() {
    return Container(
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
      padding: EdgeInsets.all(14.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.location_on_outlined,
                color: const Color(0xFF5B7FD8), size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posizione',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                  height: 1.22,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _a.address,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF555555),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── How to use card ──
  Widget _buildHowToUseCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFD0DAFF), width: 1.2),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Come Usare il Tuo Sconto',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              height: 1.22,
            ),
          ),
          SizedBox(height: 12.h),
          ..._a.howToUse.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Number circle
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B7FD8),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.22,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      step,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF555555),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}