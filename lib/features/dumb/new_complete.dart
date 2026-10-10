// import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
//
// class EditInformation extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 2588,
//               clipBehavior: Clip.antiAlias,
//               decoration: const BoxDecoration(color: Colors.white),
//               child: Stack(
//                 children: [
//               // ── Header ──────────────────────────────────────────────────
//               Positioned(
//                 left: 16,
//                 top: 60,
//                 child: SizedBox(
//                   width: 360,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(width: 24, height: 24), // icon placeholder
//                       const SizedBox(width: 8),
//                       const SizedBox(
//                         width: 328,
//                         child: Text(
//                           'Complete Your Request',
//                           style: TextStyle(
//                             color: Color(0xFF333333),
//                             fontSize: 20,
//                             fontFamily: 'Open Sans',
//                             fontWeight: FontWeight.w500,
//                             height: 1.20,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // ── Main content column ──────────────────────────────────────
//               Positioned(
//                 left: 16,
//                 top: 116,
//                 child: SizedBox(
//                   width: 360,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       // ── Offer card ──────────────────────────────────────
//                       Container(
//                         width: double.infinity,
//                         height: 234,
//                         decoration: ShapeDecoration(
//                           shape: RoundedRectangleBorder(
//                             side: const BorderSide(
//                               width: 1.22,
//                               color: Color(0xFFE8E8E8),
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Offer header row
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: 48,
//                                         height: 48,
//                                         clipBehavior: Clip.antiAlias,
//                                         decoration: ShapeDecoration(
//                                           image: const DecorationImage(
//                                             image: NetworkImage("https://placehold.co/48x48"),
//                                             fit: BoxFit.cover,
//                                           ),
//                                           shape: RoundedRectangleBorder(
//                                             side: const BorderSide(
//                                               width: 1.22,
//                                               color: Color(0xFFE8E8E8),
//                                             ),
//                                             borderRadius: BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           const Text(
//                                             'Green Energy',
//                                             style: TextStyle(
//                                               color: Color(0xFF333333),
//                                               fontSize: 16,
//                                               fontFamily: 'Open Sans',
//                                               fontWeight: FontWeight.w500,
//                                               height: 1.50,
//                                             ),
//                                           ),
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8, vertical: 2),
//                                             decoration: ShapeDecoration(
//                                               shape: RoundedRectangleBorder(
//                                                 side: const BorderSide(
//                                                   width: 1.22,
//                                                   color: Color(0x19333333),
//                                                 ),
//                                                 borderRadius: BorderRadius.circular(8),
//                                               ),
//                                             ),
//                                             child: const Text(
//                                               'Green Offer',
//                                               style: TextStyle(
//                                                 color: Color(0xFF333333),
//                                                 fontSize: 12,
//                                                 fontFamily: 'Open Sans',
//                                                 fontWeight: FontWeight.w400,
//                                                 height: 1.33,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Container(
//                                     width: 72,
//                                     height: 24,
//                                     clipBehavior: Clip.antiAlias,
//                                 ],
//                               ),
//                               const SizedBox(height: 12),
//                               // Energy price banner
//                               Container(
//                                 width: double.infinity,
//                                 height: 32,
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: ShapeDecoration(
//                                   color: const Color(0xFFF4E6FB),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Text(
//                                       'Energy Price : PUN GME + ',
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 12,
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.w400,
//                                         height: 1.33,
//                                       ),
//                                     ),
//                                     Text(
//                                       '0.01/KWh',
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 12,
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.w400,
//                                         height: 1.33,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               // Payment & compatibility info
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: const [
//                                       SizedBox(width: 24, height: 24),
//                                       SizedBox(width: 8),
//                                       Text(
//                                         'Payment Method:',
//                                         style: TextStyle(
//                                           color: Color(0xFF333333),
//                                           fontSize: 12,
//                                           fontFamily: 'Open Sans',
//                                           fontWeight: FontWeight.w500,
//                                           height: 1.33,
//                                         ),
//                                       ),
//                                       SizedBox(width: 4),
//                                       Text(
//                                         'Postal Order',
//                                         style: TextStyle(
//                                           color: Color(0xFF333333),
//                                           fontSize: 12,
//                                           fontFamily: 'Open Sans',
//                                           fontWeight: FontWeight.w500,
//                                           height: 1.33,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: const [
//                                       SizedBox(width: 16, height: 16),
//                                       SizedBox(width: 8),
//                                       Text(
//                                         'Compatibility:',
//                                         style: TextStyle(
//                                           color: Color(0xFF333333),
//                                           fontSize: 12,
//                                           fontFamily: 'Open Sans',
//                                           fontWeight: FontWeight.w500,
//                                           height: 1.33,
//                                         ),
//                                       ),
//                                       SizedBox(width: 4),
//                                       Text(
//                                         'Residential',
//                                         style: TextStyle(
//                                           color: Color(0xFF333333),
//                                           fontSize: 12,
//                                           fontFamily: 'Open Sans',
//                                           fontWeight: FontWeight.w500,
//                                           height: 1.33,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               const Divider(color: Color(0xFFEFEFEF)),
//                               // Annual savings
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: const [
//                                   Text(
//                                     '€380',
//                                     style: TextStyle(
//                                       color: Color(0xFF00A63E),
//                                       fontSize: 24,
//                                       fontFamily: 'Open Sans',
//                                       fontWeight: FontWeight.w700,
//                                       height: 1.17,
//                                       letterSpacing: -1,
//                                     ),
//                                   ),
//                                   SizedBox(width: 5),
//                                   Text(
//                                     'Annual Savings',
//                                     style: TextStyle(
//                                       color: Color(0xFF333333),
//                                       fontSize: 14,
//                                       fontFamily: 'Open Sans',
//                                       fontWeight: FontWeight.w500,
//                                       height: 1.43,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // ── Personal Information card ────────────────────────
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.only(
//                           top: 21.21,
//                           left: 21.21,
//                           right: 21.21,
//                           bottom: 1.22,
//                         ),
//                         decoration: ShapeDecoration(
//                           color: const Color(0xFFF4E6FB),
//                           shape: RoundedRectangleBorder(
//                             side: const BorderSide(
//                               width: 0.50,
//                               color: Color(0xFF3E0059),
//                             ),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           shadows: const [
//                             BoxShadow(
//                               color: Color(0x0A001C13),
//                               blurRadius: 32,
//                               offset: Offset(0, 8),
//                             )
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Section header
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Personal Information',
//                                   style: TextStyle(
//                                     color: Color(0xFF333333),
//                                     fontSize: 16,
//                                     fontFamily: 'Open Sans',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.50,
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 55,
//                                   height: 22,
//                                   clipBehavior: Clip.antiAlias,
//                                   decoration: ShapeDecoration(
//                                     color: AppColors.primaryColor,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                   ),
//                                   child: const Center(
//                                     child: Text(
//                                       'Edit',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 10,
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.w600,
//                                         height: 1.20,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             // Info rows
//                             _infoRow('First Name', 'mahmudul'),
//                             const SizedBox(height: 12),
//                             _infoRow('Last Name', 'tamim'),
//                             const SizedBox(height: 12),
//                             _infoRow('Email', 'mahmudul14286@gmail.com'),
//                             const SizedBox(height: 12),
//                             _infoRow('Phone', '+8801892683582'),
//                             const SizedBox(height: 12),
//                             _infoRow('POD Number', '*************'),
//                             const SizedBox(height: 16),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // ── Supply Address card ──────────────────────────────
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 17),
//                         decoration: ShapeDecoration(
//                           shape: RoundedRectangleBorder(
//                             side: const BorderSide(
//                               width: 0.50,
//                               color: Color(0xFF3E0059),
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Supply Address',
//                               style: TextStyle(
//                                 color: Color(0xFF333333),
//                                 fontSize: 16,
//                                 fontFamily: 'Open Sans',
//                                 fontWeight: FontWeight.w500,
//                                 height: 1.50,
//                               ),
//                             ),
//                             const Text(
//                               'Read-Only Summary from Bill/Profile',
//                               style: TextStyle(
//                                 color: Color(0xFF333333),
//                                 fontSize: 12,
//                                 fontFamily: 'Open Sans',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.33,
//                               ),
//                             ),
//                             const SizedBox(height: 14),
//                             // Address tile
//                             Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.all(20),
//                               decoration: ShapeDecoration(
//                                 color: const Color(0xFFEFEFEF),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: 48,
//                                         height: 48,
//                                         decoration: ShapeDecoration(
//                                           color: const Color(0x19333333),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                             BorderRadius.circular(9999),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 16),
//                                       Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: const [
//                                           Text(
//                                             'Via Roma 123',
//                                             style: TextStyle(
//                                               color: Color(0xFF333333),
//                                               fontSize: 16,
//                                               fontFamily: 'Manrope',
//                                               fontWeight: FontWeight.w700,
//                                               height: 1.50,
//                                             ),
//                                           ),
//                                           Text(
//                                             '20100 Milano (MI)',
//                                             style: TextStyle(
//                                               color: Color(0xFF606060),
//                                               fontSize: 14,
//                                               fontFamily: 'Open Sans',
//                                               fontWeight: FontWeight.w400,
//                                               height: 1.43,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: ShapeDecoration(
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                         BorderRadius.circular(9999),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             const Text(
//                               'Does the Residential address match the delivery address?',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 14,
//                                 fontFamily: 'Open Sans',
//                                 fontWeight: FontWeight.w500,
//                                 height: 1.43,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             // Yes / No radio buttons
//                             Row(
//                               children: [
//                                 // Yes button
//                                 Container(
//                                   width: 155,
//                                   height: 44,
//                                   clipBehavior: Clip.antiAlias,
//                                   decoration: ShapeDecoration(
//                                     shape: RoundedRectangleBorder(
//                                       side: const BorderSide(
//                                         width: 1,
//                                         color: Color(0xFFE8E8E8),
//                                       ),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         width: 20,
//                                         height: 20,
//                                         decoration: ShapeDecoration(
//                                           shape: RoundedRectangleBorder(
//                                             side: const BorderSide(
//                                               width: 1,
//                                               color: Color(0xFFE8E8E8),
//                                             ),
//                                             borderRadius:
//                                             BorderRadius.circular(100),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       const Text(
//                                         "Yes, it's the same",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 10,
//                                           fontFamily: 'Open Sans',
//                                           fontWeight: FontWeight.w500,
//                                           height: 1.20,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 13),
//                                 // No button
//                                 Container(
//                                   width: 155,
//                                   height: 44,
//                                   clipBehavior: Clip.antiAlias,
//                                   decoration: ShapeDecoration(
//                                     shape: RoundedRectangleBorder(
//                                       side: const BorderSide(
//                                         width: 1,
//                                         color: Color(0xFFE8E8E8),
//                                       ),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         width: 20,
//                                         height: 20,
//                                         decoration: ShapeDecoration(
//                                           shape: RoundedRectangleBorder(
//                                             side: const BorderSide(
//                                               width: 1,
//                                               color: Color(0xFFE8E8E8),
//                                             ),
//                                             borderRadius:
//                                             BorderRadius.circular(100),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       const Text(
//                                         "No, it's different",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 12,
//                                           fontFamily: 'Open Sans',
//                                           fontWeight: FontWeight.w400,
//                                           height: 1.33,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             // Address verified button
//                             Container(
//                               width: double.infinity,
//                               height: 44,
//                               clipBehavior: Clip.antiAlias,
//                               decoration: ShapeDecoration(
//                                 color: const Color(0xFFA933DC),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   'Address verified',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontFamily: 'Open Sans',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.33,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // ── Identity Verification card ───────────────────────
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(16),
//                         decoration: ShapeDecoration(
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             side: const BorderSide(
//                               width: 0.50,
//                               color: Color(0xFF3E0059),
//                             ),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Identity Verification',
//                                   style: TextStyle(
//                                     color: Color(0xFF333333),
//                                     fontSize: 16,
//                                     fontFamily: 'Open Sans',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.50,
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 55,
//                                   height: 22,
//                                   clipBehavior: Clip.antiAlias,
//                                   decoration: ShapeDecoration(
//                                     color: const Color(0x191FC16B),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                   ),
//                                   child: const Center(
//                                     child: Text(
//                                       'Save',
//                                       style: TextStyle(
//                                         color: Color(0xFF1FC16B),
//                                         fontSize: 10,
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.w600,
//                                         height: 1.20,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Upload your identity document or driving license to complete the request.',
//                               style: TextStyle(
//                                 color: Color(0xFF0A0A0A),
//                                 fontSize: 12,
//                                 fontFamily: 'Open Sans',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.33,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 _uploadBox('Upload File (Max-3)', 'PDF, Photo'),
//                                 _uploadBox('Scan Document', 'Scan with the camera'),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // ── Payment Method card ──────────────────────────────
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 19),
//                         decoration: ShapeDecoration(
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             side: const BorderSide(
//                               width: 0.50,
//                               color: Color(0xFF3E0059),
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Payment Method',
//                               style: TextStyle(
//                                 color: Color(0xFF333333),
//                                 fontSize: 16,
//                                 fontFamily: 'Open Sans',
//                                 fontWeight: FontWeight.w500,
//                                 height: 1.50,
//                               ),
//                             ),
//                             const Text(
//                               'Select how you prefer to pay',
//                               style: TextStyle(
//                                 color: Color(0xFF606060),
//                                 fontSize: 12,
//                                 fontFamily: 'Open Sans',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.33,
//                               ),
//                             ),
//                             const SizedBox(height: 17),
//                             // Full name row
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: const [
//                                 Text('Full Name',
//                                     style: TextStyle(
//                                         color: Color(0xFF333333),
//                                         fontSize: 12,
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.w400,
//                                         height: 1.33)),
//                                 Text('Mario Rossi',
//                                     style: TextStyle(
//                                         color: Color(0xFF333333),
//                                         fontSize: 12,
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.w500,
//                                         height: 1.33)),
//                               ],
//                             ),
//                             const Divider(color: Color(0xFFE8E8E8)),
//                             // Tax code row
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: const [
//                                 Text('Tax Code',
//                                     style: TextStyle(
//                                         color: Color(0xFF333333),
//                                         fontSize: 12,
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.w400,
//                                         height: 1.33)),
//                                 Text('RSSMRA8541Y0z',
//                                     style: TextStyle(
//                                         color: Color(0xFF333333),
//                                         fontSize: 12,
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.w500,
//                                         height: 1.33)),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             // Same holder checkbox
//                             Container(
//                               width: double.infinity,
//                               height: 44,
//                               clipBehavior: Clip.antiAlias,
//                               decoration: ShapeDecoration(
//                                 shape: RoundedRectangleBorder(
//                                   side: const BorderSide(
//                                     width: 1,
//                                     color: Color(0xFFE8E8E8),
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding:
//                                 const EdgeInsets.symmetric(horizontal: 18),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 20,
//                                       height: 20,
//                                       decoration: ShapeDecoration(
//                                         shape: RoundedRectangleBorder(
//                                           side: const BorderSide(
//                                             width: 1,
//                                             color: Color(0xFFD2D2D2),
//                                           ),
//                                           borderRadius:
//                                           BorderRadius.circular(4),
//                                         ),
//                                       ),
//                                       child: const Center(
//                                         child: Icon(Icons.check,
//                                             size: 14,
//                                             color: Color(0xFF1FC16B)),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     const Text(
//                                       'Yes, IBAN Holder & Contract Holder are same',
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 10,
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.w500,
//                                         height: 1.20,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Choose Payment Method',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                                 fontFamily: 'Open Sans',
//                                 fontWeight: FontWeight.w500,
//                                 height: 1.50,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             // Direct Debit option
//                             _paymentOption(
//                               title: 'Direct Debit(SDD)',
//                               subtitle: 'Automatic Payment from your account',
//                               selected: false,
//                             ),
//                             const SizedBox(height: 12),
//                             // Postal Order option (selected)
//                             _paymentOption(
//                               title: 'Postal Order',
//                               subtitle: 'You will receive the bulleting to pay',
//                               selected: true,
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // ── Invoice Delivery Method card ─────────────────────
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 20),
//                         decoration: ShapeDecoration(
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             side: const BorderSide(
//                               width: 0.50,
//                               color: Color(0xFF3E0059),
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Invoice Delivery Method',
//                               style: TextStyle(
//                                 color: Color(0xFF333333),
//                                 fontSize: 16,
//                                 fontFamily: 'Open Sans',
//                                 fontWeight: FontWeight.w500,
//                                 height: 1.50,
//                               ),
//                             ),
//                             const Text(
//                               'Our advice: send via email to receive the service on time!',
//                               style: TextStyle(
//                                 color: Color(0xFF030611),
//                                 fontSize: 12,
//                                 fontFamily: 'Open Sans',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.33,
//                               ),
//                             ),
//                             const SizedBox(height: 14),
//                             _paymentOption(
//                               title: 'Digital Invoice',
//                               subtitle: 'Receive the invoice via email',
//                               selected: false,
//                             ),
//                             const SizedBox(height: 12),
//                             _paymentOption(
//                               title: 'Paper Invoice',
//                               subtitle: 'You will receive the bulleting to pay',
//                               selected: false,
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // ── Almost there banner ──────────────────────────────
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(12),
//                         decoration: ShapeDecoration(
//                           color: const Color(0x191FC16B),
//                           shape: RoundedRectangleBorder(
//                             side: const BorderSide(
//                               width: 1.22,
//                               color: Color(0xFF1FC16B),
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(width: 20, height: 20), // icon placeholder
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: const [
//                                   Text(
//                                     'Almost there!',
//                                     style: TextStyle(
//                                       color: Color(0xFF333333),
//                                       fontSize: 16,
//                                       fontFamily: 'Open Sans',
//                                       fontWeight: FontWeight.w500,
//                                       height: 1.50,
//                                     ),
//                                   ),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     "Once you activate, we'll send your contract within 24 hours for signing.",
//                                     style: TextStyle(
//                                       color: Color(0xFF606060),
//                                       fontSize: 14,
//                                       fontFamily: 'Open Sans',
//                                       fontWeight: FontWeight.w400,
//                                       height: 1.43,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // ── Activate Offer button ────────────────────────────
//                       Container(
//                         width: double.infinity,
//                         height: 52,
//                         clipBehavior: Clip.antiAlias,
//                         decoration: ShapeDecoration(
//                           color: AppColors.primaryColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'Activate Offer',
//                             style: TextStyle(
//                               color: Color(0xFFEFEFEF),
//                               fontSize: 14,
//                               fontFamily: 'Open Sans',
//                               fontWeight: FontWeight.w500,
//                               height: 1.43,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),),);
//   }
//
//   // ── Helpers ────────────────────────────────────────────────────────────────
//
//   Widget _infoRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Color(0xFF4A5565),
//             fontSize: 14,
//             fontFamily: 'Inter',
//             fontWeight: FontWeight.w400,
//             height: 1.43,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Color(0xFF101828),
//             fontSize: 14,
//             fontFamily: 'Inter',
//             fontWeight: FontWeight.w500,
//             height: 1.43,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _uploadBox(String title, String subtitle) {
//     return Container(
//       width: 160,
//       height: 120,
//       decoration: ShapeDecoration(
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(width: 1.22, color: Color(0xFFE8E8E8)),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         shadows: const [
//           BoxShadow(
//             color: Color(0x3FC2AEAE),
//             blurRadius: 3,
//             offset: Offset(0, 1),
//           )
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 42,
//             height: 42,
//             decoration: ShapeDecoration(
//               color: const Color(0xFFF4E6FB),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(100),
//               ),
//             ),
//             child: const Icon(Icons.upload_file, size: 16, color: AppColors.primaryColor),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Color(0xFF333333),
//               fontSize: 12,
//               fontFamily: 'Open Sans',
//               fontWeight: FontWeight.w500,
//               height: 1.43,
//             ),
//           ),
//           Text(
//             subtitle,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Color(0xFF606060),
//               fontSize: 10,
//               fontFamily: 'Open Sans',
//               fontWeight: FontWeight.w500,
//               height: 1.20,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _paymentOption({
//     required String title,
//     required String subtitle,
//     required bool selected,
//   }) {
//     return Container(
//       width: double.infinity,
//       height: 56,
//       clipBehavior: Clip.antiAlias,
//       decoration: ShapeDecoration(
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(width: 1, color: Color(0xFFE8E8E8)),
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18),
//         child: Row(
//           children: [
//             Container(
//               width: 20,
//               height: 20,
//               clipBehavior: Clip.antiAlias,
//               decoration: ShapeDecoration(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(width: 1, color: Color(0xFFE8E8E8)),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//               ),
//               child: selected
//                   ? Center(
//                 child: Container(
//                   width: 12,
//                   height: 12,
//                   decoration: ShapeDecoration(
//                     color: const Color(0xFF8700C0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                   ),
//                 ),
//               )
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontFamily: 'Open Sans',
//                     fontWeight: FontWeight.w500,
//                     height: 1.43,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: const TextStyle(
//                     color: Color(0xFF4A4A4A),
//                     fontSize: 12,
//                     fontFamily: 'Open Sans',
//                     fontWeight: FontWeight.w400,
//                     height: 1.33,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }