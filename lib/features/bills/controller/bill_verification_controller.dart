import 'package:dio/dio.dart' hide Response;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../models/bill_verification_model.dart';

class BillVerificationController extends GetxController {
  final String billId;
  BillVerificationController(this.billId);

  final Rx<BillVerificationModel?> verification =
      Rx<BillVerificationModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  // Form state
  final RxMap<String, String> fieldValues = <String, String>{}.obs;
  final RxString userMessage = ''.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool submitSuccess = false.obs;

  // Re-upload state
  final RxString reuploadFilePath = ''.obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVerification();
  }

  Future<void> fetchVerification() async {
    isLoading.value = true;
    error.value = '';

    try {
      final response = await ApiService().get(
        ApiConstants.getBillVerification(billId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final body = data is Map && data.containsKey('data')
            ? data['data']
            : data;

        if (body != null && body is Map<String, dynamic>) {
          verification.value = BillVerificationModel.fromJson(body);
        } else {
          verification.value = null;
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch verification: $e');
      error.value = 'Failed to load verification details';
    } finally {
      isLoading.value = false;
    }
  }

  void setFieldValue(String field, String value) {
    fieldValues[field] = value;
  }

  Future<void> uploadFile(String filePath) async {
    isUploading.value = true;
    uploadProgress.value = 0.0;

    try {
      final multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      );
      final response = await ApiService().uploadFileWithProgress(
        ApiConstants.addFileToBill(billId),
        file: multipartFile,
        onSendProgress: (sent, total) {
          if (total > 0) uploadProgress.value = sent / total;
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        reuploadFilePath.value = filePath;
        debugPrint('Re-upload successful for bill $billId');
      }
    } catch (e) {
      debugPrint('Re-upload failed: $e');
      Get.snackbar(
        'Upload Failed',
        'Could not upload the file. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> submit() async {
    isSubmitting.value = true;

    try {
      final body = <String, dynamic>{};

      if (userMessage.value.isNotEmpty) {
        body['message'] = userMessage.value;
      }

      if (fieldValues.isNotEmpty) {
        // Convert numeric fields
        final numericFields = {
          'totalAmount', 'consumptionKwh', 'consumptionSmc',
          'costPerUnit', 'fixedCharges', 'taxes',
        };
        final converted = <String, dynamic>{};
        for (final entry in fieldValues.entries) {
          if (entry.value.isEmpty) continue;
          if (numericFields.contains(entry.key)) {
            converted[entry.key] = double.tryParse(entry.value) ?? entry.value;
          } else {
            converted[entry.key] = entry.value;
          }
        }
        if (converted.isNotEmpty) {
          body['fieldValues'] = converted;
        }
      }

      final response = await ApiService().post(
        ApiConstants.submitBillVerification(billId),
        data: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        submitSuccess.value = true;
        Get.snackbar(
          'Submitted',
          'Your verification response has been sent.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Verification submit failed: $e');
      Get.snackbar(
        'Error',
        'Failed to submit. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
