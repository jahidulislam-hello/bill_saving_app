import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/core/widgets/primary_button.dart';
import 'package:vyzi/features/request/models/api_offer_model.dart';
import 'package:vyzi/features/request/offer_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:vyzi/features/bills/models/bill_model.dart';
import 'package:vyzi/features/utility/select_utility_screen.dart';

import '../../core/appbar/custom_appbar.dart';
import '../../routes/app_routes.dart';
import 'request_controller.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  late final RequestController _controller;
  late final TabController _tabController;


  @override
  void initState() {
    super.initState();
    _controller = RequestController();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.selectTab(_tabController.index);
      }
    });

    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    _controller.fetchOffers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'request.title'.tr,
        showBackButton: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          _buildTabBar(),
          Expanded(
            child: _controller.isYourOffersTab
                ? _buildOffersTab()
                : _buildMyRequestsTab(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  TAB BAR
  // ─────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _tabItem('request.tab.your_offers'.tr, 0),
          _tabItem('request.tab.my_requests'.tr, 1),
        ],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final isSelected = _controller.selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
          _controller.selectTab(index);
        },
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  title,
                  style: isSelected ? AppStyles.h4 : AppStyles.body2.copyWith(color: Colors.black),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2.h,
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  YOUR OFFERS TAB
  // ─────────────────────────────────────────────

  Widget _buildOffersTab() {
    if (_controller.isLoadingOffers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.offersError.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('request.offers.load_failed'.tr, style: AppStyles.h4),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => _controller.fetchOffers(),
                child: Text('common.retry'.tr,
                    style: AppStyles.body2
                        .copyWith(color: AppColors.primaryColor)),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller.offers.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOffersHeader(),
        Expanded(
          child: ListView.builder(
            padding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            itemCount: _controller.offers.length,
            itemBuilder: (context, index) =>
                _buildOfferCard(_controller.offers[index]),
          ),
        ),
      ],
    );
  }

  // ── Offers count header ──
  Widget _buildOffersHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'request.offers.best_for_you'.tr,
            style: AppStyles.h4.copyWith(fontSize: 15.sp),
          ),
          Text(
            '${_controller.offers.length} ${'request.offers.found'.tr}',
            style: AppStyles.body4.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  // ── Offer card ──
  Widget _buildOfferCard(ApiOfferModel offer) {
    final supplierName = offer.supplier?.name ?? offer.name;
    final subtitle = offer.supplier != null ? offer.name : (offer.description ?? '');

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF5A1ABE),
          width: 1.22,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top: logo + title + badge ──
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: _buildSupplierLogo(offer.supplier?.logoUrl),
                ),
                SizedBox(width: 12.w),
                // Title & subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplierName,
                        style: AppStyles.h4.copyWith(fontSize: 15.sp),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xFF5A1ABE),
                            width: 1.22,
                          ),
                        ),
                        child: Text(
                          subtitle,
                          style: AppStyles.body4.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Energy price info row ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EEFF),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '${'request.offers.energy_price_label'.tr} : ${offer.energyPriceDisplay}',
                style: AppStyles.body4.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w800),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // ── Contract info row ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: _buildInfoRow(
              icon: Image.asset(
                'assets/images/pay.png',
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
              iconColor: const Color(0xFF5B7FD8),
              text: '${'request.offers.duration_label'.tr}: ${offer.contractDurationDisplay}',
            ),
          ),

          SizedBox(height: 8.h),

          // ── Target row ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Image.asset(
                    'assets/images/compat.png',
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                  ),
                  iconColor: const Color(0xFF9B59B6),
                  text: '${'request.offers.compatibility_label'.tr}: ${offer.target == 'personal' ? 'request.offers.residential'.tr : offer.target == 'business' ? 'request.offers.business'.tr : 'request.offers.all_types'.tr}',
                ),
                SizedBox(height: 12.h),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // ── Fixed monthly fee ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Text(
                  '€${offer.fixedMonthlyFee.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'request.offers.monthly_fixed'.tr,
                  style: AppStyles.body3.copyWith(color: const Color(0xFF1A1A2E), fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          // ── Estimated savings badge ──
          if (offer.estimatedSavings != null && offer.estimatedSavings! > 0) ...[
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.savings_outlined, color: const Color(0xFF4CAF50), size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      '${'request.offers.estimated_savings'.tr}: ${offer.estimatedSavingsDisplay}',
                      style: AppStyles.body4.copyWith(
                        color: const Color(0xFF4CAF50),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          SizedBox(height: 14.h),

          // ── CTA Button ──
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
            child: PrimaryButton(
              title: 'request.go_to_details'.tr,
              height: 46.h,
              onPress: () {
                Get.to(() => OfferDetailsScreen(
                  offerId: offer.id,
                  estimatedSavings: offer.estimatedSavings,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierLogo(String? logoUrl) {
    if (logoUrl != null && logoUrl.isNotEmpty) {
      return Image.network(
        logoUrl,
        width: 52.w,
        height: 52.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _defaultLogo(),
      );
    }
    return _defaultLogo();
  }

  Widget _defaultLogo() {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0A4C), Color(0xFF3A1F8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.bolt, color: Colors.white, size: 26.sp),
    );
  }

  Widget _buildInfoRow({
    required Widget icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      children: [
        icon,
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: AppStyles.body4.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  EMPTY STATE
  // ─────────────────────────────────────────────

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            // Circular illustration with bill icon and magnifier
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180.w,
                  height: 180.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF3F0F8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.receipt_long_rounded,
                      size: 80.sp,
                      color: const Color(0xFFD1C4E9),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  right: 20.w,
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.search,
                      size: 20.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),
            Text(
              'request.offers.empty_title'.tr,
              style: AppStyles.h4.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'request.offers.empty_desc'.tr,
              textAlign: TextAlign.center,
              style: AppStyles.body2.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            PrimaryButton(
              title: 'my_utility.upload_button'.tr,
              prefixWidget: Icon(
                Icons.upload_file_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
              onPress: () {
                Get.to(() => const SelectUtilityScreen());
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  MY REQUESTS TAB (Bills)
  // ─────────────────────────────────────────────

  Widget _buildMyRequestsTab() {
    if (_controller.isLoadingBills) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.billsError.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('request.bills.load_failed'.tr, style: AppStyles.h4),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => _controller.fetchBills(),
                child: Text('common.retry'.tr,
                    style: AppStyles.body2
                        .copyWith(color: AppColors.primaryColor)),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller.bills.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      itemCount: _controller.bills.length,
      itemBuilder: (context, index) =>
          _buildBillCard(_controller.bills[index]),
    );
  }

  Widget _buildBillCard(BillModel bill) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.billDetailScreen, arguments: bill.id);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFF5A1ABE),
            width: 1.22,
          ),
        ),
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: icon + title + status icon ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0F8),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    bill.billTypeIcon,
                    size: 24.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.supplierName,
                        style: AppStyles.h4.copyWith(fontSize: 15.sp),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        bill.billTypeDisplay,
                        style: AppStyles.body4
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      if (bill.totalAmount != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          '${'request.offers.amount_label'.tr}: ${bill.totalAmountDisplay}',
                          style: AppStyles.body4.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  bill.status == 'analyzed'
                      ? Icons.check_circle_outline
                      : bill.status == 'error'
                          ? Icons.error_outline
                          : Icons.hourglass_top_rounded,
                  size: 20.sp,
                  color: bill.statusColor,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: bill.statusBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    bill.statusDisplay,
                    style: AppStyles.body4.copyWith(
                        color: bill.statusColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 11.sp),
                  ),
                ),
                Text(
                  bill.formattedDate,
                  style: AppStyles.body4.copyWith(
                      color: const Color(0xFF9810FA),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            if (bill.status == 'analyzed') ...[
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 38.h,
                child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.billDetailScreen,
                        arguments: bill.id);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF5A1ABE)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'request.offers.view_details'.tr,
                    style: AppStyles.body2.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF9810FA)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
