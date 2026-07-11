import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/features/bills/models/bill_model.dart';
import 'package:vyzi/features/bills/models/bill_analysis_model.dart';

class BillDetailScreen extends StatefulWidget {
  final String billId;

  const BillDetailScreen({super.key, required this.billId});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String _error = '';
  BillModel? _bill;

  bool _isLoadingAnalysis = false;
  String _analysisError = '';
  BillAnalysisModel? _analysis;

  @override
  void initState() {
    super.initState();
    _fetchBillDetails();
  }

  Future<void> _fetchBillDetails() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final url = ApiConstants.getMyBillDetails
          .replaceAll('{{billId}}', widget.billId);
      final response = await _api.get(url);
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        _bill = BillModel.fromJson(body['data'] as Map<String, dynamic>);
        // If analysis is included in the response, use it
        if (_bill?.analysis != null) {
          _analysis = _bill!.analysis;
        }
      } else {
        _error = body['message']?.toString() ??
            'Impossibile caricare la bolletta';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchBillAnalysis() async {
    setState(() {
      _isLoadingAnalysis = true;
      _analysisError = '';
    });

    try {
      final url = ApiConstants.getBillAnalysis
          .replaceAll('{{billId}}', widget.billId);
      final response = await _api.get(url);
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        _analysis = BillAnalysisModel.fromJson(
            body['data'] as Map<String, dynamic>);
      } else {
        _analysisError =
            body['message']?.toString() ?? 'Analisi non trovata';
      }
    } catch (e) {
      _analysisError = e.toString();
    } finally {
      if (mounted) setState(() => _isLoadingAnalysis = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _fetchBillDetails,
                        child: Text('common.retry'.tr),
                      ),
                    ],
                  ),
                )
              : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child:
              Icon(Icons.chevron_left, color: AppColors.textDark, size: 28),
        ),
      ),
      title: Text(
        'bills.detail.title'.tr,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildContent() {
    final bill = _bill!;

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      children: [
        _supplierCard(bill),
        SizedBox(height: 14.h),
        _statusBanner(bill),
        SizedBox(height: 14.h),
        _billInfoSection(bill),
        SizedBox(height: 14.h),
        if (_analysis != null) ...[
          _analysisSection(_analysis!),
        ] else if (bill.status == 'analyzed') ...[
          _loadAnalysisButton(),
        ],
      ],
    );
  }

  // ── Supplier Card ──
  Widget _supplierCard(BillModel bill) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1.2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A0A4C), Color(0xFF3A1F8C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(bill.billTypeIcon, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bill.supplierName,
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(bill.billTypeDisplay,
                    style: const TextStyle(
                        color: AppColors.textMid,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: bill.statusBgColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              bill.statusDisplay,
              style: TextStyle(
                color: bill.statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Banner ──
  Widget _statusBanner(BillModel bill) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: bill.statusBgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            bill.status == 'analyzed'
                ? Icons.check_circle
                : bill.status == 'error'
                    ? Icons.error
                    : Icons.access_time,
            color: bill.statusColor,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            _statusMessage(bill.status),
            style: AppStyles.body3.copyWith(
              color: bill.statusColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _statusMessage(String status) {
    switch (status) {
      case 'uploaded':
        return 'bills.detail.status_uploaded'.tr;
      case 'analyzing':
        return 'bills.detail.status_analyzing'.tr;
      case 'analyzed':
        return 'bills.detail.status_analyzed'.tr;
      case 'error':
        return 'bills.detail.status_error'.tr;
      default:
        return status;
    }
  }

  // ── Bill Info Section ──
  Widget _billInfoSection(BillModel bill) {
    final rows = <_DetailRowData>[
      _DetailRowData('bills.detail.bill_type'.tr, bill.billTypeDisplay),
      _DetailRowData('bills.detail.status'.tr, bill.statusDisplay),
      if (bill.billType == 'electricity' && bill.podNumber != null)
        _DetailRowData('bills.detail.pod_number'.tr, bill.podNumber!),
      if (bill.billType == 'gas' && bill.pdrNumber != null)
        _DetailRowData('bills.detail.pdr_number'.tr, bill.pdrNumber!),
      _DetailRowData('bills.detail.billing_period'.tr, bill.billingPeriodDisplay),
      _DetailRowData('bills.detail.total_amount'.tr, bill.totalAmountDisplay),
      _DetailRowData('bills.detail.consumption'.tr, bill.consumptionDisplay),
      if (bill.costPerUnit != null)
        _DetailRowData('bills.detail.cost_per_unit'.tr, bill.costPerUnitDisplay),
      if (bill.fixedCharges != null)
        _DetailRowData('bills.detail.fixed_charges'.tr, bill.fixedChargesDisplay),
      if (bill.taxes != null)
        _DetailRowData('bills.detail.taxes'.tr, bill.taxesDisplay),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('bills.detail.info'.tr,
            style: AppStyles.h4.copyWith(fontSize: 16.sp)),
        SizedBox(height: 10.h),
        ...rows.map((row) => _detailRow(row)),
      ],
    );
  }

  Widget _detailRow(_DetailRowData row) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 2.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        row.label,
                        style: TextStyle(
                          color: AppColors.textDarkest,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.arrow_forward,
                        size: 13.sp, color: AppColors.textLight),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                flex: 5,
                child: Text(
                  row.value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.divider, height: 1.2),
      ],
    );
  }

  // ── Analysis Section ──
  Widget _analysisSection(BillAnalysisModel analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('bills.detail.analysis'.tr,
            style: AppStyles.h4.copyWith(fontSize: 16.sp)),
        SizedBox(height: 14.h),
        // Savings card
        _savingsCard(analysis),
        SizedBox(height: 14.h),
        // Analysis details
        _detailRow(_DetailRowData(
            'bills.detail.monthly_avg'.tr, analysis.currentMonthlyAvgDisplay)),
        _detailRow(_DetailRowData('bills.detail.recommended_market'.tr,
            analysis.recommendedMarketTypeDisplay)),
        _detailRow(_DetailRowData(
            'bills.detail.confidence_score'.tr, analysis.confidenceDisplay)),
        // Analysis summary
        if (analysis.analysisSummary != null &&
            analysis.analysisSummary!.isNotEmpty) ...[
          SizedBox(height: 14.h),
          Text('bills.detail.analysis_summary'.tr,
              style: AppStyles.h4.copyWith(fontSize: 14.sp)),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFF),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              analysis.analysisSummary!,
              style: AppStyles.body3.copyWith(height: 1.6),
            ),
          ),
        ],
        // Recommended offers
        if (analysis.recommendedOffers.isNotEmpty) ...[
          SizedBox(height: 14.h),
          Text('bills.detail.recommended_offers'.tr,
              style: AppStyles.h4.copyWith(fontSize: 14.sp)),
          SizedBox(height: 8.h),
          ...analysis.recommendedOffers
              .map((offer) => _recommendedOfferCard(offer)),
        ],
      ],
    );
  }

  Widget _savingsCard(BillAnalysisModel analysis) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B2FB9), Color(0xFF7B5FE9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Text(
            'bills.detail.potential_savings'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            analysis.potentialSavingsDisplay,
            style: TextStyle(
              color: Colors.white,
              fontSize: 46.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 1.0,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'bills.detail.estimated_annual'.tr,
            style: TextStyle(
              color: AppColors.green,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendedOfferCard(RecommendedOfferModel offer) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFB396E1), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFB),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              offer.isGreenEnergy ? Icons.eco : Icons.bolt,
              color: AppColors.purple,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.name,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  offer.supplierName ?? '',
                  style: TextStyle(
                    color: AppColors.textMid,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (offer.estimatedSavings != null)
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                offer.estimatedSavingsDisplay,
                style: TextStyle(
                  color: const Color(0xFF008236),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Load Analysis Button ──
  Widget _loadAnalysisButton() {
    if (_isLoadingAnalysis) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      ));
    }

    if (_analysisError.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            Text(_analysisError,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.error, fontSize: 13.sp)),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: _fetchBillAnalysis,
              child: Text('common.retry'.tr),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: OutlinedButton.icon(
          onPressed: _fetchBillAnalysis,
          icon: Icon(Icons.analytics_outlined, size: 20.sp),
          label: Text(
            'bills.detail.view_analysis'.tr,
            style: AppStyles.body2.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF9810FA),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF5A1ABE)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRowData {
  final String label;
  final String value;
  const _DetailRowData(this.label, this.value);
}
