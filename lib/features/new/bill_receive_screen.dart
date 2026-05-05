// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'bill_received_controller.dart';
//
// class BillReceivedScreen extends StatelessWidget {
//   BillReceivedScreen({super.key});
//
//   final controller = Get.put(BillReceivedController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F7),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18),
//           child: Column(
//             children: [
//               const SizedBox(height: 30),
//
//               /// Success Circle
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: 140,
//                     height: 140,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: const Color(0xFF6FE3C1).withOpacity(0.25),
//                     ),
//                   ),
//                   Container(
//                     width: 110,
//                     height: 110,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         colors: [
//                           Color(0xFF5B3FD8),
//                           Color(0xFF6A4CF4),
//                         ],
//                       ),
//                     ),
//                     child: const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 40,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               /// Title
//               const Text(
//                 "Bill Received !",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               /// Subtitle
//               const Text(
//                 "We've received your electricity bill and our AI is\nanalyzing it to find you the best offers.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.black54,
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               /// Analysis Card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F2F4),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// Header Row
//                     Row(
//                       children: [
//                         const Icon(Icons.analytics_outlined, size: 20),
//                         const SizedBox(width: 8),
//                         const Text(
//                           "Analysis in Progress",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     /// Progress Row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Scanning for optimizations...",
//                           style: TextStyle(fontSize: 13),
//                         ),
//                         Obx(() => Text(
//                           "${controller.progress.value}%",
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )),
//                       ],
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     /// Progress Bar
//                     Obx(() => ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: LinearProgressIndicator(
//                         value: controller.progress.value / 100,
//                         minHeight: 8,
//                         backgroundColor: Colors.grey.shade300,
//                         color: const Color(0xFF5B3FD8),
//                       ),
//                     )),
//
//                     const SizedBox(height: 16),
//
//                     /// Info Box
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Icon(Icons.access_time, size: 18),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               "The analysis time is approximately 24 hours maximum. We'll notify you as soon as your results are ready.",
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const Spacer(),
//
//               /// Go to Requests
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: controller.goToRequests,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF5B3FD8),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text("Go to Requests"),
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               /// Back Home
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: controller.backToHome,
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text("Back to Home"),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }