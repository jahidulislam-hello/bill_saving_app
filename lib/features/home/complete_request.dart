import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'complete_request_controller.dart';

class CompleteRequestScreen extends StatefulWidget {
  const CompleteRequestScreen({super.key});

  @override
  State<CompleteRequestScreen> createState() => _CompleteRequestScreenState();
}

class _CompleteRequestScreenState extends State<CompleteRequestScreen> {
  final CompleteRequestController _c = CompleteRequestController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
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
        'Complete Your Request',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A2E),
          height: 1.22,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  OFFER CARD  (top card)
  // ─────────────────────────────────────────────

  Widget _buildOfferCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
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
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                    Text('Green Energy',
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                            height: 1.22)),
                    Text('Green Offer',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF9E9E9E),
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
                child: Text('Best Value',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.22)),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // ── Energy price band ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text('Energy Price : PUN GME + € 0.01/KWh',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF5B3FD8),
                    fontWeight: FontWeight.w500,
                    height: 1.22)),
          ),
          SizedBox(height: 10.h),

          _buildInfoRow(Icons.credit_card_outlined,
              const Color(0xFF5B7FD8), 'Payment Method: Postal Order'),
          SizedBox(height: 7.h),
          _buildInfoRow(Icons.check_circle_outline,
              const Color(0xFF9B59B6), 'Compatibility: Residential'),
          SizedBox(height: 12.h),

          // ── Annual savings ──
          Row(
            children: [
              Text('€380',
                  style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF4CAF50),
                      height: 1.22)),
              SizedBox(width: 8.w),
              Text('Annual Savings',
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
        Text(text,
            style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF555555),
                height: 1.22)),
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
              _sectionTitle('Personal Information'),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B3FD8),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded,
                          color: Colors.white, size: 12.sp),
                      SizedBox(width: 4.w),
                      Text('Edit',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 1.22)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _personalRow('First Name', _c.firstName),
          _dividerLine(),
          _personalRow('Last Name', _c.lastName),
          _dividerLine(),
          _personalRow('Email', _c.email),
          _dividerLine(),
          _personalRow('Phone', _c.phone),
          _dividerLine(),
          _personalRow('POD Number', _c.podNumber),
        ],
      ),
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
                    color: const Color(0xFF9E9E9E),
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
      Divider(height: 1, thickness: 1, color: Colors.grey.shade100);

  // ─────────────────────────────────────────────
  //  SUPPLY ADDRESS
  // ─────────────────────────────────────────────

  Widget _buildSupplyAddressCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Supply Address'),
          SizedBox(height: 2.h),
          Text('Read-Only Summary from Bill/Profile',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF9E9E9E),
                  height: 1.22)),
          SizedBox(height: 12.h),

          // ── Address box ──
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200, width: 1.2),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined,
                    color: const Color(0xFF5B3FD8), size: 20.sp),
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
                              color: const Color(0xFF9E9E9E),
                              height: 1.22)),
                    ],
                  ),
                ),
                Icon(Icons.edit_outlined,
                    color: Colors.grey.shade400, size: 18.sp),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          Text('Does the Residential address match the delivery address?',
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                  height: 1.4)),
          SizedBox(height: 10.h),

          // ── Yes/No toggle row ──
          Row(
            children: [
              Expanded(
                  child: _addressOption(
                      "Yes, it's the same", AddressMatch.same)),
              SizedBox(width: 10.w),
              Expanded(
                  child: _addressOption(
                      "No, it's different", AddressMatch.different)),
            ],
          ),
          SizedBox(height: 12.h),

          // ── Address verified button ──
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton(
              onPressed: _c.addressMatch != null ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _c.addressMatch != null
                    ? const Color(0xFF7B6EE8)
                    : const Color(0xFFD0CCFF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('Address verified',
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

  Widget _addressOption(String label, AddressMatch match) {
    final isSelected = _c.addressMatch == match;
    return GestureDetector(
      onTap: () => _c.selectAddressMatch(match),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF0EEFF)
              : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF5B3FD8)
                : Colors.grey.shade300,
            width: 1.3,
          ),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF5B3FD8)
                      : const Color(0xFF555555),
                  height: 1.22)),
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
              _sectionTitle('Identity Verification'),
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
          SizedBox(height: 4.h),
          Text(
              'Upload your identity document or driving license to complete the request.',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF9E9E9E),
                  height: 1.5)),
          SizedBox(height: 14.h),

          // ── Uploaded files chips ──
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
                    border: Border.all(
                        color: const Color(0xFF27AE60), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.insert_drive_file_outlined,
                          size: 12.sp, color: const Color(0xFF27AE60)),
                      SizedBox(width: 4.w),
                      Text(
                        name.length > 16
                            ? '${name.substring(0, 16)}...'
                            : name,
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

          // ── Upload / Scan buttons ──
          Row(
            children: [
              Expanded(
                child: _buildIdButton(
                  icon: Icons.upload_rounded,
                  label: 'Upload File',
                  sublabel: 'PDF, Photo',
                  canUpload: _c.uploadedFiles.length < 3,
                  onTap: _pickFile,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildIdButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan Document',
                  sublabel: 'Scan with the camera',
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
          border: Border.all(
            color: canUpload ? Colors.grey.shade300 : Colors.grey.shade200,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 26.sp,
                color: canUpload
                    ? const Color(0xFF5B3FD8)
                    : Colors.grey.shade400),
            SizedBox(height: 6.h),
            Text(label,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: canUpload
                        ? const Color(0xFF1A1A2E)
                        : Colors.grey.shade400,
                    height: 1.22)),
            SizedBox(height: 2.h),
            Text(sublabel,
                style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade400,
                    height: 1.22)),
          ],
        ),
      ),
    );
  }

  // ── Pick file from gallery ──
  Future<void> _pickFile() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file != null) {
        _c.addUploadedFile(file.path);
      }
    } catch (e) {
      debugPrint('File picker error: $e');
    }
  }

  // ── Open scanner ──
  void _openScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _DocumentScannerScreen(
          onScanned: (path) {
            _c.addUploadedFile(path);
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  PAYMENT METHOD
  // ─────────────────────────────────────────────

  Widget _buildPaymentMethodCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Payment Method'),
          SizedBox(height: 2.h),
          Text('Select how you prefer to pay',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF9E9E9E),
                  height: 1.22)),
          SizedBox(height: 12.h),

          _personalRow('Full Name', _c.fullName),
          _dividerLine(),
          _personalRow('Tax Code', _c.taxCode),

          SizedBox(height: 14.h),

          Text('Choose Payment Method',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                  height: 1.22)),
          SizedBox(height: 10.h),

          _paymentOption(
            method: PaymentMethod.directDebit,
            title: 'Direct Debit(SDD)',
            subtitle: 'Automatic Payment from your account',
          ),
          SizedBox(height: 8.h),
          _paymentOption(
            method: PaymentMethod.postalOrder,
            title: 'Postal Order',
            subtitle: 'You will receive the bulleting to pay',
          ),
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
                ? const Color(0xFF5B3FD8)
                : Colors.grey.shade200,
            width: 1.3,
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
                    ? const Color(0xFF5B3FD8)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5B3FD8)
                      : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded,
                  color: Colors.white, size: 12.sp)
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
                          color: const Color(0xFF9E9E9E),
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
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Invoice Delivery Method'),
          SizedBox(height: 2.h),
          Text('Our advice: send via email to receive the service on time!',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF9E9E9E),
                  height: 1.5)),
          SizedBox(height: 12.h),
          _invoiceOption(
            method: InvoiceMethod.digital,
            title: 'Digital Invoice',
            subtitle: 'Receive the invoice via email',
          ),
          SizedBox(height: 8.h),
          _invoiceOption(
            method: InvoiceMethod.paper,
            title: 'Paper Invoice',
            subtitle: 'You will receive the bulleting to pay',
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
                ? const Color(0xFF5B3FD8)
                : Colors.grey.shade200,
            width: 1.3,
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
                    ? const Color(0xFF5B3FD8)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5B3FD8)
                      : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded,
                  color: Colors.white, size: 12.sp)
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
                          color: const Color(0xFF9E9E9E),
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
  //  ALMOST THERE BANNER
  // ─────────────────────────────────────────────

  Widget _buildAlmostThereCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFB2DFCC), width: 1.2),
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
                Text('Almost there!',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                        height: 1.22)),
                SizedBox(height: 4.h),
                Text(
                    "Once you activate, we'll send your contract within 24 hours for signing.",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF555555),
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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B3FD8),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r)),
        ),
        child: Text('Activate Offer',
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
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
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
        title: Text('Scan Document',
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
            icon: const Icon(Icons.flip_camera_ios_rounded,
                color: Colors.white),
            onPressed: () => _scanCtrl.switchCamera(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.white12),
        ),
      ),
      body: Stack(
        children: [
          // ── Camera preview ──
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

          // ── Scan frame overlay ──
          Center(
            child: Container(
              width: 260.w,
              height: 180.h,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF5B3FD8), width: 2.5),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  // Corner accents
                  ..._cornerAccents(),
                ],
              ),
            ),
          ),

          // ── Labels ──
          Positioned(
            top: MediaQuery.of(context).size.height * 0.62,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text('Align document within the frame',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.22)),
                SizedBox(height: 6.h),
                Text('QR codes and barcodes are also supported',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white60,
                        height: 1.22)),
              ],
            ),
          ),

          // ── Manual capture button ──
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Manual capture: use image_picker camera
                  _captureManual();
                },
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
    const c = Color(0xFF5B3FD8);
    const size = 20.0;
    const w = 3.0;
    return [
      // TL
      Positioned(
          top: 0,
          left: 0,
          child: Container(
              width: size,
              height: w,
              color: c)),
      Positioned(
          top: 0,
          left: 0,
          child: Container(
              width: w,
              height: size,
              color: c)),
      // TR
      Positioned(
          top: 0,
          right: 0,
          child: Container(
              width: size,
              height: w,
              color: c)),
      Positioned(
          top: 0,
          right: 0,
          child: Container(
              width: w,
              height: size,
              color: c)),
      // BL
      Positioned(
          bottom: 0,
          left: 0,
          child: Container(
              width: size,
              height: w,
              color: c)),
      Positioned(
          bottom: 0,
          left: 0,
          child: Container(
              width: w,
              height: size,
              color: c)),
      // BR
      Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              width: size,
              height: w,
              color: c)),
      Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              width: w,
              height: size,
              color: c)),
    ];
  }
}