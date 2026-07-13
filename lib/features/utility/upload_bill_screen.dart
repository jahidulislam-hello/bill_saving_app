import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/home/email/email_bill_screen.dart';
import 'package:vyzi/features/utility/controller/select_utility_controller.dart';
import 'package:vyzi/features/utility/controller/upload_bill_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../routes/app_routes.dart';

class UploadBillScreen extends StatefulWidget {
  final UtilityType utilityType;

  const UploadBillScreen({super.key, required this.utilityType});

  @override
  State<UploadBillScreen> createState() => _UploadBillScreenState();
}

class _UploadBillScreenState extends State<UploadBillScreen> {
  final UploadBillController _controller = Get.put(UploadBillController());
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _controller.clearState();
    super.dispose();
  }

  String get _headingKey =>
      widget.utilityType == UtilityType.luce
          ? 'upload_bill.heading_electricity'
          : 'upload_bill.heading_gas';

  // ─────────────────────────────────────────────
  //  ACTIONS
  // ─────────────────────────────────────────────

  /// Shows bottom sheet to choose between photo gallery and PDF document
  void _openFilePicker() {
    _controller.selectMethod(UploadMethod.uploadFile);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'upload_bill.select_source'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              _buildSourceOption(
                icon: Icons.photo_library_rounded,
                label: 'upload_bill.photo_gallery'.tr,
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFromGallery();
                },
              ),
              SizedBox(height: 8.h),
              _buildSourceOption(
                icon: Icons.picture_as_pdf_rounded,
                label: 'upload_bill.pdf_document'.tr,
                onTap: () {
                  Navigator.pop(ctx);
                  _pickPdfFile();
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8E8E8)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5A1ABE), size: 24),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  String get _billType =>
      widget.utilityType == UtilityType.luce ? 'electricity' : 'gas';

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (file != null && mounted) {
        _controller.setSelectedFile(file);
        _controller.runOcrExtraction(_billType);
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  Future<void> _pickPdfFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null && mounted) {
        final file = XFile(result.files.single.path!);
        _controller.setSelectedFile(file);
        _controller.runOcrExtraction(_billType);
      }
    } catch (e) {
      debugPrint('PDF picker error: $e');
    }
  }

  /// Opens camera to take photo of bill
  Future<void> _openCamera() async {
    _controller.selectMethod(UploadMethod.scanFile);
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (photo != null && mounted) {
        _controller.setSelectedFile(photo);
        _controller.runOcrExtraction(_billType);
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  /// Triggers the actual upload
  Future<void> _uploadBill() async {
    await _controller.uploadBill(widget.utilityType);
    if (_controller.uploadSuccess.value && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('upload_bill.upload_success'.tr),
          backgroundColor: const Color(0xFF1FC16B),
        ),
      );
      // Navigate to bill detail
      if (_controller.uploadedBillId.value.isNotEmpty) {
        Get.offNamed(
          AppRoutes.billDetailScreen,
          arguments: _controller.uploadedBillId.value,
        );
      } else {
        Get.offNamed(AppRoutes.billsListScreen);
      }
    }
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Heading ──
                Text(
                  _headingKey.tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    height: 1.28,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'upload_bill.subtitle'.tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
                SizedBox(height: 20.h),

                // ── Info banner ──
                _buildInfoBanner(),
                SizedBox(height: 20.h),

                // ── Upload / Scan cards ──
                _buildUploadScanRow(),
                SizedBox(height: 14.h),

                // ── File preview (if selected) ──
                Obx(() => _controller.selectedFile.value != null
                    ? _buildFilePreview()
                    : const SizedBox.shrink()),

                // ── OCR extraction progress ──
                Obx(() => _controller.isExtracting.value
                    ? _buildExtractionProgress()
                    : const SizedBox.shrink()),

                // ── OCR extracted data preview ──
                Obx(() => _controller.ocrCompleted.value &&
                        _controller.ocrResult.value?.hasAnyData == true
                    ? _buildOcrPreview()
                    : const SizedBox.shrink()),

                // ── Missing fields warning ──
                Obx(() => _controller.ocrCompleted.value &&
                        _controller.missingFields.isNotEmpty
                    ? _buildMissingFieldsWarning()
                    : const SizedBox.shrink()),

                // ── Error message ──
                Obx(() => _controller.errorMessage.value.isNotEmpty &&
                        _controller.missingFields.isEmpty
                    ? _buildErrorMessage()
                    : const SizedBox.shrink()),

                // ── Upload button (only when all fields extracted) ──
                Obx(() => _controller.selectedFile.value != null &&
                        !_controller.isUploading.value &&
                        !_controller.isExtracting.value &&
                        _controller.canUpload
                    ? _buildUploadButton()
                    : const SizedBox.shrink()),

                SizedBox(height: 14.h),

                // ── OR divider ──
                _buildOrDivider(),
                SizedBox(height: 14.h),

                // ── Send Our Email card ──
                _buildEmailCard(),
                SizedBox(height: 24.h),

                // ── What we are looking for ──
                _buildLookingForCard(),
                SizedBox(height: 30.h),
              ],
            ),
          ),

          // ── Upload progress overlay ──
          Obx(() => _controller.isUploading.value
              ? _buildUploadOverlay()
              : const SizedBox.shrink()),
        ],
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
            color: Colors.black, size: 22.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'upload_bill.appbar_title'.tr,
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w800,
          color: Colors.black,
          height: 1.22,
        ),
      ),
    );
  }

  // ── Info banner ──
  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEFF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF5A1ABE), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.help_outline_rounded,
                  color: Color(0xFF5A1ABE), size: 18),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'upload_bill.info_text'.tr,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {},
            child: Text(
              'upload_bill.info_link'.tr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF5A1ABE),
                height: 1.22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Upload File + Scan File row ──
  Widget _buildUploadScanRow() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildMethodCard(
                method: UploadMethod.uploadFile,
                assetIcon: 'assets/icons/upload.png',
                label: 'upload_bill.upload_file'.tr,
                sublabel: 'upload_bill.upload_formats'.tr,
                onTap: _openFilePicker,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildMethodCard(
                method: UploadMethod.scanFile,
                assetIcon: 'assets/icons/scannn.png',
                label: 'upload_bill.scan_file'.tr,
                sublabel: 'upload_bill.scan_use_camera'.tr,
                onTap: _openCamera,
              ),
            ),
          ],
        ));
  }

  Widget _buildMethodCard({
    required UploadMethod method,
    required String assetIcon,
    required String label,
    required String sublabel,
    required VoidCallback onTap,
  }) {
    final isSelected = _controller.selectedMethod.value == method;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFF5A1ABE),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetIcon,
              width: 56.w,
              height: 56.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.22,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                height: 1.22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── File Preview Card ──
  Widget _buildFilePreview() {
    final fileName = _controller.selectedFileName;
    final fileSize = _controller.selectedFileSize;
    final ext = fileName.split('.').last.toLowerCase();
    final isPdf = ext == 'pdf';

    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7FF),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF5A1ABE), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isPdf
                    ? const Color(0xFFFFEBEE)
                    : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                isPdf
                    ? Icons.picture_as_pdf_rounded
                    : Icons.image_rounded,
                color: isPdf
                    ? const Color(0xFFE53935)
                    : const Color(0xFF43A047),
                size: 24,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${ext.toUpperCase()} • $fileSize',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _controller.removeFile,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFFE53935),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── OCR Extraction Progress ──
  Widget _buildExtractionProgress() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EEFF),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF5A1ABE).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF5A1ABE),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'upload_bill.extracting'.tr,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5A1ABE),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Missing Fields Warning ──
  Widget _buildMissingFieldsWarning() {
    final missing = _controller.missingFields;
    // Translate field labels (some are i18n keys, some are plain text)
    final labels = missing.map((key) {
      if (key.startsWith('upload_bill.')) return key.tr;
      return key; // POD, PDR are already plain text
    }).toList();

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE53935), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: Color(0xFFE53935), size: 18),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'upload_bill.extraction_missing_fields'.tr,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFC62828),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: labels.map((label) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCDD2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC62828),
                  ),
                ),
              )).toList(),
            ),
            SizedBox(height: 10.h),
            Text(
              'upload_bill.extraction_retry_hint'.tr,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── OCR Extracted Data Preview ──
  Widget _buildOcrPreview() {
    final ocr = _controller.ocrResult.value!;
    final items = <_OcrPreviewItem>[];

    if (ocr.supplierName != null) {
      items.add(_OcrPreviewItem('upload_bill.field_supplier'.tr, ocr.supplierName!));
    }
    if (ocr.podNumber != null) {
      items.add(_OcrPreviewItem('upload_bill.field_pod'.tr, ocr.podNumber!));
    }
    if (ocr.pdrNumber != null) {
      items.add(_OcrPreviewItem('upload_bill.field_pdr'.tr, ocr.pdrNumber!));
    }
    if (ocr.totalAmount != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_total'.tr, '€ ${ocr.totalAmount!.toStringAsFixed(2)}'));
    }
    if (ocr.consumptionKwh != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_consumption'.tr, '${ocr.consumptionKwh!.toStringAsFixed(0)} kWh'));
    }
    if (ocr.consumptionSmc != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_consumption'.tr, '${ocr.consumptionSmc!.toStringAsFixed(0)} Smc'));
    }
    if (ocr.costPerUnit != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_cost_per_unit'.tr, '€ ${ocr.costPerUnit!.toStringAsFixed(4)}'));
    }
    if (ocr.fixedCharges != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_fixed_charges'.tr, '€ ${ocr.fixedCharges!.toStringAsFixed(2)}'));
    }
    if (ocr.taxes != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_taxes'.tr, '€ ${ocr.taxes!.toStringAsFixed(2)}'));
    }
    if (ocr.billingPeriodStart != null && ocr.billingPeriodEnd != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_period'.tr,
          '${ocr.billingPeriodStart} — ${ocr.billingPeriodEnd}'));
    }
    if (ocr.supplyAddress != null) {
      items.add(_OcrPreviewItem('upload_bill.field_address'.tr, ocr.supplyAddress!));
    }
    if (ocr.codiceFiscale != null) {
      items.add(_OcrPreviewItem('upload_bill.field_tax_code'.tr, ocr.codiceFiscale!));
    }
    if (ocr.partitaIva != null) {
      items.add(_OcrPreviewItem('upload_bill.field_vat'.tr, ocr.partitaIva!));
    }
    if (ocr.contractNumber != null) {
      items.add(_OcrPreviewItem('upload_bill.field_contract'.tr, ocr.contractNumber!));
    }
    if (ocr.meterNumber != null) {
      items.add(_OcrPreviewItem('upload_bill.field_meter'.tr, ocr.meterNumber!));
    }
    if (ocr.customerName != null) {
      items.add(_OcrPreviewItem('upload_bill.field_customer'.tr, ocr.customerName!));
    }

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF43A047), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF43A047), size: 18),
                SizedBox(width: 8.w),
                Text(
                  'upload_bill.extraction_complete'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ...items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110.w,
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.value,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 6.h),
            Text(
              'upload_bill.extraction_verify'.tr,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error Message ──
  Widget _buildErrorMessage() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 18),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                _controller.errorMessage.value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Upload Button ──
  Widget _buildUploadButton() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: _uploadBill,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A1ABE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'upload_bill.upload_button'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ── Upload Progress Overlay ──
  Widget _buildUploadOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          padding: EdgeInsets.all(28.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF5A1ABE),
                strokeWidth: 3,
              ),
              SizedBox(height: 20.h),
              Text(
                'upload_bill.uploading'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              Obx(() => ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: LinearProgressIndicator(
                      value: _controller.uploadProgress.value,
                      backgroundColor: const Color(0xFFE8E8E8),
                      color: const Color(0xFF5A1ABE),
                      minHeight: 8.h,
                    ),
                  )),
              SizedBox(height: 8.h),
              Obx(() => Text(
                    '${(_controller.uploadProgress.value * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5A1ABE),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // ── OR divider ──
  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(
            child: Divider(color: Color(0xFF5A1ABE), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'upload_bill.or_divider'.tr,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.w900,
              height: 1.22,
            ),
          ),
        ),
        const Expanded(
            child: Divider(color: Color(0xFF5A1ABE), thickness: 1)),
      ],
    );
  }

  // ── Send Our Email card ──
  Widget _buildEmailCard() {
    return GestureDetector(
      onTap: () {
        _controller.selectMethod(UploadMethod.sendEmail);
        Get.to(() => EmailBillScreen());
      },
      child: Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: const Color(0xFF5A1ABE),
                width:
                    _controller.selectedMethod.value == UploadMethod.sendEmail
                        ? 2.0
                        : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EF),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                        color: const Color(0xFF5A1ABE), width: 1),
                  ),
                  child: const Icon(Icons.mail_outline_rounded,
                      color: Color(0xFF27AE60), size: 22),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'upload_bill.send_email'.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.22,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'upload_bill.send_email_address'.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.black, size: 20),
              ],
            ),
          )),
    );
  }

  // ── What we are looking for card ──
  Widget _buildLookingForCard() {
    final bullets = [
      'upload_bill.looking_for_1'.tr,
      'upload_bill.looking_for_2'.tr,
      'upload_bill.looking_for_3'.tr,
      'upload_bill.looking_for_4'.tr,
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF0FF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF5A1ABE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'upload_bill.looking_for_title'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 1.22,
            ),
          ),
          SizedBox(height: 10.h),
          ...bullets.map(
            (b) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      height: 1.22,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        height: 1.22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper class for OCR preview items ──
class _OcrPreviewItem {
  final String label;
  final String value;
  const _OcrPreviewItem(this.label, this.value);
}
