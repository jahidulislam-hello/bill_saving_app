import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart' hide Response;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/bill_ocr_service.dart';
import '../models/selected_file.dart';
import 'select_utility_controller.dart';

enum UploadMethod { uploadFile, scanFile, sendEmail }

class UploadBillController extends GetxController {
  // ─── Single-file state (used by camera/scan flow) ──────
  final Rx<UploadMethod?> selectedMethod = Rx<UploadMethod?>(null);
  final Rx<XFile?> selectedFile = Rx<XFile?>(null);

  // Upload state (single-file)
  final RxDouble uploadProgress = 0.0.obs;
  final RxBool isUploading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString uploadedBillId = ''.obs;
  final RxBool uploadSuccess = false.obs;

  // OCR state (single-file)
  final Rx<BillOcrResult?> ocrResult = Rx<BillOcrResult?>(null);
  final RxBool isExtracting = false.obs;
  final RxBool ocrCompleted = false.obs;

  // ─── Multi-file state ──────────────────────────────────
  final RxList<SelectedFile> selectedFiles = <SelectedFile>[].obs;
  final RxBool isBatchUploading = false.obs;
  final RxBool batchUploadCompleted = false.obs;
  final RxBool isCancelled = false.obs;
  final RxInt currentUploadIndex = 0.obs;

