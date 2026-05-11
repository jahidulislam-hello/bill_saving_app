// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class UtilityDetailsScreen extends StatefulWidget {
//   const UtilityDetailsScreen({super.key});
//
//   @override
//   State<UtilityDetailsScreen> createState() => _UtilityDetailsScreenState();
// }
//
// class _UtilityDetailsScreenState extends State<UtilityDetailsScreen> {
//   // FAQ expand state
//   final List<bool> _faqExpanded = [false, false, false, false];
//
//   final List<String> _faqQuestions = [
//     'How does the switching process work?',
//     'Will my service be interrupted?',
//     'What if I\'m still under contract?',
//     'How long does it take to receive my contract?',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F7),
//       appBar: _buildAppBar(),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── 1. Hero dark card ──
//             _buildHeroCard(),
//             SizedBox(height: 16.h),
//
//             // ── 2. Active Offer card ──
//             _buildInfoCard(
//               title: 'Active Offer',
//               rows: const [
//                 _InfoRow(label: 'Offer Name', value: 'fixed Rate Plan'),
//                 _InfoRow(label: 'Service Type', value: 'Gas'),
//               ],
//             ),
//             SizedBox(height: 12.h),
//
//             // ── 3. Supply Information card ──
//             _buildInfoCard(
//               title: 'Supply Information',
//               rows: const [
//                 _InfoRow(label: 'Meter Number', value: 'MTR-XCFAQBT18'),
//                 _InfoRow(label: 'Supply Point', value: 'SP-AMXQLAF7H99'),
//               ],
//             ),
//             SizedBox(height: 20.h),
//
//             // ── 4. Contact Support section ──
//             _buildSectionLabel('Contact Support'),
//             SizedBox(height: 10.h),
//             _buildContactCard(),
//             SizedBox(height: 20.h),
//
//             // ── 5. FAQ section ──
//             _buildSectionLabel('Frequently Asked Questions'),
//             SizedBox(height: 10.h),
//             _buildFaqCard(),
//             SizedBox(height: 30.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   //  APP BAR
//   // ─────────────────────────────────────────────
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back_rounded,
//             color: const Color(0xFF1A1A2E), size: 22.sp),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Text(
//         'Utility Details',
//         style: TextStyle(
//           fontSize: 17.sp,
//           fontWeight: FontWeight.w700,
//           color: const Color(0xFF1A1A2E),
//           height: 1.22,
//         ),
//       ),
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
//       ),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   //  HERO CARD (dark gradient)
//   // ─────────────────────────────────────────────
//
//   Widget _buildHeroCard() {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.r),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF1A1A3E), Color(0xFF2D2B6B)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Stack(
//         children: [
//           // Background bolt watermark
//           Positioned(
//             right: -10,
//             top: 0,
//             bottom: 0,
//             child: Opacity(
//               opacity: 0.08,
//               child: Icon(
//                 Icons.bolt_rounded,
//                 size: 140.sp,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: EdgeInsets.all(18.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── ACTIVE OFFER badge ──
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 10.w, vertical: 5.h),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(20.r),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.2),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 7.w,
//                         height: 7.w,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFF4CAF50),
//                         ),
//                       ),
//                       SizedBox(width: 6.w),
//                       Text(
//                         'ACTIVE OFFER',
//                         style: TextStyle(
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           letterSpacing: 0.8,
//                           height: 1.22,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 14.h),
//
//                 // ── Title ──
//                 Text(
//                   'Next e-Business\nSunlight',
//                   style: TextStyle(
//                     fontSize: 22.sp,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                     height: 1.25,
//                   ),
//                 ),
//
//                 SizedBox(height: 6.h),
//
//                 // ── Subtitle ──
//                 Text(
//                   'Business Electricity Supply',
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                     color: const Color(0xFF7BC8FF),
//                     fontWeight: FontWeight.w500,
//                     height: 1.22,
//                   ),
//                 ),
//
//                 SizedBox(height: 20.h),
//
//                 // ── Divider ──
//                 Divider(
//                   height: 1,
//                   thickness: 1,
//                   color: Colors.white.withOpacity(0.15),
//                 ),
//
//                 SizedBox(height: 14.h),
//
//                 // ── Material price + Activation row ──
//                 Row(
//                   children: [
//                     _buildHeroStat(
//                       label: 'MATERIAL PRICE',
//                       value: '0.124',
//                       unit: '\$/kWh',
//                       valueColor: const Color(0xFF7BC8FF),
//                     ),
//                     SizedBox(width: 32.w),
//                     _buildHeroStat(
//                       label: 'ACTIVATION',
//                       value: '12 Mag 2023',
//                       valueColor: Colors.white,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeroStat({
//     required String label,
//     required String value,
//     String? unit,
//     required Color valueColor,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 9.sp,
//             color: Colors.white.withOpacity(0.55),
//             letterSpacing: 0.6,
//             fontWeight: FontWeight.w500,
//             height: 1.22,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w700,
//                 color: valueColor,
//                 height: 1.22,
//               ),
//             ),
//             if (unit != null) ...[
//               SizedBox(width: 3.w),
//               Padding(
//                 padding: EdgeInsets.only(bottom: 2.h),
//                 child: Text(
//                   unit,
//                   style: TextStyle(
//                     fontSize: 11.sp,
//                     color: valueColor.withOpacity(0.8),
//                     height: 1.22,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ],
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   //  INFO CARD  (Active Offer / Supply Info)
//   // ─────────────────────────────────────────────
//
//   Widget _buildInfoCard({
//     required String title,
//     required List<_InfoRow> rows,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 15.sp,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF1A1A2E),
//               height: 1.22,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           ...rows.map((row) => _buildInfoRow(row)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(_InfoRow row) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 10.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             row.label,
//             style: TextStyle(
//               fontSize: 13.sp,
//               color: const Color(0xFF9E9E9E),
//               height: 1.22,
//             ),
//           ),
//           Text(
//             row.value,
//             style: TextStyle(
//               fontSize: 13.sp,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF1A1A2E),
//               height: 1.22,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   //  SECTION LABEL
//   // ─────────────────────────────────────────────
//
//   Widget _buildSectionLabel(String label) {
//     return Text(
//       label,
//       style: TextStyle(
//         fontSize: 15.sp,
//         fontWeight: FontWeight.w700,
//         color: const Color(0xFF1A1A2E),
//         height: 1.22,
//       ),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   //  CONTACT SUPPORT CARD
//   // ─────────────────────────────────────────────
//
//   Widget _buildContactCard() {
//     final contacts = [
//       _ContactItem(
//         icon: Icons.chat_bubble_outline_rounded,
//         iconBg: const Color(0xFFEAF0FF),
//         iconColor: const Color(0xFF5B7FD8),
//         title: 'Send Message',
//         subtitle: 'Get help via support form',
//       ),
//       _ContactItem(
//         icon: Icons.phone_outlined,
//         iconBg: const Color(0xFFE8F8EF),
//         iconColor: const Color(0xFF27AE60),
//         title: 'Call Us',
//         subtitle: '1-800-UTILITY',
//       ),
//       _ContactItem(
//         icon: Icons.mail_outline_rounded,
//         iconBg: const Color(0xFFF3EEFF),
//         iconColor: const Color(0xFF9B59B6),
//         title: 'Email',
//         subtitle: 'support@utility.com',
//       ),
//     ];
//
//     return Column(
//       children: List.generate(contacts.length, (i) {
//         return Container(
//           margin: EdgeInsets.only(bottom: 8.h),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(12.r),
//             onTap: () {},
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: 14.w, vertical: 13.h),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 40.w,
//                     height: 40.w,
//                     decoration: BoxDecoration(
//                       color: contacts[i].iconBg,
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     child: Icon(contacts[i].icon,
//                         color: contacts[i].iconColor, size: 20.sp),
//                   ),
//                   SizedBox(width: 14.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           contacts[i].title,
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF1A1A2E),
//                             height: 1.22,
//                           ),
//                         ),
//                         SizedBox(height: 2.h),
//                         Text(
//                           contacts[i].subtitle,
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: const Color(0xFF9E9E9E),
//                             height: 1.22,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   //  FAQ CARD
//   // ─────────────────────────────────────────────
//
//   Widget _buildFaqCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: List.generate(_faqQuestions.length, (i) {
//           final isLast = i == _faqQuestions.length - 1;
//           return Column(
//             children: [
//               _buildFaqItem(i),
//               if (!isLast)
//                 Divider(
//                   height: 1,
//                   thickness: 1,
//                   color: Colors.grey.shade100,
//                 ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildFaqItem(int index) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _faqExpanded[index] = !_faqExpanded[index];
//         });
//       },
//       borderRadius: BorderRadius.circular(14.r),
//       child: Padding(
//         padding:
//         EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 _faqQuestions[index],
//                 style: TextStyle(
//                   fontSize: 13.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF1A1A2E),
//                   height: 1.22,
//                 ),
//               ),
//             ),
//             SizedBox(width: 8.w),
//             AnimatedRotation(
//               turns: _faqExpanded[index] ? 0.5 : 0,
//               duration: const Duration(milliseconds: 200),
//               child: Icon(
//                 Icons.keyboard_arrow_down_rounded,
//                 color: const Color(0xFF9E9E9E),
//                 size: 20.sp,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// //  DATA CLASSES
// // ─────────────────────────────────────────────
//
// class _InfoRow {
//   final String label;
//   final String value;
//   const _InfoRow({required this.label, required this.value});
// }
//
// class _ContactItem {
//   final IconData icon;
//   final Color iconBg;
//   final Color iconColor;
//   final String title;
//   final String subtitle;
//   const _ContactItem({
//     required this.icon,
//     required this.iconBg,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//   });
// }