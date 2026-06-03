import 'package:vyzi/features/request/request_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'complete_request_controller.dart';

class CompleteRequestScreen extends StatefulWidget {
  const CompleteRequestScreen({super.key});

  @override
  State<CompleteRequestScreen> createState() => _CompleteRequestScreenState();
}

class _CompleteRequestScreenState extends State<CompleteRequestScreen> {
  final CompleteRequestController _c = CompleteRequestController();
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

  // ── Payment Method extras ──
  // shown only when directDebit selected
  bool _ibanSameAsContract = true;
  final TextEditingController _holderFirstCtrl =
  TextEditingController(text: 'jacob clai');
  final TextEditingController _holderLastCtrl =
  TextEditingController(text: 'jacob');
  final TextEditingController _holderTaxCtrl =
  TextEditingController(text: '1234 5678 9654 2135 6874 1312 456');

  // ── Invoice Delivery extras ──
  // shown only when digital selected
  final TextEditingController _invoiceEmailCtrl =
  TextEditingController(text: 'example@amail.com');
  // shown only when paper selected
  InvoiceAddressMatch? _invoiceAddressMatch;
  // new address for paper invoice "No" branch
  final TextEditingController _invStreetCtrl = TextEditingController();
  final TextEditingController _invCityCtrl =
  TextEditingController(text: 'Milano');
  final TextEditingController _invNumberCtrl =
  TextEditingController(text: '20100');
  final TextEditingController _invProvinceCtrl =
  TextEditingController(text: 'RM');
  String? _invZipProvince;

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      if (mounted) setState(() {});
    });
    _firstNameCtrl = TextEditingController(text: _c.firstName);
    _lastNameCtrl = TextEditingController(text: _c.lastName);
    _emailCtrl = TextEditingController(text: _c.email);
    _phoneCtrl = TextEditingController(text: _c.phone);
    _podCtrl = TextEditingController(text: _c.podNumber);
    _streetCtrl = TextEditingController(text: '123 Main Street');
    _cityCtrl = TextEditingController(text: 'Milano');
    _zipCtrl = TextEditingController(text: '20100');
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
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
            SizedBox(height: 16.h),
            _buildActivateButton(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  SizedBox _gap() => SizedBox(height: 12.h);

  // ─────────────────────────────────────────────
  //  APPBAR
  // ─────────────────────────────────────────────

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
        'Completa la tua Richiesta',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
          height: 1.22,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  OFFER CARD
  // ─────────────────────────────────────────────

  Widget _buildOfferCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=200',
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCE8AEB),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.bolt, color: Colors.white, size: 24.sp),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Energia Verde',
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                            height: 1.22)),
                    Text('Offerta Verde',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            height: 1.22)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text('Miglior Valore',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.22)),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFCE8AEB),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text('Prezzo Energia : PUN GME + € 0.01/KWh',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    height: 1.22)),
          ),
          SizedBox(height: 10.h),
          _buildInfoRow(Icons.credit_card_outlined, const Color(0xFF5B7FD8),
              'Metodo di Pagamento: Bollettino Postale'),
          SizedBox(height: 7.h),
          _buildInfoRow(Icons.check_circle_outline, const Color(0xFF9B59B6),
              'Compatibilità: Residenziale'),
          SizedBox(height: 12.h),
          _dividerLine(),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text('€380',
                  style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF4CAF50),
                      height: 1.22)),
              SizedBox(width: 8.w),
              Text('Risparmio Annuale',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w500,
                      height: 1.22)),
            ],
          ),
        ],
      ),
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
                  color: Colors.black,
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
              _sectionTitle('Informazioni Personali'),
              GestureDetector(
                onTap: () {
                  if (_editingPersonalInfo) {
                    _c.firstName = _firstNameCtrl.text;
                    _c.lastName = _lastNameCtrl.text;
                    _c.email = _emailCtrl.text;
                    _c.phone = _phoneCtrl.text;
                    _c.podNumber = _podCtrl.text;
                  }
                  setState(() => _editingPersonalInfo = !_editingPersonalInfo);
                },
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: _editingPersonalInfo
                        ? const Color(0xFF27AE60)
                        : AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _editingPersonalInfo
                            ? Icons.check_rounded
                            : Icons.edit_rounded,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _editingPersonalInfo ? 'Salva' : 'Modifica',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
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
            _buildEditField('Nome', _firstNameCtrl),
            SizedBox(height: 10.h),
            _buildEditField('Cognome', _lastNameCtrl),
            SizedBox(height: 10.h),
            _buildEditField('Email', _emailCtrl,
                keyboardType: TextInputType.emailAddress),
            SizedBox(height: 10.h),
            _buildEditField('Numero POD', _podCtrl),
            SizedBox(height: 10.h),
            _buildEditField('Telefono', _phoneCtrl,
                keyboardType: TextInputType.phone),
          ] else ...[
            _personalRow('Nome', _c.firstName),
            _personalRow('Cognome', _c.lastName),
            _personalRow('Email', _c.email),
            _personalRow('Telefono', _c.phone),
            _personalRow('Numero POD', _c.podNumber),
          ],
        ],
      ),
    );
  }

  Widget _buildEditField(
      String label,
      TextEditingController ctrl, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.22)),
        SizedBox(height: 6.h),
        Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF1A1A2E),
                fontWeight: FontWeight.w500,
                height: 1.22),
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 0),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
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
                    color: Colors.black,
                    height: 1.22)),
          ),
          Expanded(
            flex: 6,
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w500,
                    height: 1.22)),
          ),
        ],
      ),
    );
  }

  Widget _dividerLine() =>
      Divider(height: 1, thickness: 1, color: Colors.grey);

  // ─────────────────────────────────────────────
  //  SUPPLY ADDRESS
  // ─────────────────────────────────────────────

  Widget _buildSupplyAddressCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Indirizzo di Fornitura'),
          SizedBox(height: 2.h),
          Text('Riepilogo in sola lettura da Bolletta/Profilo',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  height: 1.22)),
          SizedBox(height: 12.h),

          // ── Address box ──
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
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
                              color: const Color(0xFF1A1A2E),
                              height: 1.22)),
                      SizedBox(height: 2.h),
                      Text(_c.city,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
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
                          : Colors.black,
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
              'L\'indirizzo di residenza corrisponde all\'indirizzo di consegna?',
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                  height: 1.4)),
          SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                  child: _addressOption("Sì, è lo stesso", AddressMatch.same)),
              SizedBox(width: 10.w),
              Expanded(
                  child: _addressOption(
                      "No, è diverso", AddressMatch.different)),
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

          SizedBox(height: 12.h),

          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton(
              onPressed: _c.addressMatch != null ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _c.addressMatch != null
                    ? AppColors.primaryColor
                    : const Color(0xFFD0CCFF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('Indirizzo verificato',
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

  Widget _buildAddressEditForm() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Indirizzo di Fornitura',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
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
                        color: const Color(0xFF27AE60), size: 14.sp),
                    SizedBox(width: 3.w),
                    Text('Salva',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF27AE60),
                            fontWeight: FontWeight.w600,
                            height: 1.22)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text('Indirizzo',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  height: 1.22)),
          SizedBox(height: 6.h),
          _addressTextField(_streetCtrl, hint: '123 Main Street'),
          SizedBox(height: 10.h),
          Text('Città',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  height: 1.22)),
          SizedBox(height: 6.h),
          _addressTextField(_cityCtrl, hint: 'Milano'),
          SizedBox(height: 10.h),
          Text('CAP',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
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
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFFFE082), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: const Color(0xFFF59E0B), size: 14.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Se "No" è selezionato, questa sezione scende automaticamente.',
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF92400E),
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Text('Nuovo Indirizzo Residenziale',
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                  height: 1.22)),
          SizedBox(height: 12.h),
          Text('Via e Numero',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  height: 1.22)),
          SizedBox(height: 6.h),
          _addressTextField(TextEditingController(),
              hint: 'Esempio: Via delle Rose 10'),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Città',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            height: 1.22)),
                    SizedBox(height: 6.h),
                    _addressTextField(
                        TextEditingController(text: 'Milano'),
                        hint: 'Milano'),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CAP',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            height: 1.22)),
                    SizedBox(height: 6.h),
                    _addressTextField(
                        TextEditingController(text: '20100'),
                        hint: '20100',
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text('Provincia',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      height: 1.22)),
              Text(' *',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red,
                      height: 1.22)),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _supplyProvince,
                  hint: Text('Seleziona Provincia',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          height: 1.22)),
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.black, size: 20.sp),
                  items: const [
                    'Milano', 'Roma', 'Napoli', 'Torino',
                    'Palermo', 'Genova', 'Bologna', 'Firenze',
                  ]
                      .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p,
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF1A1A2E),
                            height: 1.22)),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _supplyProvince = v),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressTextField(
      TextEditingController ctrl, {
        String hint = '',
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w500,
            height: 1.22),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
          TextStyle(fontSize: 13.sp, color: Colors.black, height: 1.22),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 14.w, vertical: 0),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _addressOption(String label, AddressMatch match) {
    final isSelected = _c.addressMatch == match;
    return GestureDetector(
      onTap: () => _c.selectAddressMatch(match),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF0EEFF)
              : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : const Color(0xFF5A1ABE),
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
                      : Colors.black,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.circle, color: Colors.white, size: 8.sp)
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
                          : Colors.black,
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
              _sectionTitle('Verifica Identità'),
              Row(
                children: [
                  Icon(Icons.check_rounded,
                      color: const Color(0xFF27AE60), size: 14.sp),
                  SizedBox(width: 3.w),
                  Text('Salva',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF27AE60),
                          fontWeight: FontWeight.w600,
                          height: 1.22)),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
              'Carica il tuo documento d\'identità o la patente per completare la richiesta.',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  height: 1.5)),
          SizedBox(height: 14.h),
          if (_c.uploadedFiles.isNotEmpty) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: _c.uploadedFiles.asMap().entries.map((e) {
                final name = e.value.split('/').last;
                return Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EF),
                    borderRadius: BorderRadius.circular(20.r),
                    border:
                    Border.all(color: const Color(0xFF27AE60), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.insert_drive_file_outlined,
                          size: 12.sp, color: const Color(0xFF27AE60)),
                      SizedBox(width: 4.w),
                      Text(
                        name.length > 16 ? '${name.substring(0, 16)}...' : name,
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF27AE60),
                            height: 1.22),
                      ),
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: () => _c.removeFile(e.key),
                        child: Icon(Icons.close_rounded,
                            size: 12.sp, color: const Color(0xFF27AE60)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10.h),
          ],
          Row(
            children: [
              Expanded(
                child: _buildIdButton(
                  icon: Icons.upload_rounded,
                  label: 'Carica File',
                  sublabel: 'PDF, Foto',
                  canUpload: _c.uploadedFiles.length < 3,
                  onTap: _pickFile,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildIdButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scansiona Documento',
                  sublabel: 'Scansiona con la fotocamera',
                  canUpload: true,
                  onTap: _openScanner,
                ),
              ),
            ],
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
        height: 90.h,
        decoration: BoxDecoration(
          color: canUpload ? Colors.white : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 26.sp,
                color: canUpload
                    ? AppColors.primaryColor
                    : Colors.black),
            SizedBox(height: 6.h),
            Text(label,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: canUpload
                        ? const Color(0xFF1A1A2E)
                        : Colors.black,
                    height: 1.22)),
            SizedBox(height: 2.h),
            Text(sublabel,
                style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black,
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
      if (file != null) _c.addUploadedFile(file.path);
    } catch (e) {
      debugPrint('File picker error: $e');
    }
  }

  void _openScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _DocumentScannerScreen(
          onScanned: (path) => _c.addUploadedFile(path),
        ),
      ),
    );
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
          _sectionTitle('Metodo di Pagamento'),
          SizedBox(height: 2.h),
          Text('Seleziona come preferisci pagare',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  height: 1.22)),
          SizedBox(height: 12.h),

          // Full Name / Tax Code rows
          _personalRow('Nome Completo', _c.fullName),
          _dividerLine(),
          _personalRow('Codice Fiscale', _c.taxCode),
          SizedBox(height: 14.h),

          // ── Payment options ──
          Text('Scegli il Metodo di Pagamento',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                  height: 1.22)),
          SizedBox(height: 10.h),
          _paymentOption(
            method: PaymentMethod.directDebit,
            title: 'Addebito Diretto (SDD)',
            subtitle: 'Pagamento automatico dal tuo conto',
          ),
          SizedBox(height: 8.h),
          _paymentOption(
            method: PaymentMethod.postalOrder,
            title: 'Bollettino Postale',
            subtitle: 'Riceverai il bollettino per pagare',
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
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFD2D2D2), width: 1),
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
                        ? const Color(0xFFE8F8EF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: _ibanSameAsContract
                          ? const Color(0xFF1FC16B)
                          : const Color(0xFF5A1ABE),
                      width: 1,
                    ),
                  ),
                  child: _ibanSameAsContract
                      ? Icon(Icons.check_rounded,
                      size: 13.sp, color: const Color(0xFF1FC16B))
                      : null,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Yes, IBAN Holder & Contract Holder are same',
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF1A1A2E),
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
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Holder information',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                      height: 1.22)),
              Row(
                children: [
                  Icon(Icons.check_rounded,
                      color: const Color(0xFF27AE60), size: 14.sp),
                  SizedBox(width: 3.w),
                  Text('Save',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF27AE60),
                          fontWeight: FontWeight.w600,
                          height: 1.22)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildEditField('Fast Name', _holderFirstCtrl),
          SizedBox(height: 10.h),
          _buildEditField('Last Name', _holderLastCtrl),
          SizedBox(height: 10.h),
          _buildEditField('Tax Code / Fiscal Code', _holderTaxCtrl,
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
              ? const Color(0xFFF0EEFF)
              : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : const Color(0xFFD2D2D2),
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
                      : Colors.black,
                  width: 1.22,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 12.sp)
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
                          color: const Color(0xFF1A1A2E),
                          height: 1.22)),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black,
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
          _sectionTitle('Metodo di Invio Fattura'),
          SizedBox(height: 2.h),
          Text(
              'Il nostro consiglio: invio via email per ricevere il servizio puntualmente!',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  height: 1.5)),
          SizedBox(height: 12.h),

          _invoiceOption(
            method: InvoiceMethod.digital,
            title: 'Fattura Digitale',
            subtitle: 'Ricevi la fattura via email',
          ),
          SizedBox(height: 8.h),
          _invoiceOption(
            method: InvoiceMethod.paper,
            title: 'Fattura Cartacea',
            subtitle: 'Riceverai il bollettino per pagare',
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
            color: const Color(0xFFEDE7F6),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Pre-filled email from your profile',
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
                text: 'Email for invoice ',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                    height: 1.22),
              ),
              TextSpan(
                text: '*',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.red,
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
        Text('Does the shipping address match the delivery address?',
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
                height: 1.4)),
        SizedBox(height: 10.h),

        // Yes / No toggle
        Row(
          children: [
            Expanded(child: _invoiceAddressOption('Yes', InvoiceAddressMatch.yes)),
            SizedBox(width: 10.w),
            Expanded(child: _invoiceAddressOption('No', InvoiceAddressMatch.no)),
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
        color: const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF48FB1), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined,
              color: const Color(0xFFE91E63), size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'The invoice will be sent to: Via Roma 42, 20121 Milan (MI)',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFFE91E63),
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
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // info banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFD2D2D2), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: Colors.black, size: 14.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Enter your shipping address',
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Address
          Text('Address',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
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
                    Text('City',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
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
                    Text('Number',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
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
          Text('Zip Code',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  height: 1.22)),
          SizedBox(height: 6.h),
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _invZipProvince,
                  hint: Text('Select Province',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          height: 1.22)),
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.black, size: 20.sp),
                  items: const [
                    'Milano', 'Roma', 'Napoli', 'Torino',
                    'Palermo', 'Genova', 'Bologna', 'Firenze',
                  ]
                      .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p,
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF1A1A2E),
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
          Text('Province',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
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
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('Conform Address',
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
              ? const Color(0xFFF0EEFF)
              : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : const Color(0xFFD2D2D2),
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
                      : Colors.black,
                  width: 1.22,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 12.sp)
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
                          color: const Color(0xFF1A1A2E),
                          height: 1.22)),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black,
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
              ? const Color(0xFFF0EEFF)
              : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : const Color(0xFFD2D2D2),
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
                      : Colors.black,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.circle, color: Colors.white, size: 8.sp)
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
                        : Colors.black,
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
        color: const Color(0xFFE8F8EF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded,
              color: const Color(0xFF27AE60), size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quasi fatto!',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                        height: 1.22)),
                SizedBox(height: 4.h),
                Text(
                    "Una volta attivato, invieremo il tuo contratto entro 24 ore per la firma.",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
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

  Widget _buildActivateButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: () => Get.to(() => RequestSuccessScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r)),
        ),
        child: Text('Attiva Offerta',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                height: 1.22)),
      ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
            color: const Color(0xFF1A1A2E),
            height: 1.22));
  }
}

