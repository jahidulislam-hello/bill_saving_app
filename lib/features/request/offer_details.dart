import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/request/complete_request/complete_request_screen.dart';
import 'package:vyzi/features/request/models/api_offer_model.dart';
import 'package:vyzi/features/request/price_calculation_dialog.dart';
import 'package:vyzi/features/request/price_type_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferDetailRow {
  final String label;
  final String value;
  final String? linkText;
  final Color linkColor;

  const OfferDetailRow({
    required this.label,
    required this.value,
    this.linkText,
    this.linkColor = AppColors.linkBlue,
  });
}

// ─────────────────────────────────────────────
// SCREEN 1 – OFFER DETAILS
// ─────────────────────────────────────────────
class OfferDetailsScreen extends StatefulWidget {
  final String offerId;
  final double? estimatedSavings;

  const OfferDetailsScreen({
    super.key,
    required this.offerId,
    this.estimatedSavings,
  });

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String _error = '';
  ApiOfferModel? _offer;

  @override
  void initState() {
    super.initState();
    _fetchOfferDetails();
  }

  Future<void> _fetchOfferDetails() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final url = ApiConstants.getOfferDetails
          .replaceAll('{{offerId}}', widget.offerId);
      final response = await _api.get(url);
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        _offer = ApiOfferModel.fromJson(body['data'] as Map<String, dynamic>);
      } else {
        _error = body['message']?.toString() ?? 'Failed to load offer';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<OfferDetailRow> _buildDetailRows(ApiOfferModel offer) {
    return [
      OfferDetailRow(
        label: 'offer.contract_term'.tr,
        value: offer.bindingDisplay,
      ),
      OfferDetailRow(
        label: 'offer.price_type'.tr,
        value: offer.marketTypeDisplay,
        linkText: 'offer.price_type_link'.tr,
        linkColor: AppColors.linkBlue,
      ),
      OfferDetailRow(
        label: 'offer.energy_price'.tr,
        value: offer.energyPriceDisplay,
        linkText: 'offer.energy_price_link'.tr,
        linkColor: AppColors.linkGreen,
      ),
      OfferDetailRow(
        label: 'offer.fixed_costs'.tr,
        value: '${offer.fixedMonthlyFee.toStringAsFixed(0)} €/mese',
      ),
      OfferDetailRow(
        label: 'offer.contract_duration'.tr,
        value: offer.contractDurationDisplay,
      ),
    ];
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
                          style: const TextStyle(color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _fetchOfferDetails,
                        child: Text('common.retry'.tr),
                      ),
                    ],
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final offer = _offer!;
    final detailRows = _buildDetailRows(offer);

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 100 + MediaQuery.of(context).padding.bottom),
          children: [
            _supplierCard(offer),
            const SizedBox(height: 14),
            _savingsCard(offer),
            const SizedBox(height: 6),
            ...detailRows.map((row) => _detailRow(row)),
            const SizedBox(height: 10),
            _economicConditionsCard(offer),
            const SizedBox(height: 16),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).padding.bottom,
          child: _bottomButton(),
        ),
      ],
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
          child: Icon(Icons.chevron_left, color: AppColors.textDark, size: 28),
        ),
      ),
      title: Text(
        'offer.details_title'.tr,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OfferInfoScreen()),
          ),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 24,
            height: 24,
            child: const Icon(Icons.info_outline, color: AppColors.textDark, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _supplierCard(ApiOfferModel offer) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1.2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildLogo(offer.supplier?.logoUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.supplier?.name ?? offer.name,
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(offer.name,
                    style: const TextStyle(
                        color: AppColors.textMid,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(String? logoUrl) {
    if (logoUrl != null && logoUrl.isNotEmpty) {
      return Image.network(
        logoUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _defaultLogo(),
      );
    }
    return _defaultLogo();
  }

  Widget _defaultLogo() {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0A4C), Color(0xFF3A1F8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(Icons.bolt, color: Colors.white, size: 24),
    );
  }

  Widget _savingsCard(ApiOfferModel offer) {
    final savings = widget.estimatedSavings ?? offer.estimatedSavings;
    if (savings == null || savings <= 0) return const SizedBox.shrink();
    final savingsDisplay = '€${savings.toStringAsFixed(2).replaceAll('.', ',')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B2FB9), Color(0xFF7B5FE9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            'offer.max_benefit'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            savingsDisplay,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'request.offer.annual_savings'.tr,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLinkTap(String text) {
    if (text == 'offer.price_type_link'.tr) {
      showDialog(
        context: context,
        builder: (_) => const PriceTypeSheet(),
      );
    } else if (text == 'offer.energy_price_link'.tr) {
      showDialog(
        context: context,
        builder: (_) => const PriceCalculationDialog(),
      );
    }
  }

  Widget _detailRow(OfferDetailRow row) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 2),
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
                        style: const TextStyle(
                          color: AppColors.textDarkest,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward,
                        size: 13, color: AppColors.textLight),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      row.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                    if (row.linkText != null) ...[
                      const SizedBox(height: 3),
                      GestureDetector(
                        onTap: () => _handleLinkTap(row.linkText!),
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          row.linkText!,
                          style: TextStyle(
                            color: row.linkColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.divider, height: 1.2),
      ],
    );
  }

  Widget _economicConditionsCard(ApiOfferModel offer) {
    return GestureDetector(
      onTap: () {
        if (offer.termsUrl != null && offer.termsUrl!.isNotEmpty) {
          // Could open URL in browser
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB396E1), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EEFB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.description_outlined,
                  color: AppColors.purple, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'offer.economic_conditions'.tr,
                style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textLight, size: 22),
          ],
        ),
      ),
    );
  }


  Widget _bottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
      decoration: BoxDecoration(
        color: AppColors.bg,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => CompleteRequestScreen(offer: _offer!));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Text(
            'offer.select_offer'.tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 2 – OFFER INFO
// ─────────────────────────────────────────────
class OfferInfoScreen extends StatefulWidget {
  const OfferInfoScreen({super.key});

  @override
  State<OfferInfoScreen> createState() => _OfferInfoScreenState();
}

class _OfferInfoScreenState extends State<OfferInfoScreen> {
  final Set<int> _expandedFAQ = {};

  List<(String, String)> get _features => [
    ('offer.feature1_title'.tr, 'offer.feature1_desc'.tr),
    ('offer.feature2_title'.tr, 'offer.feature2_desc'.tr),
    ('offer.feature3_title'.tr, 'offer.feature3_desc'.tr),
    ('offer.feature4_title'.tr, 'offer.feature4_desc'.tr),
  ];

  List<(String, String)> get _faqs => [
    ('offer.faq1_q'.tr, 'offer.faq1_a'.tr),
    ('offer.faq2_q'.tr, 'offer.faq2_a'.tr),
    ('offer.faq3_q'.tr, 'offer.faq3_a'.tr),
    ('offer.faq4_q'.tr, 'offer.faq4_a'.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 14 + MediaQuery.of(context).padding.bottom),
        children: [
          _whatsIncludedCard(),
          const SizedBox(height: 20),
          _aboutCard(),
          const SizedBox(height: 20),
          _faqSection(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.chevron_left, color: AppColors.textDark, size: 28),
        ),
      ),
      title: Text(
        'offer.info_title'.tr,
        style: const TextStyle(
            color: AppColors.textDark, fontSize: 17, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _whatsIncludedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('offer.whats_included'.tr,
              style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          ..._features.map((f) => _featureItem(f.$1, f.$2)),
        ],
      ),
    );
  }

  Widget _featureItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle,
                color: AppColors.green, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textMid,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('offer.about_supplier_name'.tr,
              style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text(
            'offer.supplier_description'.tr,
            style: const TextStyle(
                color: AppColors.textMid,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.65),
          ),
        ],
      ),
    );
  }

  Widget _faqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('offer.faq_title'.tr,
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        ...List.generate(_faqs.length, (i) {
          final isExpanded = _expandedFAQ.contains(i);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedFAQ.remove(i);
                        } else {
                          _expandedFAQ.add(i);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_faqs[i].$1,
                                style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ),
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(Icons.keyboard_arrow_down,
                                size: 24, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(_faqs[i].$2,
                          style: const TextStyle(
                              color: AppColors.textMid,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.6)),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
