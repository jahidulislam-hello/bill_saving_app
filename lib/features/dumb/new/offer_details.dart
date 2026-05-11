// import 'package:flutter/material.dart';
//
// // ─────────────────────────────────────────────
// //  MODELS
// // ─────────────────────────────────────────────
//
// class OfferDetail {
//   final String title;
//   final String subtitle;
//   final bool isBestValue;
//   final double annualSavings;
//   final String priceType;
//   final String contractDuration;
//   final List<IncludedFeature> features;
//   final String aboutText;
//   final List<FaqItem> faqs;
//
//   const OfferDetail({
//     required this.title,
//     required this.subtitle,
//     required this.isBestValue,
//     required this.annualSavings,
//     required this.priceType,
//     required this.contractDuration,
//     required this.features,
//     required this.aboutText,
//     required this.faqs,
//   });
// }
//
// class IncludedFeature {
//   final String title;
//   final String description;
//
//   const IncludedFeature({required this.title, required this.description});
// }
//
// class FaqItem {
//   final String question;
//   final String answer;
//
//   const FaqItem({required this.question, required this.answer});
// }
//
// // ─────────────────────────────────────────────
// //  CONTROLLER
// // ─────────────────────────────────────────────
//
// class OfferDetailsController extends ChangeNotifier {
//   final Set<int> _expandedFaqs = {};
//
//   bool isFaqExpanded(int index) => _expandedFaqs.contains(index);
//
//   void toggleFaq(int index) {
//     if (_expandedFaqs.contains(index)) {
//       _expandedFaqs.remove(index);
//     } else {
//       _expandedFaqs.add(index);
//     }
//     notifyListeners();
//   }
//
//   void selectOffer() {
//     // Handle offer selection logic
//     notifyListeners();
//   }
//
//   // Sample data
//   final OfferDetail offer = const OfferDetail(
//     title: 'Business Energy pro',
//     subtitle: 'Commercial',
//     isBestValue: true,
//     annualSavings: 306,
//     priceType: 'Fixed',
//     contractDuration: '24 months',
//     features: [
//       IncludedFeature(
//         title: '100% renewable energy',
//         description:
//         'Carbon-neutral electricity sourced from wind and solar farms.',
//       ),
//       IncludedFeature(
//         title: 'No hidden fees',
//         description:
//         'Transparent billing with zero unexpected administrative charges.',
//       ),
//       IncludedFeature(
//         title: 'Fixed price guarantee',
//         description:
//         'Your energy rate is locked in for the entire contract term.',
//       ),
//       IncludedFeature(
//         title: '24/7 customer support',
//         description:
//         'Access to expert energy concierge services at any time.',
//       ),
//     ],
//     aboutText:
//     'Business Energy pro is a trusted energy provider committed to delivering reliable service and competitive rates. They specialize in renewable energy solutions and have a proven track record of customer satisfaction.',
//     faqs: [
//       FaqItem(
//         question: 'How does the switching process work?',
//         answer:
//         'The switching process is simple. Once you select this offer, our team will handle all the paperwork and coordinate with your current provider to ensure a seamless transition.',
//       ),
//       FaqItem(
//         question: 'Will my service be interrupted?',
//         answer:
//         'No, your energy supply will not be interrupted during the switch. The process is designed to be completely seamless.',
//       ),
//       FaqItem(
//         question: "What if I'm still under contract?",
//         answer:
//         "We'll review your current contract terms and advise you on any exit fees. In many cases, the savings outweigh any exit costs.",
//       ),
//     ],
//   );
// }
//
// // ─────────────────────────────────────────────
// //  SCREEN
// // ─────────────────────────────────────────────
//
// class OfferDetailsScreen extends StatefulWidget {
//   const OfferDetailsScreen({super.key});
//
//   @override
//   State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
// }
//
// class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
//   final OfferDetailsController _controller = OfferDetailsController();
//
//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() => setState(() {}));
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final offer = _controller.offer;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ── App Bar ──
//             _buildAppBar(),
//
//             // ── Scrollable content ──
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildOfferHeader(offer),
//                     const SizedBox(height: 12),
//                     _buildSavingsBanner(offer),
//                     const SizedBox(height: 12),
//                     _buildInfoCards(offer),
//                     const SizedBox(height: 12),
//                     _buildWhatsIncluded(offer),
//                     const SizedBox(height: 12),
//                     _buildAboutSection(offer),
//                     const SizedBox(height: 12),
//                     _buildFaqSection(offer),
//                     const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ── Bottom CTA ──
//             _buildBottomCta(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── App Bar ──
//   Widget _buildAppBar() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.maybePop(context),
//             child: const Icon(Icons.chevron_left,
//                 size: 26, color: Color(0xFF1A1A2E)),
//           ),
//           const SizedBox(width: 8),
//           const Text(
//             'Offer Details',
//             style: TextStyle(
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A2E),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Offer Header Card ──
//   Widget _buildOfferHeader(OfferDetail offer) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       child: Row(
//         children: [
//           // Image placeholder
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: const Icon(Icons.bolt, color: Colors.white, size: 22),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   offer.title,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1A1A2E),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   offer.subtitle,
//                   style: const TextStyle(
//                       fontSize: 12, color: Color(0xFF9E9E9E)),
//                 ),
//               ],
//             ),
//           ),
//           if (offer.isBestValue)
//             Container(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF4CAF50),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text(
//                 'Best Value',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // ── Savings Banner ──
//   Widget _buildSavingsBanner(OfferDetail offer) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF3A1C8C), Color(0xFF5E35B1), Color(0xFF7C4DFF)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
//       child: Column(
//         children: [
//           const Text(
//             'MAXIMUM POTENTIAL BENEFIT',
//             style: TextStyle(
//               color: Color(0xFFCE93D8),
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 1.4,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             '\$${offer.annualSavings.toStringAsFixed(0)}',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 56,
//               fontWeight: FontWeight.w800,
//               height: 1.0,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Annual Savings',
//             style: TextStyle(
//               color: Color(0xFF80FF80),
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Info Cards ──
//   Widget _buildInfoCards(OfferDetail offer) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(child: _buildInfoCard('Price Type', offer.priceType)),
//           const SizedBox(width: 12),
//           Expanded(
//               child: _buildInfoCard(
//                   'Contract Duration', offer.contractDuration)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoCard(String label, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Color(0xFF9E9E9E),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A2E),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── What's Included ──
//   Widget _buildWhatsIncluded(OfferDetail offer) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "What's Included",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1A2E),
//             ),
//           ),
//           const SizedBox(height: 16),
//           ...offer.features.asMap().entries.map((entry) {
//             final i = entry.key;
//             final f = entry.value;
//             return Padding(
//               padding: EdgeInsets.only(
//                   bottom: i < offer.features.length - 1 ? 16 : 0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 22,
//                     height: 22,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFE8F5E9),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.check,
//                         size: 13, color: Color(0xFF4CAF50)),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           f.title,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF1A1A2E),
//                           ),
//                         ),
//                         const SizedBox(height: 3),
//                         Text(
//                           f.description,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Color(0xFF757575),
//                             height: 1.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   // ── About Section ──
//   Widget _buildAboutSection(OfferDetail offer) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'About ${offer.title}',
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1A2E),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             offer.aboutText,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Color(0xFF757575),
//               height: 1.6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── FAQ Section ──
//   Widget _buildFaqSection(OfferDetail offer) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Frequently Asked Questions',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1A2E),
//             ),
//           ),
//           const SizedBox(height: 12),
//           ...offer.faqs.asMap().entries.map((entry) {
//             final i = entry.key;
//             final faq = entry.value;
//             final isExpanded = _controller.isFaqExpanded(i);
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: GestureDetector(
//                 onTap: () => _controller.toggleFaq(i),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 250),
//                   curve: Curves.easeInOut,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(14),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.04),
//                         blurRadius: 6,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(14),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 15),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   faq.question,
//                                   style: const TextStyle(
//                                     fontSize: 13.5,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xFF1A1A2E),
//                                   ),
//                                 ),
//                               ),
//                               AnimatedRotation(
//                                 turns: isExpanded ? 0.5 : 0,
//                                 duration: const Duration(milliseconds: 250),
//                                 child: const Icon(
//                                   Icons.keyboard_arrow_down_rounded,
//                                   color: Color(0xFF9E9E9E),
//                                   size: 22,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (isExpanded)
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
//                             child: Text(
//                               faq.answer,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 color: Color(0xFF757575),
//                                 height: 1.6,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   // ── Bottom CTA ──
//   Widget _buildBottomCta() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
//       child: SizedBox(
//         width: double.infinity,
//         height: 54,
//         child: ElevatedButton(
//           onPressed: _controller.selectOffer,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF5E35B1),
//             foregroundColor: Colors.white,
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
//           child: const Text(
//             'Select this Offer',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────
// //  ENTRY POINT
// // ─────────────────────────────────────────────
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Offer Details',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         scaffoldBackgroundColor: const Color(0xFFF7F8FA),
//       ),
//       home: const OfferDetailsScreen(),
//     );
//   }
// }