import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_colors.dart';
import '../controller/bill_verification_controller.dart';
import '../models/bill_verification_model.dart';

class BillVerificationScreen extends StatelessWidget {
  const BillVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final billId = Get.arguments as String;
    final controller = Get.put(BillVerificationController(billId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Verification Required'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48.w, color: Colors.red.shade300),
                  SizedBox(height: 12.h),
                  Text(
                    controller.error.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: controller.fetchVerification,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final verification = controller.verification.value;
        if (verification == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline, size: 48.w, color: Colors.green),
                  SizedBox(height: 12.h),
                  Text(
                    'No pending verification',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.submitSuccess.value) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 64.w, color: Colors.green),
                  SizedBox(height: 16.h),
                  Text(
                    'Verification Submitted',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Your response has been sent. The bill will be re-analyzed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          );
        }

        return _VerificationForm(
          verification: verification,
          controller: controller,
        );
      }),
    );
  }
}

class _VerificationForm extends StatelessWidget {
  final BillVerificationModel verification;
  final BillVerificationController controller;

  const _VerificationForm({
    required this.verification,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Admin message card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 20.w, color: Colors.orange.shade700),
                    SizedBox(width: 8.w),
                    Text(
                      'Message from Admin',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  verification.adminMessage,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.orange.shade900,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Re-upload section
          if (verification.requireReupload) ...[
            SizedBox(height: 20.h),
            Text(
              'Re-upload Document',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please upload a clearer or complete version of your bill.',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 12.h),
            Obx(() {
              if (controller.isUploading.value) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      LinearProgressIndicator(value: controller.uploadProgress.value),
                      SizedBox(height: 8.h),
                      Text(
                        '${(controller.uploadProgress.value * 100).toInt()}%',
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              if (controller.reuploadFilePath.value.isNotEmpty) {
                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 20.w, color: Colors.green),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'File uploaded successfully',
                          style: TextStyle(fontSize: 13.sp, color: Colors.green.shade800),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickAndUploadFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Document'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              );
            }),
          ],

          // Missing fields section
          if (verification.missingFields.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(
              'Complete Missing Information',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Please fill in the following fields:',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 12.h),
            ...verification.missingFields.map((field) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: verification.labelForField(field),
                    labelStyle: TextStyle(fontSize: 13.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                  ),
                  onChanged: (value) => controller.setFieldValue(field, value),
                  keyboardType: _keyboardTypeForField(field),
                ),
              );
            }),
          ],

          // User message
          SizedBox(height: 16.h),
          Text(
            'Your Message (optional)',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add any additional information...',
              hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              contentPadding: EdgeInsets.all(14.w),
            ),
            onChanged: (value) => controller.userMessage.value = value,
          ),

          // Submit button
          SizedBox(height: 24.h),
          Obx(() => SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value ? null : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: controller.isSubmitting.value
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit Verification',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  TextInputType _keyboardTypeForField(String field) {
    const numericFields = {
      'totalAmount', 'consumptionKwh', 'consumptionSmc',
      'costPerUnit', 'fixedCharges', 'taxes',
    };
    if (numericFields.contains(field)) {
      return const TextInputType.numberWithOptions(decimal: true);
    }
    return TextInputType.text;
  }

  Future<void> _pickAndUploadFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      controller.uploadFile(result.files.single.path!);
    }
  }
}