// ─────────────────────────────────────────────
//  INVOICE ADDRESS MATCH ENUM  (local to screen)
// ─────────────────────────────────────────────

enum InvoiceAddressMatch { yes, no }

// ─────────────────────────────────────────────
//  DOCUMENT SCANNER SCREEN
// ─────────────────────────────────────────────

class _DocumentScannerScreen extends StatefulWidget {
  final void Function(String path) onScanned;
  const _DocumentScannerScreen({required this.onScanned});

  @override
  State<_DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<_DocumentScannerScreen> {
  final MobileScannerController _scanCtrl = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _scanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Scansiona Documento',
            style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                height: 1.22)),
        actions: [
          ValueListenableBuilder(
            valueListenable: _scanCtrl,
            builder: (_, state, __) => IconButton(
              icon: Icon(
                state.torchState == TorchState.on
                    ? Icons.flash_on_rounded
                    : Icons.flash_off_rounded,
                color: Colors.white,
              ),
              onPressed: () => _scanCtrl.toggleTorch(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white),
            onPressed: () => _scanCtrl.switchCamera(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scanCtrl,
            onDetect: (capture) {
              if (_scanned) return;
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                _scanned = true;
                final value = barcodes.first.rawValue ?? 'scanned_doc';
                widget.onScanned(value);
                Navigator.pop(context);
              }
            },
          ),
          Center(
            child: Container(
              width: 260.w,
              height: 180.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor, width: 2.5),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(children: _cornerAccents()),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.62,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text('Allinea il documento nella cornice',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.22)),
                SizedBox(height: 6.h),
                Text('Sono supportati anche codici QR e codici a barre',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        height: 1.22)),
              ],
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _captureManual,
                child: Container(
                  width: 68.w,
                  height: 68.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Container(
                      width: 54.w,
                      height: 54.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureManual() async {
    final picker = ImagePicker();
    final XFile? file =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (file != null && mounted) {
      widget.onScanned(file.path);
      Navigator.pop(context);
    }
  }

  List<Widget> _cornerAccents() {
    const c = AppColors.primaryColor;
    const size = 20.0;
    const w = 3.0;
    return [
      Positioned(top: 0, left: 0, child: Container(width: size, height: w, color: c)),
      Positioned(top: 0, left: 0, child: Container(width: w, height: size, color: c)),
      Positioned(top: 0, right: 0, child: Container(width: size, height: w, color: c)),
      Positioned(top: 0, right: 0, child: Container(width: w, height: size, color: c)),
      Positioned(bottom: 0, left: 0, child: Container(width: size, height: w, color: c)),
      Positioned(bottom: 0, left: 0, child: Container(width: w, height: size, color: c)),
      Positioned(bottom: 0, right: 0, child: Container(width: size, height: w, color: c)),
      Positioned(bottom: 0, right: 0, child: Container(width: w, height: size, color: c)),
    ];
  }
}
