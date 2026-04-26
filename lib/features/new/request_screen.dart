import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'request_controller.dart';

class RequestScreen extends StatelessWidget {
  RequestScreen({super.key});

  final controller = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Request",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Column(
        children: [
          /// TAB BAR
          Obx(() => Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                _tabItem("Your Offers", 0),
                _tabItem("Ongoing Requests", 1),
              ],
            ),
          )),

          const SizedBox(height: 10),

          /// TAB VIEW
          Expanded(
            child: Obx(() {
              return controller.currentIndex.value == 0
                  ? _emptyOffersUI()
                  : _ongoingPlaceholder();
            }),
          )
        ],
      ),
    );
  }

  /// TAB ITEM
  Widget _tabItem(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Obx(() {
          final isSelected = controller.currentIndex.value == index;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.black : Colors.black54,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                width: isSelected ? 80 : 0,
                color: const Color(0xFF5B3FD8),
              )
            ],
          );
        }),
      ),
    );
  }

  /// EMPTY STATE UI
  Widget _emptyOffersUI() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F4),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            /// Icon Circle
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                ),
                const Icon(
                  Icons.receipt_long,
                  size: 50,
                  color: Colors.grey,
                ),

                /// Floating search icon
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.teal,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            /// Title
            const Text(
              "No Offers Yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            const Text(
              "To see offers, please upload a bill first best savings for you.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            /// Upload Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.uploadBill(),
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Bill"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B3FD8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Placeholder for second tab
  Widget _ongoingPlaceholder() {
    return const Center(
      child: Text("No ongoing requests"),
    );
  }
}