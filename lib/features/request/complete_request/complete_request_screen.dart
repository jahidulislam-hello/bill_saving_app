import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/bills/models/bill_model.dart';
import 'package:vyzi/features/request/models/api_offer_model.dart';
import 'complete_request_controller.dart';

class CompleteRequestScreen extends StatefulWidget {
  final ApiOfferModel offer;
  final BillModel? bill;

  const CompleteRequestScreen({
    super.key,
    required this.offer,
    this.bill,
  });

  @override
  State<CompleteRequestScreen> createState() => _CompleteRequestScreenState();
}

class _CompleteRequestScreenState extends State<CompleteRequestScreen> {
  late final CompleteRequestController _c;
  final ImagePicker _picker = ImagePicker();

  // ── Personal Info edit ──
  bool _editingPersonalInfo = false;
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _podCtrl;

  // ── Supply Address edit ──
  bool _editingAddress = false;
  late TextEditingController _streetCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _zipCtrl;
  String? _supplyProvince;

  // ── Residential Address (when "No, it's different") ──
  bool _residentialAddressConfirmed = false;
  late TextEditingController _resStreetCtrl;
  late TextEditingController _resCityCtrl;
  late TextEditingController _resZipCtrl;
  String? _resStreetError;
  String? _resCityError;
  String? _resZipError;
  String? _resProvinceError;

  // ── Payment Method extras ──
  bool _ibanSameAsContract = true;
  final TextEditingController _holderFirstCtrl = TextEditingController();
  final TextEditingController _holderLastCtrl = TextEditingController();
  final TextEditingController _holderTaxCtrl = TextEditingController();

  // ── Invoice Delivery extras ──
  late TextEditingController _invoiceEmailCtrl;
  InvoiceAddressMatch? _invoiceAddressMatch;
  final TextEditingController _invStreetCtrl = TextEditingController();
  final TextEditingController _invCityCtrl = TextEditingController();
  final TextEditingController _invNumberCtrl = TextEditingController();
  final TextEditingController _invProvinceCtrl = TextEditingController();
  String? _invZipProvince;

  bool _profileSynced = false;

