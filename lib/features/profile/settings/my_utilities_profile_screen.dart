import 'package:vyzi/core/navbar/nav_helper.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/home/controller/home_controller.dart';
import 'package:vyzi/features/home/model/user_service_model.dart';
import 'package:vyzi/features/my_utility/utility_details_screen.dart';
import 'package:vyzi/features/utility/select_utility_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyUtilitiesProfileScreen extends StatelessWidget {
  const MyUtilitiesProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    controller.fetchServices();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: AppColors.textDark, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'my_utility.title'.tr,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
            child: Text(
              'my_utility.subtitle'.tr,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingServices.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.serviceList.isEmpty) {
                return _emptyState();
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.serviceList.length,
                itemBuilder: (_, i) =>
                    _ServiceTile(service: controller.serviceList[i]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.electrical_services_outlined,
                  size: 40.sp, color: AppColors.primaryColor),
            ),
            SizedBox(height: 20.h),
            Text(
              'my_utility.no_utilities'.tr,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'my_utility.subtitle'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 28.h),
            GestureDetector(
              onTap: () => NavHelper.push(const SelectUtilityScreen()),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 28.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  'my_utility.upload_button'.tr,
                  style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Service Tile ──
class _ServiceTile extends StatelessWidget {
  final UserServiceModel service;
  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavHelper.push(UtilityDetailsScreen()),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFF7B48CB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      service.energyType == 'gas'
                          ? Icons.local_fire_department
                          : Icons.bolt,
                      color: AppColors.background,
                      size: 26.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.supplierName ?? service.offerName ?? '',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        service.energyType ?? '',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                _meta(
                  'utility.pod_label'.tr,
                  service.podPdrNumber ?? '',
                  align: CrossAxisAlignment.end,
                ),
              ],
            ),
            SizedBox(height: 14.h),
            const Divider(color: AppColors.divider, height: 1),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _meta('utility.offer_name'.tr, service.offerName ?? ''),
                _meta(
                  'utility.activation'.tr,
                  _formatDate(service.activationDate),
                  align: CrossAxisAlignment.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }

  Widget _meta(String label, String value,
      {CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 11.sp)),
        SizedBox(height: 2.h),
        Text(value,
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