  // ─── Constants ─────────────────────────────────────────
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB
  static const int maxFileCount = 10;
  static const List<String> allowedExtensions = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
    'heic',
    'webp',
  ];

  final BillOcrService _ocrService = BillOcrService();
  String _currentBillType = 'electricity';

  // ─── Single-file methods (existing, for scan/camera) ───

  void selectMethod(UploadMethod method) {
    selectedMethod.value = method;
  }

  void setSelectedFile(XFile file) {
    selectedFile.value = file;
    errorMessage.value = '';
    uploadSuccess.value = false;
    ocrResult.value = null;
    ocrCompleted.value = false;
  }

  void removeFile() {
    selectedFile.value = null;
    errorMessage.value = '';
    uploadSuccess.value = false;
    uploadedBillId.value = '';
    ocrResult.value = null;
    ocrCompleted.value = false;
  }

  bool validateFile(XFile file) {
    final ext = file.name.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(ext)) {
      errorMessage.value = 'upload_bill.invalid_file_type'.tr;
      return false;
    }
    return true;
  }

  Future<bool> validateFileSize(XFile file) async {
    final fileSize = await File(file.path).length();
    if (fileSize > maxFileSizeBytes) {
      errorMessage.value = 'upload_bill.file_too_large'.tr;
      return false;
    }
    return true;
  }

  String get selectedFileName {
    final file = selectedFile.value;
    if (file == null) return '';
    return file.name;
  }

  String get selectedFileSize {
    final file = selectedFile.value;
    if (file == null) return '';
    try {
      final bytes = File(file.path).lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) {
        return '${(bytes / 1024).toStringAsFixed(1)} KB';
      }
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return '';
    }
  }

  // ─── OCR Extraction (single-file) ─────────────────────

  Future<void> runOcrExtraction(String billType) async {
    final file = selectedFile.value;
    if (file == null) return;

    if (!BillOcrService.isSupported(file.path)) {
      ocrCompleted.value = true;
      errorMessage.value = 'upload_bill.invalid_file_type'.tr;
      return;
    }

    isExtracting.value = true;
    errorMessage.value = '';
    _currentBillType = billType;

    try {
      final result = await _ocrService.extractFromFile(file.path, billType);
      ocrResult.value = result;
      debugPrint('OCR completed: hasData=${result.hasAnyData}');

      if (!result.hasAnyData) {
        errorMessage.value = 'upload_bill.extraction_no_data'.tr;
      } else {
        final missing = result.getMissingFields(billType);
        if (missing.isNotEmpty) {
          errorMessage.value = 'upload_bill.extraction_missing_fields'.tr;
        }
      }
    } catch (e) {
      debugPrint('OCR extraction error: $e');
      errorMessage.value = 'upload_bill.extraction_failed'.tr;
    } finally {
      isExtracting.value = false;
      ocrCompleted.value = true;
    }
  }

  bool get canUpload {
    final ocr = ocrResult.value;
    if (ocr == null) return false;
    return ocr.isComplete(_currentBillType);
  }

  List<String> get missingFields {
    final ocr = ocrResult.value;
    if (ocr == null) return [];
    return ocr.getMissingFields(_currentBillType);
  }

  // ─── Upload (single-file) ─────────────────────────────

  Future<void> uploadBill(UtilityType utilityType) async {
    final file = selectedFile.value;
    if (file == null) {
      errorMessage.value = 'No file selected';
      return;
    }

    if (!validateFile(file)) return;
    if (!await validateFileSize(file)) return;

    final billType =
        utilityType == UtilityType.luce ? 'electricity' : 'gas';

    isUploading.value = true;
    uploadProgress.value = 0.0;
    errorMessage.value = '';

    try {
      final data = <String, dynamic>{
        'billType': billType,
      };

      final ocr = ocrResult.value;
      if (ocr != null && ocr.hasAnyData) {
        _addOcrDataToMap(data, ocr);
      }

      final dynamic response;

      if (ocr?.fileUrl != null) {
        data['fileUrl'] = ocr!.fileUrl!;
        uploadProgress.value = 1.0;
        response = await ApiService().post(
          ApiConstants.uploadBills,
          data: data,
        );
      } else {
        final multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        );
        response = await ApiService().uploadFileWithProgress(
          ApiConstants.uploadBills,
          file: multipartFile,
          data: data,
          onSendProgress: (sent, total) {
            if (total > 0) {
              uploadProgress.value = sent / total;
            }
          },
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final respBody = responseData is Map &&
                responseData.containsKey('data')
            ? responseData['data']
            : responseData;

        uploadedBillId.value = respBody?['id']?.toString() ?? '';
        uploadSuccess.value = true;
        debugPrint('Bill uploaded successfully: ${uploadedBillId.value}');
      } else {
        errorMessage.value = 'upload_bill.upload_failed'.tr;
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      errorMessage.value = 'upload_bill.upload_failed'.tr;
    } finally {
      isUploading.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════
  //  MULTI-FILE METHODS
  // ═══════════════════════════════════════════════════════

  // ─── 2.1 / 2.2: Add files with validation ─────────────

  /// Picks multiple files using file_picker and adds them to selectedFiles.
  /// Returns the number of files actually added.
  Future<int> pickMultipleFiles() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'heic', 'webp'],
      );

      if (result == null || result.files.isEmpty) return 0;

      return addFiles(result.files);
    } on Exception catch (e) {
      debugPrint('File picker error: $e');
      // Handle permission denied or storage access errors
      final msg = e.toString().toLowerCase();
      if (msg.contains('permission') || msg.contains('denied')) {
        Get.snackbar(
          'upload_bill.permission_required_title'.tr,
          'upload_bill.permission_required_message'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      } else if (msg.contains('security') || msg.contains('access')) {
        Get.snackbar(
          'upload_bill.file_validation_title'.tr,
          'upload_bill.error_storage_access'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return 0;
    }
  }

  /// Validates and adds files to the selectedFiles list.
  /// Handles duplicate detection, type validation, size validation,
  /// and max count enforcement.
  int addFiles(List<PlatformFile> files) {
    final List<String> skippedDuplicates = [];
    final List<String> skippedInvalid = [];
    final List<String> skippedOversized = [];
    int skippedOverLimit = 0;
    int added = 0;

    for (final file in files) {
      if (file.path == null) continue;

      // Max count check
      if (selectedFiles.length >= maxFileCount) {
        skippedOverLimit += (files.length - files.indexOf(file));
        break;
      }

      final ext = file.extension?.toLowerCase() ?? '';
      final name = file.name;
      final size = file.size;

      // Type validation
      if (!allowedExtensions.contains(ext)) {
        skippedInvalid.add(name);
        continue;
      }

      // Size validation
      if (size > maxFileSizeBytes) {
        final sizeMb = (size / (1024 * 1024)).toStringAsFixed(1);
        skippedOversized.add('$name ($sizeMb MB)');
        continue;
      }

      // Duplicate detection (name + size)
      final isDuplicate = selectedFiles.any(
        (existing) => existing.name == name && existing.sizeBytes == size,
      );
      if (isDuplicate) {
        skippedDuplicates.add(name);
        continue;
      }

      // Create SelectedFile
      final selectedFile = SelectedFile(
        id: '${DateTime.now().microsecondsSinceEpoch}_$added',
        path: file.path!,
        name: name,
        sizeBytes: size,
        extension: ext,
      );

      selectedFiles.add(selectedFile);
      added++;

      // Generate thumbnail asynchronously for images
      if (selectedFile.isImage) {
        _generateThumbnail(selectedFile);
      }
    }

    // Show feedback messages
    _showValidationFeedback(
      skippedDuplicates: skippedDuplicates,
      skippedInvalid: skippedInvalid,
      skippedOversized: skippedOversized,
      skippedOverLimit: skippedOverLimit,
    );

    return added;
  }

  void _showValidationFeedback({
    required List<String> skippedDuplicates,
    required List<String> skippedInvalid,
    required List<String> skippedOversized,
    required int skippedOverLimit,
  }) {
    final messages = <String>[];

    if (skippedDuplicates.isNotEmpty) {
      messages.add(
        'upload_bill.skipped_duplicates'
            .trParams({'files': skippedDuplicates.join(', ')}),
      );
    }
    if (skippedInvalid.isNotEmpty) {
      messages.add(
        'upload_bill.skipped_invalid'
            .trParams({'files': skippedInvalid.join(', ')}),
      );
    }
    if (skippedOversized.isNotEmpty) {
      messages.add(
        'upload_bill.skipped_oversized'
            .trParams({'files': skippedOversized.join(', ')}),
      );
    }
    if (skippedOverLimit > 0) {
      messages.add(
        'upload_bill.skipped_over_limit'
            .trParams({'count': skippedOverLimit.toString()}),
      );
    }

    if (messages.isNotEmpty) {
      Get.snackbar(
        'upload_bill.file_validation_title'.tr,
        messages.join('\n'),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // ─── 2.3: Remove file ────────────────────────────────

  void removeFileById(String fileId) {
    final index = selectedFiles.indexWhere((f) => f.id == fileId);
    if (index == -1) return;
    final file = selectedFiles[index];
    if (file.status == FileUploadStatus.uploaded) return;
    selectedFiles.removeAt(index);
  }

  // ─── 2.4: Clear all files ────────────────────────────

  void clearAllFiles() {
    selectedFiles.clear();
    isBatchUploading.value = false;
    batchUploadCompleted.value = false;
    isCancelled.value = false;
    currentUploadIndex.value = 0;
  }

  // ─── 2.5: Computed getters ───────────────────────────

  List<SelectedFile> get pendingFiles =>
      selectedFiles.where((f) => f.status == FileUploadStatus.pending).toList();

  List<SelectedFile> get failedFiles =>
      selectedFiles.where((f) => f.status == FileUploadStatus.failed).toList();

  List<SelectedFile> get uploadedFilesMulti =>
      selectedFiles.where((f) => f.status == FileUploadStatus.uploaded).toList();

  bool get canStartUpload =>
      selectedFiles.isNotEmpty &&
      !isBatchUploading.value &&
      pendingFiles.isNotEmpty;

  int get totalFileCount => selectedFiles.length;

  double get overallProgress {
    if (selectedFiles.isEmpty) return 0.0;
    final completed = selectedFiles
        .where((f) =>
            f.status == FileUploadStatus.uploaded ||
            f.status == FileUploadStatus.failed)
        .length;
    return completed / selectedFiles.length;
  }

  bool get isAtFileLimit => selectedFiles.length >= maxFileCount;

  // ─── 3.4: Thumbnail generation ────────────────────────

  Future<void> _generateThumbnail(SelectedFile file) async {
    try {
      final imageFile = File(file.path);
      final bytes = await imageFile.readAsBytes();

      // Decode and resize to 200x200 max
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 200,
        targetHeight: 200,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();

      if (byteData != null) {
        final index = selectedFiles.indexWhere((f) => f.id == file.id);
        if (index != -1) {
          selectedFiles[index] = selectedFiles[index].copyWith(
            thumbnail: byteData.buffer.asUint8List(),
          );
        }
      }
    } catch (e) {
      debugPrint('Thumbnail generation failed for ${file.name}: $e');
    }
  }

  // ─── 4.1: Batch upload ───────────────────────────────

  /// Processes all pending files sequentially: extract → upload → next.
  Future<void> uploadAllFiles(UtilityType utilityType) async {
    final billType =
        utilityType == UtilityType.luce ? 'electricity' : 'gas';

    isBatchUploading.value = true;
    batchUploadCompleted.value = false;
    isCancelled.value = false;

    for (int i = 0; i < selectedFiles.length; i++) {
      if (isCancelled.value) break;

      final file = selectedFiles[i];
      if (file.status == FileUploadStatus.uploaded ||
          file.status == FileUploadStatus.extracted) {
        // Already processed or partially processed — skip if uploaded
        if (file.status == FileUploadStatus.uploaded) continue;
      }
      if (file.status != FileUploadStatus.pending &&
          file.status != FileUploadStatus.failed) {
        continue;
      }

      currentUploadIndex.value = i;
      await _processFile(i, billType);
    }

    isBatchUploading.value = false;
    batchUploadCompleted.value = true;
  }

  // ─── 4.2 / 4.3 / 4.4: Per-file processing ───────────

  Future<void> _processFile(int index, String billType) async {
    // Step 1: Extract
    try {
      _updateFileStatus(index, FileUploadStatus.extracting);

      final file = selectedFiles[index];
      final result = await _ocrService.extractFromFile(file.path, billType);

      if (isCancelled.value) return;

      _updateFile(index, (f) => f.copyWith(
        status: FileUploadStatus.extracted,
        ocrResult: result,
        fileUrl: result.fileUrl,
      ));
    } catch (e) {
      debugPrint('Extraction failed for ${selectedFiles[index].name}: $e');
      _updateFile(index, (f) => f.copyWith(
        status: FileUploadStatus.failed,
        errorMessage: _getErrorMessage(e),
      ));
      return; // Don't attempt upload if extraction failed
    }

    if (isCancelled.value) return;

    // Step 2: Upload
    try {
      _updateFileStatus(index, FileUploadStatus.uploading);

      final file = selectedFiles[index];
      final data = <String, dynamic>{'billType': billType};

      final ocr = file.ocrResult;
      if (ocr != null && ocr.hasAnyData) {
        _addOcrDataToMap(data, ocr);
      }

      final dynamic response;

      if (file.fileUrl != null) {
        data['fileUrl'] = file.fileUrl!;
        _updateFile(index, (f) => f.copyWith(progress: 1.0));
        response = await ApiService().post(
          ApiConstants.uploadBills,
          data: data,
        );
      } else {
        final multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        );
        response = await ApiService().uploadFileWithProgress(
          ApiConstants.uploadBills,
          file: multipartFile,
          data: data,
          onSendProgress: (sent, total) {
            if (total > 0) {
              _updateFile(index, (f) => f.copyWith(
                progress: sent / total,
              ));
            }
          },
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final respBody = responseData is Map &&
                responseData.containsKey('data')
            ? responseData['data']
            : responseData;

        final billId = respBody?['id']?.toString() ?? '';
        _updateFile(index, (f) => f.copyWith(
          status: FileUploadStatus.uploaded,
          uploadedBillId: billId,
          progress: 1.0,
        ));
        debugPrint('File uploaded: ${file.name} → bill $billId');
      } else {
        _updateFile(index, (f) => f.copyWith(
          status: FileUploadStatus.failed,
          errorMessage: 'upload_bill.upload_failed'.tr,
        ));
      }
    } catch (e) {
      debugPrint('Upload failed for ${selectedFiles[index].name}: $e');
      _updateFile(index, (f) => f.copyWith(
        status: FileUploadStatus.failed,
        errorMessage: _getErrorMessage(e),
      ));
    }
  }

  // ─── 4.5: Retry single file ──────────────────────────

  Future<void> retrySingleFile(
      String fileId, UtilityType utilityType) async {
    final billType =
        utilityType == UtilityType.luce ? 'electricity' : 'gas';
    final index = selectedFiles.indexWhere((f) => f.id == fileId);
    if (index == -1) return;

    final file = selectedFiles[index];
    if (file.status != FileUploadStatus.failed) return;

    // Reset to pending state
    _updateFile(index, (f) => f.copyWith(
      status: FileUploadStatus.pending,
      progress: 0.0,
      errorMessage: null,
    ));

    isBatchUploading.value = true;
    isCancelled.value = false;
    await _processFile(index, billType);
    isBatchUploading.value = false;
  }

  // ─── 4.6: Retry all failed ───────────────────────────

  Future<void> retryAllFailed(UtilityType utilityType) async {
    final billType =
        utilityType == UtilityType.luce ? 'electricity' : 'gas';

    // Reset all failed files to pending
    for (int i = 0; i < selectedFiles.length; i++) {
      if (selectedFiles[i].status == FileUploadStatus.failed) {
        _updateFile(i, (f) => f.copyWith(
          status: FileUploadStatus.pending,
          progress: 0.0,
          errorMessage: null,
        ));
      }
    }

    isBatchUploading.value = true;
    batchUploadCompleted.value = false;
    isCancelled.value = false;

    for (int i = 0; i < selectedFiles.length; i++) {
      if (isCancelled.value) break;
      if (selectedFiles[i].status != FileUploadStatus.pending) continue;
      currentUploadIndex.value = i;
      await _processFile(i, billType);
    }

    isBatchUploading.value = false;
    batchUploadCompleted.value = true;
  }

  // ─── 4.7: Cancel upload ──────────────────────────────

  void cancelBatchUpload() {
    isCancelled.value = true;
  }

  // ─── Helpers ─────────────────────────────────────────

  void _updateFileStatus(int index, FileUploadStatus status) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles[index] = selectedFiles[index].copyWith(status: status);
    }
  }

  void _updateFile(
      int index, SelectedFile Function(SelectedFile) updater) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles[index] = updater(selectedFiles[index]);
    }
  }

  void _addOcrDataToMap(Map<String, dynamic> data, BillOcrResult ocr) {
    if (ocr.supplierName != null) data['supplierName'] = ocr.supplierName!;
    if (ocr.podNumber != null) data['podNumber'] = ocr.podNumber!;
    if (ocr.pdrNumber != null) data['pdrNumber'] = ocr.pdrNumber!;
    if (ocr.totalAmount != null) {
      data['totalAmount'] = ocr.totalAmount.toString();
    }
    if (ocr.consumptionKwh != null) {
      data['consumptionKwh'] = ocr.consumptionKwh.toString();
    }
    if (ocr.consumptionSmc != null) {
      data['consumptionSmc'] = ocr.consumptionSmc.toString();
    }
    if (ocr.costPerUnit != null) {
      data['costPerUnit'] = ocr.costPerUnit.toString();
    }
    if (ocr.fixedCharges != null) {
      data['fixedCharges'] = ocr.fixedCharges.toString();
    }
    if (ocr.taxes != null) data['taxes'] = ocr.taxes.toString();
    if (ocr.billingPeriodStart != null) {
      data['billingPeriodStart'] = ocr.billingPeriodStart!;
    }
    if (ocr.billingPeriodEnd != null) {
      data['billingPeriodEnd'] = ocr.billingPeriodEnd!;
    }
    if (ocr.supplyAddress != null) {
      data['supplyAddress'] = ocr.supplyAddress!;
    }
    if (ocr.codiceFiscale != null) {
      data['codiceFiscale'] = ocr.codiceFiscale!;
    }
    if (ocr.partitaIva != null) data['partitaIva'] = ocr.partitaIva!;
    if (ocr.contractNumber != null) {
      data['contractNumber'] = ocr.contractNumber!;
    }
    if (ocr.meterNumber != null) data['meterNumber'] = ocr.meterNumber!;
    if (ocr.customerName != null) {
      data['customerName'] = ocr.customerName!;
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return 'upload_bill.error_network'.tr;
      }
      if (error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'upload_bill.error_timeout'.tr;
      }
      final statusCode = error.response?.statusCode;
      if (statusCode != null && statusCode >= 500) {
        return 'upload_bill.error_server'.tr;
      }
    }
    if (error is FileSystemException) {
      return 'upload_bill.error_file_access'.tr;
    }
    return 'upload_bill.upload_failed'.tr;
  }

  // ─── Clear ───────────────────────────────────────────

  void clearState() {
    selectedMethod.value = null;
    selectedFile.value = null;
    uploadProgress.value = 0.0;
    isUploading.value = false;
    errorMessage.value = '';
    uploadedBillId.value = '';
    uploadSuccess.value = false;
    ocrResult.value = null;
    isExtracting.value = false;
    ocrCompleted.value = false;
    clearAllFiles();
  }
}
