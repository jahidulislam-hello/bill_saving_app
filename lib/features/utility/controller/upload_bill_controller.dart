import 'dart:io';

import 'package:dio/dio.dart' hide Response;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/bill_ocr_service.dart';
import 'select_utility_controller.dart';

enum UploadMethod { uploadFile, scanFile, sendEmail }

class UploadBillController extends GetxController {
  // Selection state
  final Rx<UploadMethod?> selectedMethod = Rx<UploadMethod?>(null);
  final Rx<XFile?> selectedFile = Rx<XFile?>(null);

  // Upload state
  final RxDouble uploadProgress = 0.0.obs;
  final RxBool isUploading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString uploadedBillId = ''.obs;
  final RxBool uploadSuccess = false.obs;

  // OCR state
  final Rx<BillOcrResult?> ocrResult = Rx<BillOcrResult?>(null);
  final RxBool isExtracting = false.obs;
  final RxBool ocrCompleted = false.obs;

  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedExtensions = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
  ];

  final BillOcrService _ocrService = BillOcrService();

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
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return '';
    }
  }

  // ─── OCR Extraction ─────────────────────────────────────

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

      // Validate all required fields are present
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

  String _currentBillType = 'electricity';

  /// Whether all required fields have been extracted and upload can proceed
  bool get canUpload {
    final ocr = ocrResult.value;
    if (ocr == null) return false;
    return ocr.isComplete(_currentBillType);
  }

  /// List of missing field labels for display
  List<String> get missingFields {
    final ocr = ocrResult.value;
    if (ocr == null) return [];
    return ocr.getMissingFields(_currentBillType);
  }

  // ─── Upload ─────────────────────────────────────────────

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
      // Build data map with billType + any OCR-extracted fields
      final data = <String, dynamic>{
        'billType': billType,
      };

      final ocr = ocrResult.value;
      if (ocr != null && ocr.hasAnyData) {
        if (ocr.supplierName != null) data['supplierName'] = ocr.supplierName!;
        if (ocr.podNumber != null) data['podNumber'] = ocr.podNumber!;
        if (ocr.pdrNumber != null) data['pdrNumber'] = ocr.pdrNumber!;
        if (ocr.totalAmount != null) data['totalAmount'] = ocr.totalAmount.toString();
        if (ocr.consumptionKwh != null) data['consumptionKwh'] = ocr.consumptionKwh.toString();
        if (ocr.consumptionSmc != null) data['consumptionSmc'] = ocr.consumptionSmc.toString();
        if (ocr.costPerUnit != null) data['costPerUnit'] = ocr.costPerUnit.toString();
        if (ocr.fixedCharges != null) data['fixedCharges'] = ocr.fixedCharges.toString();
        if (ocr.taxes != null) data['taxes'] = ocr.taxes.toString();
        if (ocr.billingPeriodStart != null) data['billingPeriodStart'] = ocr.billingPeriodStart!;
        if (ocr.billingPeriodEnd != null) data['billingPeriodEnd'] = ocr.billingPeriodEnd!;
        if (ocr.supplyAddress != null) data['supplyAddress'] = ocr.supplyAddress!;
        if (ocr.codiceFiscale != null) data['codiceFiscale'] = ocr.codiceFiscale!;
        if (ocr.partitaIva != null) data['partitaIva'] = ocr.partitaIva!;
        if (ocr.contractNumber != null) data['contractNumber'] = ocr.contractNumber!;
        if (ocr.meterNumber != null) data['meterNumber'] = ocr.meterNumber!;
        if (ocr.customerName != null) data['customerName'] = ocr.customerName!;
      }

      final dynamic response;

      // If file was already saved during extraction, skip re-upload
      if (ocr?.fileUrl != null) {
        data['fileUrl'] = ocr!.fileUrl!;
        uploadProgress.value = 1.0;
        response = await ApiService().post(
          ApiConstants.uploadBills,
          data: data,
        );
      } else {
        // No prior extraction — upload the file
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
        final respBody = responseData is Map && responseData.containsKey('data')
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
  }
}
