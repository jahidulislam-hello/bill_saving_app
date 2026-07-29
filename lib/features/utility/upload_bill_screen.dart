import 'package:vyzi/core/navbar/nav_helper.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/bills/screen/bill_detail_screen.dart';
import 'package:vyzi/features/bills/screen/bills_list_screen.dart';
import 'package:vyzi/features/home/email/email_bill_screen.dart';
import 'package:vyzi/features/utility/controller/select_utility_controller.dart';
import 'package:vyzi/features/utility/controller/upload_bill_controller.dart';
import 'package:vyzi/features/utility/widgets/file_preview_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import 'multi_capture_screen.dart';

class UploadBillScreen extends StatefulWidget {
  final UtilityType utilityType;

  const UploadBillScreen({super.key, required this.utilityType});

  @override
  State<UploadBillScreen> createState() => _UploadBillScreenState();
}

class _UploadBillScreenState extends State<UploadBillScreen> {
  final UploadBillController _controller = Get.put(UploadBillController());

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

  /// Opens multi-file picker for "Upload File" method
  Future<void> _openMultiFilePicker() async {
    _controller.selectMethod(UploadMethod.uploadFile);

    if (_controller.isAtFileLimit) {
      Get.snackbar(
        'upload_bill.file_validation_title'.tr,
        'upload_bill.max_files_reached'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await _controller.pickMultipleFiles();
  }

  /// Opens custom camera for continuous multi-photo scanning session.
  Future<void> _openCamera() async {
    _controller.selectMethod(UploadMethod.scanFile);

    final existingCount = _controller.selectedFiles.length;
    if (existingCount >= UploadBillController.maxFileCount) {
      Get.snackbar(
        'upload_bill.file_validation_title'.tr,
        'upload_bill.max_files_reached'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final paths = await Navigator.of(context, rootNavigator: true).push<List<String>>(
      MaterialPageRoute(
        builder: (_) => MultiCaptureScreen(
          existingCount: existingCount,
          maxCount: UploadBillController.maxFileCount,
        ),
      ),
    );

    if (paths != null && paths.isNotEmpty) {
      await _controller.addCapturedPhotoPaths(paths);
    }
  }

  /// Triggers single-file upload (scan flow)
  Future<void> _uploadSingleBill() async {
    await _controller.uploadBill(widget.utilityType);
    if (_controller.uploadSuccess.value && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('upload_bill.upload_success'.tr),
          backgroundColor: const Color(0xFF1FC16B),
        ),
      );
      if (_controller.uploadedBillId.value.isNotEmpty) {
        NavHelper.pushReplacement(BillDetailScreen(billId: _controller.uploadedBillId.value));
      } else {
        NavHelper.pushReplacement(BillsListScreen());
      }
    }
  }

  /// Triggers batch upload for multi-file flow
  Future<void> _uploadAllFiles() async {
    await _controller.uploadAllFiles(widget.utilityType);
  }

  /// Retries a single failed file
  void _retrySingleFile(String fileId) {
    _controller.retrySingleFile(fileId, widget.utilityType);
  }

  /// Retries all failed files
  void _retryAllFailed() {
    _controller.retryAllFailed(widget.utilityType);
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
        child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                16.w, 24.h, 16.w, 24.h),
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

                // ── Multi-file content (uploadFile & scanFile) or single-file ──
                Obx(() {
                  final method = _controller.selectedMethod.value;
                  if (method == UploadMethod.uploadFile ||
                      method == UploadMethod.scanFile) {
                    return _buildMultiFileContent();
                  }
                  return _buildSingleFileContent();
                }),

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

          // ── Upload progress overlay (single-file only) ──
          Obx(() => _controller.isUploading.value
              ? _buildUploadOverlay()
              : const SizedBox.shrink()),
        ],
      ),
      ),
    );
  }

  // ─── Multi-file content ──────────────────────────────

  Widget _buildMultiFileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File preview list
        FilePreviewList(
          controller: _controller,
          onRetrySingle: _retrySingleFile,
        ),

        // Add More Files / Take Another Photo button
        Obx(() {
          if (_controller.selectedFiles.isEmpty) return const SizedBox.shrink();
          if (_controller.isAtFileLimit) return const SizedBox.shrink();
          if (_controller.isBatchUploading.value) return const SizedBox.shrink();
          if (_controller.batchUploadCompleted.value) return const SizedBox.shrink();

          final isScanMode =
              _controller.selectedMethod.value == UploadMethod.scanFile;
          final label = isScanMode
              ? 'upload_bill.take_another_photo'.tr
              : 'upload_bill.add_more_files'.tr;
          final icon = isScanMode
              ? Icons.camera_alt_rounded
              : Icons.add_rounded;

          return Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Semantics(
              label: label,
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isScanMode ? _openCamera : _openMultiFilePicker,
                  icon: Icon(icon, size: 18),
                  label: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF5A1ABE),
                    side: const BorderSide(color: Color(0xFF5A1ABE)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),
          );
        }),

        // Overall progress during batch upload
        Obx(() {
          if (!_controller.isBatchUploading.value) {
            return const SizedBox.shrink();
          }
          final total = _controller.totalFileCount;
          final processed = _controller.uploadedFilesMulti.length +
              _controller.failedFiles.length;
          return Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EEFF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: const Color(0xFF5A1ABE).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF5A1ABE),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'upload_bill.uploading_progress'.trParams({
                          'current': (processed + 1).toString(),
                          'total': total.toString(),
                        }),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5A1ABE),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _controller.cancelBatchUpload,
                        child: Text(
                          'upload_bill.cancel'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE53935),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: _controller.overallProgress,
                      backgroundColor: const Color(0xFFE8E8E8),
                      color: const Color(0xFF5A1ABE),
                      minHeight: 6.h,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        // Post-upload summary
        Obx(() {
          if (!_controller.batchUploadCompleted.value) {
            return const SizedBox.shrink();
          }
          final uploaded = _controller.uploadedFilesMulti.length;
          final failed = _controller.failedFiles.length;

          return Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: failed == 0
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: failed == 0
                      ? const Color(0xFF43A047)
                      : const Color(0xFFFF9800),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        failed == 0
                            ? Icons.check_circle_rounded
                            : Icons.warning_amber_rounded,
                        color: failed == 0
                            ? const Color(0xFF43A047)
                            : const Color(0xFFFF9800),
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'upload_bill.batch_complete'.trParams({
                            'uploaded': uploaded.toString(),
                            'failed': failed.toString(),
                          }),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      if (failed > 0) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _retryAllFailed,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFF9800),
                              side: const BorderSide(
                                  color: Color(0xFFFF9800)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                            ),
                            child: Text(
                              'upload_bill.retry_failed'.tr,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (uploaded > 0) {
                              NavHelper.pushReplacement(BillsListScreen());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A1ABE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            elevation: 0,
                          ),
                          child: Text(
                            'upload_bill.done'.tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),

        // Upload button for multi-file
        Obx(() {
          if (_controller.batchUploadCompleted.value) {
            return const SizedBox.shrink();
          }
          if (_controller.isBatchUploading.value) {
            return const SizedBox.shrink();
          }
          final pendingCount = _controller.pendingFiles.length;
          if (pendingCount == 0) return const SizedBox.shrink();

          return Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Semantics(
              label: 'upload_bill.upload_x_files'
                  .trParams({'count': pendingCount.toString()}),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _uploadAllFiles,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A1ABE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'upload_bill.upload_x_files'
                        .trParams({'count': pendingCount.toString()}),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── Single-file content (camera/scan flow) ──────────

  Widget _buildSingleFileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File preview (if selected)
        Obx(() => _controller.selectedFile.value != null
            ? _buildFilePreview()
            : const SizedBox.shrink()),

        // OCR extraction progress
        Obx(() => _controller.isExtracting.value
            ? _buildExtractionProgress()
            : const SizedBox.shrink()),

        // OCR extracted data preview
        Obx(() => _controller.ocrCompleted.value &&
                _controller.ocrResult.value?.hasAnyData == true
            ? _buildOcrPreview()
            : const SizedBox.shrink()),

        // Missing fields warning
        Obx(() => _controller.ocrCompleted.value &&
                _controller.missingFields.isNotEmpty
            ? _buildMissingFieldsWarning()
            : const SizedBox.shrink()),

        // Error message
        Obx(() => _controller.errorMessage.value.isNotEmpty &&
                _controller.missingFields.isEmpty
            ? _buildErrorMessage()
            : const SizedBox.shrink()),

        // Upload button (only when all fields extracted)
        Obx(() => _controller.selectedFile.value != null &&
                !_controller.isUploading.value &&
                !_controller.isExtracting.value &&
                _controller.canUpload
            ? _buildUploadButton()
            : const SizedBox.shrink()),
      ],
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

  // ── Why we need it popup ──
  void _showWhyWeNeedItPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFF5A1ABE),
                size: 40.w,
              ),
              SizedBox(height: 12.h),
              Text(
                'upload_bill.info_popup_title'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'upload_bill.info_popup_body'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A1ABE),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'upload_bill.info_popup_close'.tr,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
            onTap: () => _showWhyWeNeedItPopup(context),
            child: Text(
              'upload_bill.info_link'.tr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF5A1ABE),
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF5A1ABE),
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
                onTap: _openMultiFilePicker,
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

  // ── File Preview Card (single-file) ──
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
    final labels = missing.map((key) {
      if (key.startsWith('upload_bill.')) return key.tr;
      return key;
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
              children: labels
                  .map((label) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
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
                      ))
                  .toList(),
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
      items.add(
          _OcrPreviewItem('upload_bill.field_supplier'.tr, ocr.supplierName!));
    }
    if (ocr.podNumber != null) {
      items.add(_OcrPreviewItem('upload_bill.field_pod'.tr, ocr.podNumber!));
    }
    if (ocr.pdrNumber != null) {
      items.add(_OcrPreviewItem('upload_bill.field_pdr'.tr, ocr.pdrNumber!));
    }
    if (ocr.totalAmount != null) {
      items.add(_OcrPreviewItem('upload_bill.field_total'.tr,
          '€ ${ocr.totalAmount!.toStringAsFixed(2)}'));
    }
    if (ocr.consumptionKwh != null) {
      items.add(_OcrPreviewItem('upload_bill.field_consumption'.tr,
          '${ocr.consumptionKwh!.toStringAsFixed(0)} kWh'));
    }
    if (ocr.consumptionSmc != null) {
      items.add(_OcrPreviewItem('upload_bill.field_consumption'.tr,
          '${ocr.consumptionSmc!.toStringAsFixed(0)} Smc'));
    }
    if (ocr.costPerUnit != null) {
      items.add(_OcrPreviewItem('upload_bill.field_cost_per_unit'.tr,
          '€ ${ocr.costPerUnit!.toStringAsFixed(4)}'));
    }
    if (ocr.fixedCharges != null) {
      items.add(_OcrPreviewItem('upload_bill.field_fixed_charges'.tr,
          '€ ${ocr.fixedCharges!.toStringAsFixed(2)}'));
    }
    if (ocr.taxes != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_taxes'.tr, '€ ${ocr.taxes!.toStringAsFixed(2)}'));
    }
    if (ocr.billingPeriodStart != null && ocr.billingPeriodEnd != null) {
      items.add(_OcrPreviewItem('upload_bill.field_period'.tr,
          '${ocr.billingPeriodStart} — ${ocr.billingPeriodEnd}'));
    }
    if (ocr.supplyAddress != null) {
      items.add(
          _OcrPreviewItem('upload_bill.field_address'.tr, ocr.supplyAddress!));
    }
    if (ocr.codiceFiscale != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_tax_code'.tr, ocr.codiceFiscale!));
    }
    if (ocr.partitaIva != null) {
      items.add(_OcrPreviewItem('upload_bill.field_vat'.tr, ocr.partitaIva!));
    }
    if (ocr.contractNumber != null) {
      items.add(_OcrPreviewItem(
          'upload_bill.field_contract'.tr, ocr.contractNumber!));
    }
    if (ocr.meterNumber != null) {
      items
          .add(_OcrPreviewItem('upload_bill.field_meter'.tr, ocr.meterNumber!));
    }
    if (ocr.customerName != null) {
      items.add(
          _OcrPreviewItem('upload_bill.field_customer'.tr, ocr.customerName!));
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

  // ── Upload Button (single-file) ──
  Widget _buildUploadButton() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Semantics(
        label: 'upload_bill.upload_button'.tr,
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _uploadSingleBill,
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
      ),
    );
  }

  // ── Upload Progress Overlay (single-file) ──
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
        NavHelper.push(EmailBillScreen(
              billType:
                  widget.utilityType == UtilityType.luce ? 'electricity' : 'gas',
            ));
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
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EF),
                    borderRadius: BorderRadius.circular(12.r),
                    border:
                        Border.all(color: const Color(0xFF5A1ABE), width: 1),
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