  // ── Personal Info validation errors ──
  String? _firstNameError;
  String? _lastNameError;
  String? _podError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _c = CompleteRequestController(
      offer: widget.offer,
      bill: widget.bill,
    );
    _c.addListener(_onControllerUpdate);

    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _podCtrl = TextEditingController();
    _streetCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _zipCtrl = TextEditingController();
    _invoiceEmailCtrl = TextEditingController();
    _resStreetCtrl = TextEditingController();
    _resCityCtrl = TextEditingController();
    _resZipCtrl = TextEditingController();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    // Sync text controllers once profile data arrives
    if (!_profileSynced && !_c.isLoadingProfile && _c.firstName.isNotEmpty) {
      _profileSynced = true;
      _firstNameCtrl.text = _c.firstName;
      _lastNameCtrl.text = _c.lastName;
      _emailCtrl.text = _c.email;
      _phoneCtrl.text = _c.phone;
      _podCtrl.text = _c.podNumber;
      _invoiceEmailCtrl.text = _c.email;
      _holderFirstCtrl.text = _c.firstName;
      _holderLastCtrl.text = _c.lastName;
      _holderTaxCtrl.text = _c.taxCode;
    }
    // Sync POD number when bill data arrives (may arrive after profile sync)
    if (_podCtrl.text.isEmpty && _c.podNumber.isNotEmpty) {
      _podCtrl.text = _c.podNumber;
    }
    // Sync address when bill data arrives
    if (_streetCtrl.text.isEmpty && _c.address.isNotEmpty) {
      _streetCtrl.text = _c.address;
    }
    if (_cityCtrl.text.isEmpty && _c.city.isNotEmpty) {
      _cityCtrl.text = _c.city;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _c.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _podCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    _holderFirstCtrl.dispose();
    _holderLastCtrl.dispose();
    _holderTaxCtrl.dispose();
    _invoiceEmailCtrl.dispose();
    _invStreetCtrl.dispose();
    _invCityCtrl.dispose();
    _invNumberCtrl.dispose();
    _invProvinceCtrl.dispose();
    _resStreetCtrl.dispose();
    _resCityCtrl.dispose();
    _resZipCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: _c.isLoadingProfile
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOfferCard(),
                  _gap(),
                  _buildPersonalInfoCard(),
                  _gap(),
                  _buildSupplyAddressCard(),
                  _gap(),
                  _buildIdentityVerificationCard(),
                  _gap(),
                  _buildPaymentMethodCard(),
                  _gap(),
                  _buildInvoiceDeliveryCard(),
                  _gap(),
                  _buildAlmostThereCard(),
                  if (_c.bill == null && !_c.isLoadingBill) ...[
                    SizedBox(height: 12.h),
                    _buildNoBillWarning(),
                  ],
                  SizedBox(height: 16.h),
                  _buildActivateButton(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
      ),
    );
  }

  SizedBox _gap() => SizedBox(height: 16.h);

  // ─────────────────────────────────────────────
  //  APPBAR
  // ─────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded,
            color: AppColors.textDark, size: 22.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'request.form.complete_request_title'.tr,
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
          height: 1.22,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  OFFER CARD
  // ─────────────────────────────────────────────

  Widget _buildOfferCard() {
    final offer = widget.offer;
    final supplierLogo = offer.supplier?.logoUrl;
    final baseUrl = ApiConstants.baseUrl;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: supplierLogo != null && supplierLogo.isNotEmpty
                    ? Image.network(
                        supplierLogo.startsWith('http')
                            ? supplierLogo
                            : '$baseUrl$supplierLogo',
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _offerIconFallback(),
                      )
                    : _offerIconFallback(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(offer.name,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                            height: 1.22)),
                    Text(offer.supplier?.name ?? offer.marketTypeDisplay,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textPrimary,
                            height: 1.22)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(offer.energyPriceDisplay,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w400,
                    height: 1.22)),
          ),
          SizedBox(height: 10.h),
          _buildInfoRow(Icons.credit_card_outlined, AppColors.accentBlue,
              'request.form.payment_method_info'.tr),
          SizedBox(height: 7.h),
          _buildInfoRow(Icons.check_circle_outline, AppColors.primary400,
              '${offer.contractDurationDisplay} · ${offer.target == 'business' ? 'Business' : 'Residenziale'}'),
          SizedBox(height: 12.h),
          _dividerLine(),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text('€${offer.fixedMonthlyFee.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.green200,
                      height: 1.22)),
              SizedBox(width: 8.w),
              Text('/mese',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                      height: 1.22)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _offerIconFallback() {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: AppColors.primary300,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(Icons.bolt, color: AppColors.background, size: 24.sp),
    );
  }

  Widget _buildInfoRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, size: 15.sp, color: color),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  PERSONAL INFORMATION
  // ─────────────────────────────────────────────

  Widget _buildPersonalInfoCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle('request.form.personal_info_title'.tr),
              GestureDetector(
                onTap: () {
                  if (_editingPersonalInfo) {
                    // Validate required fields
                    final firstNameOk = _firstNameCtrl.text.trim().isNotEmpty;
                    final lastNameOk = _lastNameCtrl.text.trim().isNotEmpty;
                    final podOk = _podCtrl.text.trim().isNotEmpty;
                    final phoneOk = _phoneCtrl.text.trim().isNotEmpty;

                    setState(() {
                      _firstNameError = firstNameOk ? null : 'request.form.first_name_required'.tr;
                      _lastNameError = lastNameOk ? null : 'request.form.last_name_required'.tr;
                      _podError = podOk ? null : 'request.form.pod_number_required'.tr;
                      _phoneError = phoneOk ? null : 'request.form.phone_required'.tr;
                    });

                    if (!firstNameOk || !lastNameOk || !podOk || !phoneOk) return;

                    _c.firstName = _firstNameCtrl.text.trim();
                    _c.lastName = _lastNameCtrl.text.trim();
                    _c.phone = _phoneCtrl.text.trim();
                    _c.podNumber = _podCtrl.text.trim();
                  } else {
                    // Entering edit mode — clear errors
                    setState(() {
                      _firstNameError = null;
                      _lastNameError = null;
                      _podError = null;
                      _phoneError = null;
                    });
                  }
                  setState(() => _editingPersonalInfo = !_editingPersonalInfo);
                },
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: _editingPersonalInfo
                        ? AppColors.linkGreen
                        : AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _editingPersonalInfo
                            ? Icons.check_rounded
                            : Icons.edit_rounded,
                        color: AppColors.background,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _editingPersonalInfo ? 'common.save'.tr : 'request.form.edit'.tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.background,
                            fontWeight: FontWeight.w600,
                            height: 1.22),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          if (_editingPersonalInfo) ...[
            _buildEditField('request.form.first_name_field'.tr, _firstNameCtrl,
                errorText: _firstNameError,
                onChanged: (_) => setState(() => _firstNameError = null)),
            SizedBox(height: 10.h),
            _buildEditField('request.form.last_name_field'.tr, _lastNameCtrl,
                errorText: _lastNameError,
                onChanged: (_) => setState(() => _lastNameError = null)),
            SizedBox(height: 10.h),
            _buildEditField('request.form.email_field'.tr, _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                readOnly: true),
            SizedBox(height: 10.h),
            _buildEditField('request.form.pod_number_field'.tr, _podCtrl,
                errorText: _podError,
                onChanged: (_) => setState(() => _podError = null)),
            SizedBox(height: 10.h),
            _buildEditField('request.form.phone_field'.tr, _phoneCtrl,
                keyboardType: TextInputType.phone,
                errorText: _phoneError,
                onChanged: (_) => setState(() => _phoneError = null)),
          ] else ...[
            _personalRow('request.form.first_name_field'.tr, _c.firstName),
            _personalRow('request.form.last_name_field'.tr, _c.lastName),
            _personalRow('request.form.email_field'.tr, _c.email),
            _personalRow('request.form.phone_field'.tr, _c.phone),
            _personalRow('request.form.pod_number_field'.tr, _c.podNumber),
          ],
        ],
      ),
    );
  }

  Widget _buildEditField(
      String label,
      TextEditingController ctrl, {
        TextInputType keyboardType = TextInputType.text,
        String? errorText,
        bool readOnly = false,
        ValueChanged<String>? onChanged,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                height: 1.22)),
        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            color: readOnly ? AppColors.primary50 : AppColors.shortcardbg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: errorText != null ? AppColors.error : AppColors.shortcardbg,
              width: 1,
            ),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onChanged: onChanged,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                fontSize: 13.sp,
                color: readOnly ? AppColors.textSecondary : AppColors.textDark,
                fontWeight: FontWeight.w500,
                height: 1.22),
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 4.w),
            child: Text(errorText,
                style: TextStyle(fontSize: 11.sp, color: AppColors.error, height: 1.22)),
          ),
      ],
    );
  }

  Widget _personalRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label,
                style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                    height: 1.22)),
          ),
          Expanded(
            flex: 6,
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                    height: 1.22)),
          ),
        ],
      ),
    );
  }

  Widget _dividerLine() =>
      Divider(height: 1, thickness: 1, color: AppColors.divider);

  // ─────────────────────────────────────────────
  //  SUPPLY ADDRESS
  // ─────────────────────────────────────────────

  Widget _buildSupplyAddressCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('request.form.delivery_address'.tr),
          SizedBox(height: 2.h),
          Text('request.form.readonly_summary'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
          SizedBox(height: 12.h),

          // ── Address box ──
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined,
                    color: AppColors.primaryColor, size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_c.address,
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                              height: 1.22)),
                      SizedBox(height: 2.h),
                      Text(_c.city,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textPrimary,
                              height: 1.22)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      setState(() => _editingAddress = !_editingAddress),
                  child: Icon(Icons.edit_outlined,
                      color: _editingAddress
                          ? AppColors.primaryColor
                          : AppColors.textDark,
                      size: 18.sp),
                ),
              ],
            ),
          ),

          // ── Inline address edit form ──
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _editingAddress
                ? Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: _buildAddressEditForm(),
            )
                : const SizedBox.shrink(),
          ),

          SizedBox(height: 14.h),

          Text(
              'request.form.residential_matches_delivery'.tr,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.4)),
          SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                  child: _addressOption('request.form.address_yes_same'.tr, AddressMatch.same)),
              SizedBox(width: 10.w),
              Expanded(
                  child: _addressOption(
                      'request.form.address_no_different'.tr, AddressMatch.different)),
            ],
          ),

          // ── New residential form when "No" ──
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _c.addressMatch == AddressMatch.different
                ? Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: _buildNewResidentialForm(),
            )
                : const SizedBox.shrink(),
          ),

          if (_c.addressMatch == AddressMatch.different) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_residentialAddressConfirmed) {
                    // Switch to edit mode
                    setState(() => _residentialAddressConfirmed = false);
                  } else {
                    // Validate before confirming
                    final streetOk = _resStreetCtrl.text.trim().isNotEmpty;
                    final cityOk = _resCityCtrl.text.trim().isNotEmpty;
                    final zipOk = _resZipCtrl.text.trim().isNotEmpty;
                    final provinceOk = _supplyProvince != null;

                    setState(() {
                      _resStreetError = streetOk ? null : 'request.form.street_required'.tr;
                      _resCityError = cityOk ? null : 'request.form.city_required'.tr;
                      _resZipError = zipOk ? null : 'request.form.zip_required'.tr;
                      _resProvinceError = provinceOk ? null : 'request.form.province_required'.tr;
                    });

                    if (streetOk && cityOk && zipOk && provinceOk) {
                      // Sync to controller
                      _c.residentialStreet = _resStreetCtrl.text.trim();
                      _c.residentialCity = _resCityCtrl.text.trim();
                      _c.residentialZip = _resZipCtrl.text.trim();
                      _c.residentialProvince = _supplyProvince!;
                      setState(() => _residentialAddressConfirmed = true);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _residentialAddressConfirmed
                      ? AppColors.primary300
                      : AppColors.primaryColor,
                  foregroundColor: AppColors.background,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  _residentialAddressConfirmed
                      ? 'request.form.edit'.tr
                      : 'common.confirm'.tr,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.22),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressEditForm() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('request.form.delivery_address'.tr,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      height: 1.22)),
              GestureDetector(
                onTap: () {
                  _c.address = _streetCtrl.text;
                  _c.city = _cityCtrl.text;
                  setState(() => _editingAddress = false);
                },
                child: Row(
                  children: [
                    Icon(Icons.check_rounded,
                        color: AppColors.linkGreen, size: 14.sp),
                    SizedBox(width: 3.w),
                    Text('common.save'.tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.linkGreen,
                            fontWeight: FontWeight.w600,
                            height: 1.22)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text('request.form.address'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
          SizedBox(height: 6.h),
          _addressTextField(_streetCtrl, hint: '123 Main Street'),
          SizedBox(height: 10.h),
          Text('request.form.city'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
          SizedBox(height: 6.h),
          _addressTextField(_cityCtrl, hint: 'Milano'),
          SizedBox(height: 10.h),
          Text('request.form.zip_code'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
          SizedBox(height: 6.h),
          _addressTextField(_zipCtrl,
              hint: '20100', keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _buildNewResidentialForm() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.yellowAlpha10,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.yellow100, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: AppColors.yellow200, size: 14.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'request.form.no_selection_info'.tr,
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textDark,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Text('request.form.new_residential_address'.tr,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.22)),
          SizedBox(height: 12.h),
          Text('request.form.street_number'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
          SizedBox(height: 6.h),
          _addressTextField(_resStreetCtrl,
              hint: 'Esempio: Via delle Rose 10',
              readOnly: _residentialAddressConfirmed),
          if (_resStreetError != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 4.w),
              child: Text(_resStreetError!,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.error, height: 1.22)),
            ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('request.form.city'.tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textPrimary,
                            height: 1.22)),
                    SizedBox(height: 6.h),
                    _addressTextField(_resCityCtrl,
                        hint: 'Milano',
                        readOnly: _residentialAddressConfirmed),
                    if (_resCityError != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, left: 4.w),
                        child: Text(_resCityError!,
                            style: TextStyle(fontSize: 11.sp, color: AppColors.error, height: 1.22)),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('request.form.zip_code'.tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textPrimary,
                            height: 1.22)),
                    SizedBox(height: 6.h),
                    _addressTextField(_resZipCtrl,
                        hint: '20100',
                        keyboardType: TextInputType.number,
                        readOnly: _residentialAddressConfirmed),
                    if (_resZipError != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, left: 4.w),
                        child: Text(_resZipError!,
                            style: TextStyle(fontSize: 11.sp, color: AppColors.error, height: 1.22)),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text('request.form.province'.tr,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textPrimary,
                      height: 1.22)),
              Text(' *',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.error,
                      height: 1.22)),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.shortcardbg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.shortcardbg, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _supplyProvince,
                  hint: Text('request.form.select_province'.tr,
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                          height: 1.22)),
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textDark, size: 20.sp),
                  items: const [
                    'Milano', 'Roma', 'Napoli', 'Torino',
                    'Palermo', 'Genova', 'Bologna', 'Firenze',
                  ]
                      .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p,
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textDark,
                            height: 1.22)),
                  ))
                      .toList(),
                  onChanged: _residentialAddressConfirmed
                      ? null
                      : (v) => setState(() {
                          _supplyProvince = v;
                          _resProvinceError = null;
                        }),
                ),
              ),
            ),
          ),
          if (_resProvinceError != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 4.w),
              child: Text(_resProvinceError!,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.error, height: 1.22)),
            ),
        ],
      ),
    );
  }

  Widget _addressTextField(
      TextEditingController ctrl, {
        String hint = '',
        TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.shortcardbg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.shortcardbg, width: 1),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        readOnly: readOnly,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            fontSize: 13.sp,
            color: readOnly ? AppColors.textSecondary : AppColors.textDark,
            fontWeight: FontWeight.w500,
            height: 1.22),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
          TextStyle(fontSize: 13.sp, color: AppColors.textSecondary, height: 1.22),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _addressOption(String label, AddressMatch match) {
    final isSelected = _c.addressMatch == match;
    return GestureDetector(
      onTap: () {
        _c.selectAddressMatch(match);
        setState(() {
          _residentialAddressConfirmed = false;
          _resStreetError = null;
          _resCityError = null;
          _resZipError = null;
          _resProvinceError = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary100
              : AppColors.background,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.divider,
            width: 1.22,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textDark,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.circle, color: AppColors.background, size: 8.sp)
                  : null,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.textPrimary,
                      height: 1.22)),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  IDENTITY VERIFICATION
  // ─────────────────────────────────────────────

  Widget _buildIdentityVerificationCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle('request.form.identity_verification_title'.tr),
              if (_c.uploadedDocuments.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: AppColors.linkGreen, size: 14.sp),
                    SizedBox(width: 3.w),
                    Text('Uploaded',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.linkGreen,
                            fontWeight: FontWeight.w600,
                            height: 1.22)),
                  ],
                )
              else
                Row(
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: Colors.red.shade400, size: 14.sp),
                    SizedBox(width: 3.w),
                    Text('request.form.required'.tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.w600,
                            height: 1.22)),
                  ],
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
              'request.form.id_document_instruction'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.5)),
          SizedBox(height: 14.h),
          if (_c.isUploading)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('Uploading...',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textPrimary,
                          height: 1.22)),
                ],
              ),
            ),
          if (_c.uploadedDocuments.isNotEmpty) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: _c.uploadedDocuments.asMap().entries.map((e) {
                final doc = e.value;
                final name = doc.fileName;
                return Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.greenAlpha10,
                    borderRadius: BorderRadius.circular(20.r),
                    border:
                    Border.all(color: AppColors.linkGreen, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.insert_drive_file_outlined,
                          size: 12.sp, color: AppColors.linkGreen),
                      SizedBox(width: 4.w),
                      Text(
                        name.length > 16 ? '${name.substring(0, 16)}...' : name,
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.linkGreen,
                            height: 1.22),
                      ),
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: () => _c.removeDocument(e.key),
                        child: Icon(Icons.close_rounded,
                            size: 12.sp, color: AppColors.linkGreen),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10.h),
          ],
          _buildIdButton(
            icon: Icons.upload_rounded,
            label: 'request.form.upload_file_button'.tr,
            sublabel: 'request.form.upload_formats'.tr,
            canUpload: _c.uploadedDocuments.length < 3 && !_c.isUploading,
            onTap: _pickFile,
          ),
        ],
      ),
    );
  }

  Widget _buildIdButton({
    required IconData icon,
    required String label,
    required String sublabel,
    required bool canUpload,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: canUpload ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: canUpload ? AppColors.background : AppColors.primary50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: canUpload
                ? AppColors.primaryColor.withOpacity(0.3)
                : AppColors.divider,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 26.sp,
                color: canUpload
                    ? AppColors.primaryColor
                    : AppColors.textSecondary),
            SizedBox(height: 6.h),
            Text(label,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: canUpload
                        ? AppColors.textDark
                        : AppColors.textSecondary,
                    height: 1.22)),
            SizedBox(height: 2.h),
            Text(sublabel,
                style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                    height: 1.22)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file != null) await _c.uploadDocument(file.path);
    } catch (e) {
      debugPrint('File picker error: $e');
    }
  }


  // ─────────────────────────────────────────────
  //  PAYMENT METHOD
  // ─────────────────────────────────────────────

  Widget _buildPaymentMethodCard() {
    final isDirectDebit = _c.selectedPayment == PaymentMethod.directDebit;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('request.form.payment_method_title'.tr),
          SizedBox(height: 2.h),
          Text('request.form.payment_preference'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
          SizedBox(height: 12.h),

          // Full Name / Tax Code rows
          _personalRow('request.form.full_name_label'.tr, _c.fullName),
          _dividerLine(),
          _personalRow('request.form.tax_code_label'.tr, _c.taxCode),
          SizedBox(height: 14.h),

          // ── Payment options ──
          Text('request.form.choose_payment_method'.tr,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                  height: 1.22)),
          SizedBox(height: 10.h),
          _paymentOption(
            method: PaymentMethod.directDebit,
            title: 'request.payment.sdd_title'.tr,
            subtitle: 'request.payment.sdd_subtitle_full'.tr,
          ),
          SizedBox(height: 8.h),
          _paymentOption(
            method: PaymentMethod.postalOrder,
            title: 'request.payment.postal_bill_title'.tr,
            subtitle: 'request.payment.postal_bill_subtitle_full'.tr,
          ),

          // ── Direct Debit extras (only when directDebit selected) ──
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: isDirectDebit
                ? Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: _buildDirectDebitExtras(),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// SS-1: IBAN checkbox + Holder Information card
  Widget _buildDirectDebitExtras() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Yes, IBAN checkbox ──
        GestureDetector(
          onTap: () => setState(() {
            _ibanSameAsContract = !_ibanSameAsContract;
          }),
          child: Container(
            width: double.infinity,
            padding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: Row(
              children: [
                // checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: _ibanSameAsContract
                        ? AppColors.greenAlpha10
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: _ibanSameAsContract
                          ? AppColors.linkGreen
                          : AppColors.primaryColor,
                      width: 1,
                    ),
                  ),
                  child: _ibanSameAsContract
                      ? Icon(Icons.check_rounded,
                      size: 13.sp, color: AppColors.linkGreen)
                      : null,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'request.form.iban_same_as_contract'.tr,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                        height: 1.22),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Holder Information card — hidden when checkbox ticked ──
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          child: _ibanSameAsContract
              ? const SizedBox.shrink()
              : Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: _buildHolderInfoCard(),
          ),
        ),
      ],
    );
  }

  /// SS-1 bottom half: Holder Information editable card
  Widget _buildHolderInfoCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('request.form.holder_info'.tr,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      height: 1.22)),
              Row(
                children: [
                  Icon(Icons.check_rounded,
                      color: AppColors.linkGreen, size: 14.sp),
                  SizedBox(width: 3.w),
                  Text('common.save'.tr,
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.linkGreen,
                          fontWeight: FontWeight.w600,
                          height: 1.22)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildEditField('request.form.first_name'.tr, _holderFirstCtrl),
          SizedBox(height: 10.h),
          _buildEditField('request.form.last_name'.tr, _holderLastCtrl),
          SizedBox(height: 10.h),
          _buildEditField('request.form.tax_code_full'.tr, _holderTaxCtrl,
              keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _paymentOption({
    required PaymentMethod method,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _c.selectedPayment == method;
    return GestureDetector(
      onTap: () => _c.selectPayment(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary100
              : AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.divider,
            width: 1.22,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textDark,
                  width: 1.22,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, color: AppColors.background, size: 12.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                          height: 1.22)),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textPrimary,
                          height: 1.22)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  INVOICE DELIVERY METHOD
  // ─────────────────────────────────────────────

  Widget _buildInvoiceDeliveryCard() {
    final isDigital = _c.selectedInvoice == InvoiceMethod.digital;
    final isPaper = _c.selectedInvoice == InvoiceMethod.paper;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('request.form.invoice_delivery_title'.tr),
          SizedBox(height: 2.h),
          Text(
              'request.form.invoice_delivery_tip'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.5)),
          SizedBox(height: 12.h),

          _invoiceOption(
            method: InvoiceMethod.digital,
            title: 'request.invoice.digital_title'.tr,
            subtitle: 'request.invoice.digital_subtitle'.tr,
          ),
          SizedBox(height: 8.h),
          _invoiceOption(
            method: InvoiceMethod.paper,
            title: 'request.invoice.paper_title'.tr,
            subtitle: 'request.payment.postal_bill_subtitle_full'.tr,
          ),

          // ── Digital extras: pre-filled note + email field ──
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: isDigital
                ? Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: _buildDigitalInvoiceExtras(),
            )
                : const SizedBox.shrink(),
          ),

          // ── Paper extras: delivery address Yes/No + sub-forms ──
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: isPaper
                ? Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: _buildPaperInvoiceExtras(),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// SS-2: purple pre-filled note + email input
  Widget _buildDigitalInvoiceExtras() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Purple info chip
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: AppColors.primary100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'request.form.prefilled_email'.tr,
            style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
                height: 1.22),
          ),
        ),
        SizedBox(height: 12.h),

        // Email label + field
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${'request.form.email_for_invoice'.tr} ',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    height: 1.22),
              ),
               TextSpan(
                text: '*',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.error,
                    height: 1.22),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        _addressTextField(_invoiceEmailCtrl,
            hint: 'example@amail.com',
            keyboardType: TextInputType.emailAddress),
      ],
    );
  }

  /// SS-3/4/5: delivery address match question + sub-forms
  Widget _buildPaperInvoiceExtras() {
    final isYes = _invoiceAddressMatch == InvoiceAddressMatch.yes;
    final isNo = _invoiceAddressMatch == InvoiceAddressMatch.no;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('request.form.shipping_match_question'.tr,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
                height: 1.4)),
        SizedBox(height: 10.h),

        // Yes / No toggle
        Row(
          children: [
            Expanded(child: _invoiceAddressOption('request.form.yes'.tr, InvoiceAddressMatch.yes)),
            SizedBox(width: 10.w),
            Expanded(child: _invoiceAddressOption('request.form.no'.tr, InvoiceAddressMatch.no)),
          ],
        ),

        // ── Yes: pink address banner (SS-4) ──
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          child: isYes
              ? Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: _buildInvoiceYesBanner(),
          )
              : const SizedBox.shrink(),
        ),

        // ── No: full address form (SS-5) ──
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          child: isNo
              ? Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: _buildInvoiceNoForm(),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  /// SS-4: pink address confirmation banner
  Widget _buildInvoiceYesBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: AppColors.redAlpha10,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.red100.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined,
              color: AppColors.red200, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '${'request.invoice.destination_preview'.tr} ${_c.address}${_c.city.isNotEmpty ? ', ${_c.city}' : ''}',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.red200,
                  fontWeight: FontWeight.w500,
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  /// SS-5: full new shipping address form + Conform Address button
  Widget _buildInvoiceNoForm() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // info banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: AppColors.textDark, size: 14.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'request.form.enter_shipping_address'.tr,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textPrimary,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Address
          Text('request.form.address'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
          SizedBox(height: 6.h),
          _addressTextField(_invStreetCtrl, hint: 'example@amail.com'),
          SizedBox(height: 10.h),

          // City + Number row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('request.form.city'.tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textPrimary,
                            height: 1.22)),
                    SizedBox(height: 6.h),
                    _addressTextField(_invCityCtrl, hint: 'Milano'),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 100.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('request.form.number'.tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textPrimary,
                            height: 1.22)),
                    SizedBox(height: 6.h),
                    _addressTextField(_invNumberCtrl,
                        hint: '20100',
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Zip Code
          Text('request.form.zip_code'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
          SizedBox(height: 6.h),
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.shortcardbg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.shortcardbg, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _invZipProvince,
                  hint: Text('request.form.select_province'.tr,
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                          height: 1.22)),
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textDark, size: 20.sp),
                  items: const [
                    'Milano', 'Roma', 'Napoli', 'Torino',
                    'Palermo', 'Genova', 'Bologna', 'Firenze',
                  ]
                      .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p,
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textDark,
                            height: 1.22)),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _invZipProvince = v),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Province
          Text('request.form.province'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  height: 1.22)),
          SizedBox(height: 6.h),
          _addressTextField(_invProvinceCtrl, hint: 'RM'),
          SizedBox(height: 16.h),

          // Conform Address button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.background,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('request.form.conform_address'.tr,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.22)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _invoiceOption({
    required InvoiceMethod method,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _c.selectedInvoice == method;
    return GestureDetector(
      onTap: () => _c.selectInvoice(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary100
              : AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.divider,
            width: 1.22,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textDark,
                  width: 1.22,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, color: AppColors.background, size: 12.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                          height: 1.22)),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textPrimary,
                          height: 1.22)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _invoiceAddressOption(String label, InvoiceAddressMatch match) {
    final isSelected = _invoiceAddressMatch == match;
    return GestureDetector(
      onTap: () => setState(() => _invoiceAddressMatch = match),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary100
              : AppColors.background,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.divider,
            width: 1.22,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textDark,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.circle, color: AppColors.background, size: 8.sp)
                  : null,
            ),
            SizedBox(width: 6.w),
            Text(label,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.textPrimary,
                    height: 1.22)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  ALMOST THERE BANNER
  // ─────────────────────────────────────────────

  Widget _buildAlmostThereCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.greenAlpha10,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded,
              color: AppColors.linkGreen, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('request.form.almost_done'.tr,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        height: 1.22)),
                SizedBox(height: 4.h),
                Text(
                    'request.form.contract_send_info'.tr,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textPrimary,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  ACTIVATE BUTTON
  // ─────────────────────────────────────────────

  Widget _buildNoBillWarning() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.yellowAlpha10,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.yellow100, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: AppColors.yellow200, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'request.form.no_bill_warning'.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textDark,
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivateButton() {
    final missingPersonalFields = <String>[];
    if (_c.firstName.trim().isEmpty) missingPersonalFields.add('request.form.first_name_field'.tr);
    if (_c.lastName.trim().isEmpty) missingPersonalFields.add('request.form.last_name_field'.tr);
    if (_c.phone.trim().isEmpty) missingPersonalFields.add('request.form.phone_field'.tr);
    if (_c.podNumber.trim().isEmpty) missingPersonalFields.add('request.form.pod_number_field'.tr);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (missingPersonalFields.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 14.sp, color: Colors.red.shade400),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    '${missingPersonalFields.join(', ')} ${missingPersonalFields.length == 1 ? 'is' : 'are'} required.',
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.red.shade400,
                        height: 1.22),
                  ),
                ),
              ],
            ),
          ),
        if (_c.uploadedDocuments.isEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 14.sp, color: Colors.red.shade400),
                SizedBox(width: 4.w),
                Text(
                  'request.form.identity_required_hint'.tr,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red.shade400,
                      height: 1.22),
                ),
              ],
            ),
          ),
        SizedBox(
          width: double.infinity,
          height: 54.h,
          child: ElevatedButton(
            onPressed: _c.canActivate ? () => _c.activateOffer() : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _c.canActivate
                  ? AppColors.primaryColor
                  : AppColors.primary300,
              foregroundColor: AppColors.background,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
            ),
            child: _c.isSubmitting
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text('request.form.activate_offer'.tr,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.22)),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────────

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryColor, width: 1.22),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            height: 1.22));
  }
}

// ─────────────────────────────────────────────
//  INVOICE ADDRESS MATCH ENUM  (local to screen)
// ─────────────────────────────────────────────

enum InvoiceAddressMatch { yes, no }

