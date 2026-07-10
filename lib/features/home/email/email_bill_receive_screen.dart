import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/home/email/email_bill_receive_controller.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:get/get.dart';



class EmailBillReceivedScreen extends StatelessWidget {
  EmailBillReceivedScreen({super.key});

  final controller = Get.put(EmailBillReceivedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// Success Circle
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF6FE3C1).withOpacity(0.25),
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Title
              Text(
                'home.email_bill_received.title'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              /// Subtitle
              Text(
                'home.email_bill_received.subtitle'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              /// Analysis Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header Row
                    Row(
                      children: [
                        const Icon(Icons.analytics_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'home.email_bill_received.analysis_in_progress'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Progress Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'home.email_bill_received.searching_optimizations'.tr,
                          style: const TextStyle(fontSize: 13),
                        ),
                        Obx(() => Text(
                          "${controller.progress.value}%",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// Progress Bar
                    Obx(() => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: controller.progress.value / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        color: AppColors.primaryColor,
                      ),
                    )),

                    const SizedBox(height: 16),

                    /// Info Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.access_time, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'home.email_bill_received.analysis_time_info'.tr,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// Go to Requests
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.goToRequests,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('home.email_bill.go_to_requests'.tr),
                ),
              ),

              const SizedBox(height: 10),

              /// Back Home
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: controller.backToHome,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('home.email_bill.back_to_home'.tr),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
