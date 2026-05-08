// import 'package:flutter/material.dart';
//
// class HowToSignContractScreen extends StatelessWidget {
//   const HowToSignContractScreen({super.key});
//
//   // ── Design Tokens ──
//   static const _purple = Color(0xFF5B3FD9);
//   static const _purpleBg = Color(0xFFEEEAFB);
//   static const _bg = Color(0xFFF7F8FC);
//   static const _cardBg = Colors.white;
//   static const _textDark = Color(0xFF1A1A2E);
//   static const _textMid = Color(0xFF636E72);
//   static const _greenBg = Color(0xFFEFFAF5);
//   static const _greenBorder = Color(0xFFA8E6CF);
//   static const _greenText = Color(0xFF2D8653);
//   static const _greenIcon = Color(0xFF27AE60);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bg,
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               children: [
//                 _heroCard(),
//                 const SizedBox(height: 20),
//                 _stepItem(
//                   number: 1,
//                   icon: Icons.mail_outline_rounded,
//                   title: 'Check Your Email/SMS',
//                   body:
//                   'Look for an email or SMS from your new supplier with the subject "Contract Ready to Sign". It contains a secure link to your personalized contract.',
//                 ),
//                 _stepItem(
//                   number: 2,
//                   icon: Icons.description_outlined,
//                   title: 'Review the Contract',
//                   body:
//                   'Click the link to open your contract. Review all terms, pricing, and activation dates carefully. Make sure everything matches what you selected.',
//                 ),
//                 _stepItem(
//                   number: 3,
//                   icon: Icons.check_box_outlined,
//                   title: 'Verify Your Details',
//                   body:
//                   'Confirm that your personal information, address, and meter details are correct. If anything is wrong, contact support before signing.',
//                 ),
//                 _stepItem(
//                   number: 4,
//                   icon: Icons.edit_outlined,
//                   title: 'Sign Electronically',
//                   body:
//                   'Follow the on-screen prompts to add your digital signature. You can sign using your finger on mobile or mouse on desktop. Some platforms may require ID verification.',
//                 ),
//                 _stepItem(
//                   number: 5,
//                   icon: Icons.check_circle_outline,
//                   title: 'Confirm & Complete',
//                   body:
//                   "Submit your signed contract. You'll receive a confirmation email with a copy for your records. Your switch will be processed automatically.",
//                   isLast: true,
//                 ),
//                 const SizedBox(height: 20),
//                 _tipsCard(),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//           _bottomButton(),
//         ],
//       ),
//     );
//   }
//
//   // ── AppBar ──
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: _bg,
//       elevation: 0,
//       scrolledUnderElevation: 0,
//       leadingWidth: 40,
//       leading: const Padding(
//         padding: EdgeInsets.only(left: 12),
//         child: Icon(Icons.chevron_left, color: _textDark, size: 28),
//       ),
//       title: const Text(
//         'How to Sign Your Contract',
//         style: TextStyle(
//           color: _textDark,
//           fontSize: 16,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
//
//   // ── Hero Card ──
//   Widget _heroCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
//       decoration: BoxDecoration(
//         color: _purpleBg,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Icon(
//               Icons.description_rounded,
//               color: _purple,
//               size: 30,
//             ),
//           ),
//           const SizedBox(height: 14),
//           const Text(
//             'Digital Signing Guide',
//             style: TextStyle(
//               color: _textDark,
//               fontSize: 18,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -0.2,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Follow these simple steps to sign\nyour contract electronically',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: _textMid,
//               fontSize: 13,
//               height: 1.55,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Step Item ──
//   Widget _stepItem({
//     required int number,
//     required IconData icon,
//     required String title,
//     required String body,
//     bool isLast = false,
//   }) {
//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Number bubble + connector
//           SizedBox(
//             width: 40,
//             child: Column(
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: const BoxDecoration(
//                     color: _purple,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text(
//                       '$number',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (!isLast)
//                   Expanded(
//                     child: Container(
//                       width: 2,
//                       margin: const EdgeInsets.symmetric(vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _purple.withOpacity(0.18),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 14),
//           // Content
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Icon(icon, color: _purple, size: 17),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           title,
//                           style: const TextStyle(
//                             color: _textDark,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     body,
//                     style: const TextStyle(
//                       color: _textMid,
//                       fontSize: 13,
//                       height: 1.55,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Tips Card ──
//   Widget _tipsCard() {
//     final tips = [
//       '✦✦ Sign within 7 days to secure your offer',
//       'Keep a copy of your signed contract',
//       'Contact us if you have questions before signing',
//       'Your current service continues uninterrupted',
//     ];
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
//       decoration: BoxDecoration(
//         color: _greenBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _greenBorder, width: 1.2),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: const [
//               Icon(Icons.tips_and_updates_outlined,
//                   color: _greenIcon, size: 16),
//               SizedBox(width: 6),
//               Text(
//                 'Important Tips',
//                 style: TextStyle(
//                   color: _greenText,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ...tips.map(
//                 (tip) => Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5),
//                     child: Container(
//                       width: 5,
//                       height: 5,
//                       decoration: const BoxDecoration(
//                         color: _greenIcon,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       tip,
//                       style: const TextStyle(
//                         color: _greenText,
//                         fontSize: 13,
//                         height: 1.5,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Bottom Button ──
//   Widget _bottomButton() {
//     return Container(
//       color: _bg,
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
//       child: SizedBox(
//         width: double.infinity,
//         height: 52,
//         child: ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: _purple,
//             foregroundColor: Colors.white,
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//             elevation: 0,
//           ),
//           child: const Text(
//             'Got it',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//           ),
//         ),
//       ),
//     );
//   }
// }