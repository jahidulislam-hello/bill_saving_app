// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'upload_bill_controller.dart';
//
// class UploadBillScreen extends StatelessWidget {
//   UploadBillScreen({super.key});
//
//   final controller = Get.put(UploadBillController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//
//               /// Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Row(
//                     children: [
//                       Icon(Icons.arrow_back_ios, size: 18),
//                       SizedBox(width: 6),
//                       Text(
//                         "Upload Your Bill",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Icon(Icons.qr_code_2_outlined, size: 20),
//                 ],
//               ),
//
//               const SizedBox(height: 30),
//
//               /// Title
//               const Text(
//                 "Upload your Business\nElectricity bill",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                   height: 1.3,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               const Text(
//                 "Choose the method that's most convenient for you",
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey,
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               /// Info Box
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE9E8FF),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(Icons.help_outline,
//                         size: 18, color: Color(0xFF5B4BFF)),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "We need your bill to analyze your current plan and find the best deals.",
//                             style: TextStyle(
//                               fontSize: 12.5,
//                               color: Color(0xFF4B4B4B),
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           GestureDetector(
//                             onTap: controller.openWhyInfo,
//                             child: const Text(
//                               "Why do we need it?",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF5B4BFF),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 18),
//
//               /// Upload File Card
//               GestureDetector(
//                 onTap: controller.uploadFile,
//                 child: _actionCard(
//                   iconBg: const Color(0xFFEDEBFF),
//                   icon: Icons.upload,
//                   title: "Upload File",
//                   subtitle: "PDF, Photo or Scan",
//                 ),
//               ),
//
//               const SizedBox(height: 14),
//
//               /// OR
//               const Center(
//                 child: Text(
//                   "OR",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 14),
//
//               /// Email Card
//               GestureDetector(
//                 onTap: controller.sendEmail,
//                 child: _actionCard(
//                   iconBg: const Color(0xFFE6F4EA),
//                   icon: Icons.email_outlined,
//                   title: "Send Our Email",
//                   subtitle: "Forward to Bills@Example.com",
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               /// Bottom Info
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE9E8FF),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "What we are looking for:",
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text("• Current supplier and tariff",
//                         style: TextStyle(fontSize: 12)),
//                     Text("• Monthly consumption and costs",
//                         style: TextStyle(fontSize: 12)),
//                     Text("• Contract end date",
//                         style: TextStyle(fontSize: 12)),
//                     Text("• Meter number and supply point",
//                         style: TextStyle(fontSize: 12)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Reusable Card
//   Widget _actionCard({
//     required Color iconBg,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     Widget? trailing,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: 42,
//             width: 42,
//             decoration: BoxDecoration(
//               color: iconBg,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: const Color(0xFF5B4BFF)),
//           ),
//           const SizedBox(width: 12),
//
//           /// Texts
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 11.5,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           if (trailing != null) trailing,
//         ],
//       ),
//     );
//   }
// }