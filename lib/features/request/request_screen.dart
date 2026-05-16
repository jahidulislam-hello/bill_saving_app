import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_images.dart';
import 'package:vyzi/features/request/request_details_screen.dart';
import 'package:vyzi/features/request/offer_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/appbar/custom_appbar.dart';
import 'request_controller.dart';
import 'request_model.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  late final RequestController _controller;
  late final TabController _tabController;

  // Filter options for "Your Offers" tab
  final List<String> _filters = ['Tutti', 'Addebito Diretto', 'Bollettino Postale','AliKobe', 'Ordine Diretto', 'Bollettino Postale'];
  int _selectedFilter = 0;
  bool _isBillUploaded = false;

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
      appBar: const CustomAppBar(
        title: 'Richiesta',
        showBackButton: false,
      ),
      body: _isBillUploaded
          ? Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _controller.isYourOffersTab
                ? _buildOffersTab()
                : _buildMyRequestsTab(),
          ),
        ],
      )
          : GestureDetector(
        onTap: () {
          setState(() {
            _isBillUploaded = true;
          });
        },
        child: Center(
          child: Image.asset(
            'assets/images/uploadBill.png',
            fit: BoxFit.contain,
          ),
        ),
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
          _tabItem('Le Tue Offerte', 0),
          _tabItem('Le Mie Richieste', 1),
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
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFF1A1A2E)
                        : Colors.black45,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2.h,
                color: isSelected
                    ? const Color(0xFF5B3FD8)
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterSection(),
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

  // ── Payment Method filter row ──
  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Line 1: Filter icon + label ──
          Row(
            children: [
              Image.asset(
                AppImages.filter,
                width: 20.w,
                height: 20.h,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 4.w),
              Text(
                'Metodo di Pagamento:',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // ── Line 2: Filter chips ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                _filters.length,
                    (i) => Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: _filterChip(_filters[i], i),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5B3FD8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF5B3FD8)
                : const Color(0xFFDDDDDD),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight:
            isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : const Color(0xFF555555),
          ),
        ),
      ),
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
            'Migliori Offerte per Te',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          Text(
            '${_controller.offers.length} trovate',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }

  // ── Offer card (matches screenshot 1) ──
  Widget _buildOfferCard(OfferModel offer) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.neutral200,
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
          // ── Top: image + title + badge ──
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: offer.imagePath.isNotEmpty
                      ? Image.asset(
                    offer.imagePath,
                    width: 52.w,
                    height: 52.w,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=200',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Title & subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 2.h),
    Container(
     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
          color: AppColors.neutralAlpha10,
          width: 1.22,
           ),
          ),
       child: Text(
        offer.subtitle,
        style: TextStyle(
           fontSize: 12.sp,
             color: const Color(0xFF9E9E9E),
          ),
          ),
    ),
                    ],
                  ),
                ),
                if (offer.isBestValue) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Miglior Valore',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
                'Prezzo Energia : PUN GME + € 0.01/KWh',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF5B3FD8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // ── Payment method row ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: _buildInfoRow(
              icon: Image.asset(
                AppImages.pay,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
              iconColor: const Color(0xFF5B7FD8),
              text: 'Metodo di Pagamento: Bollettino Postale',
            ),
          ),

          SizedBox(height: 8.h),

          // ── Compatibility row ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
    child: Column(
         children: [
          _buildInfoRow(
          icon: Image.asset(
            AppImages.compat,
            width: 24.w,
            height: 24.h,
            fit: BoxFit.contain,
          ),
           iconColor: const Color(0xFF9B59B6),
            text: 'Compatibilità: Residenziale',
          ),
         SizedBox(height: 12.h),
        Divider(
          height: 1,
           thickness: 1,
         color: AppColors.neutral100,
      ),
       ],
    ),
          ),

          SizedBox(height: 12.h),

          // ── Annual savings ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Text(
                  '€${offer.savings.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Risparmio Annuale',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // ── CTA Button ──
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
            child: SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(()=> OfferDetailsScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B3FD8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Vai ai Dettagli e procedi',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF555555),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  MY REQUESTS TAB
  // ─────────────────────────────────────────────

  Widget _buildMyRequestsTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      itemCount: _controller.requests.length,
      itemBuilder: (context, index) =>
          _buildRequestCard(_controller.requests[index]),
    );
  }

  Widget _buildRequestCard(RequestModel request) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.neutral200,
          width: 1.22,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 8,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: icon + title + status icon ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon box
              SizedBox(
                width: 48.w,
                height: 48.w,
                child: Image.asset(
                  'assets/images/request.png',
                  width: 20.sp,
                  height: 20.sp,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 12.w),

              // Title + subtitle + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      request.subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                    // Extended description for readyToSign / completed
                    if (request.status != RequestStatus.processing) ...[
                      SizedBox(height: 4.h),
                      Text(
                        'Il tuo prezzo attuale è nel top 10% del mercato.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF555555),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(width: 8.w),
              // Status icon (top right)
              _buildStatusIcon(request.status),
            ],
          ),

          SizedBox(height: 10.h),

          // ── Bottom row: status chip + date ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(request.status),
              Text(
                request.date,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF9810FA),
                ),
              ),
            ],
          ),


          // ── "View Alternatives" button for readyToSign ──
          if (request.status == RequestStatus.readyToSign) ...[
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 38.h,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(()=>RequestDetailsScreen());
                },


                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE9D4FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Visualizza Alternative',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9810FA),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(RequestStatus status) {
    switch (status) {
      case RequestStatus.processing:
        return _chip(
          label: 'In elaborazione',
          bg: const Color(0xFFFFF3E0),
          fg: const Color(0xFFDFB400),
        );
      case RequestStatus.readyToSign:
        return _chip(
          label: '↘ Offerta Competitiva Trovata',
          bg: const Color(0xFFDCFCE7),
          fg: const Color(0xFF008236),
        );
      case RequestStatus.completed:
        return _chip(
          label: '✓ Contratto Confermato',
          bg: const Color(0xFFDBEAFE),
          fg: const Color(0xFF1447E6),
          icon: Icons.verified_outlined,
          iconColor: const Color(0xFF1565C0),
        );
    }
  }

  Widget _chip({
    required String label,
    required Color bg,
    required Color fg,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: iconColor),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.processing:
        return Image.asset(
          'assets/images/process.png',
          width: 20.sp,
          height: 20.sp,
          fit: BoxFit.contain,
        );
      case RequestStatus.readyToSign:
        return Image.asset(
          'assets/images/doc.png',
          width: 20.sp,
          height: 20.sp,
          fit: BoxFit.contain,
        );
      case RequestStatus.completed:
        return Image.asset(
          'assets/images/doc.png',
          width: 20.sp,
          height: 20.sp,
          fit: BoxFit.contain,
        );
    }
  }
}