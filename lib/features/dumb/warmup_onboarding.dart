// import 'package:billo/features/onboarding/onboarding_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//
// class WarmupOnboarding extends StatefulWidget {
//   const WarmupOnboarding({super.key});
//
//   @override
//   State<WarmupOnboarding> createState() => _WarmupOnboardingState();
// }
//
// class _WarmupOnboardingState extends State<WarmupOnboarding> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   static const Color _purple = Color(0xFF583BC7);
//   static const Color _bgTop = Color(0xFFC8CCFD);
//   static const Color _bgBottom = Colors.white;
//
//   final List<OnboardingPageData> _pages = [
//     OnboardingPageData(
//       imagePath: 'screen1', // placeholder key
//       title: 'Upload Your Bills in\nSeconds',
//       subtitle:
//       'With EasyRissparmio, you can manage Electricity, gas, and\nservices easily and quickly',
//     ),
//     OnboardingPageData(
//       imagePath: 'screen2',
//       title: 'Upload Your Bills in\nSeconds',
//       subtitle:
//       'With EasyRissparmio, you can manage Electricity, gas, and\nservices easily and quickly',
//     ),
//     OnboardingPageData(
//       imagePath: 'screen3',
//       title: 'Upload Your Bills in\nSeconds',
//       subtitle:
//       'With EasyRissparmio, you can manage Electricity, gas, and\nservices easily and quickly',
//     ),
//   ];
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _onNextTapped() {
//     if (_currentPage < _pages.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 350),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _navigateToOnboarding();
//     }
//   }
//
//   void _onIndicatorTapped(int index) {
//     _pageController.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 350),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void _navigateToOnboarding() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (_) =>  OnboardingScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bgBottom,
//       body: Column(
//         children: [
//           // ── Top curved purple section + phone mockup ──────────────────
//           Expanded(
//             flex: 58,
//             child: PageView.builder(
//               controller: _pageController,
//               onPageChanged: (i) => setState(() => _currentPage = i),
//               itemCount: _pages.length,
//               itemBuilder: (context, index) {
//                 return _OnboardingPage(
//                   data: _pages[index],
//                   pageIndex: index,
//                 );
//               },
//             ),
//           ),
//
//           // ── Bottom white section ──────────────────────────────────────
//           Expanded(
//             flex: 42,
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               child: _currentPage == _pages.length - 1
//                   ? _buildLastPageBottom()
//                   : _buildDefaultBottom(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDefaultBottom() {
//     return Container(
//       key: const ValueKey('default'),
//       color: _bgBottom,
//       padding: EdgeInsets.symmetric(horizontal: 28.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 32.h),
//           // Title
//           Text(
//             _pages[_currentPage].title,
//             style: TextStyle(
//               fontSize: 28.sp,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF1A1A2E),
//               height: 1.25,
//               letterSpacing: -0.5,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           // Subtitle
//           Text(
//             _pages[_currentPage].subtitle,
//             style: TextStyle(
//               fontSize: 13.5.sp,
//               color: const Color(0xFF6B7280),
//               height: 1.5,
//             ),
//           ),
//           const Spacer(),
//           // Indicators + Arrow row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Dot indicators
//               Row(
//                 children: List.generate(_pages.length, (i) {
//                   final isActive = i == _currentPage;
//                   return GestureDetector(
//                     onTap: () => _onIndicatorTapped(i),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       margin: EdgeInsets.only(right: 6.w),
//                       width: isActive ? 24.w : 8.w,
//                       height: 8.h,
//                       decoration: BoxDecoration(
//                         color: isActive
//                             ? _purple
//                             : const Color(0xFFD1D5DB),
//                         borderRadius: BorderRadius.circular(4.r),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//               // Arrow button
//               GestureDetector(
//                 onTap: _onNextTapped,
//                 child: Container(
//                   width: 56.w,
//                   height: 56.w,
//                   decoration: BoxDecoration(
//                     color: _purple,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: _purple.withOpacity(0.35),
//                         blurRadius: 16,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     Icons.arrow_forward_rounded,
//                     color: Colors.white,
//                     size: 24.sp,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 40.h),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLastPageBottom() {
//     return Container(
//       key: const ValueKey('last'),
//       color: _bgBottom,
//       padding: EdgeInsets.symmetric(horizontal: 28.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 32.h),
//           Text(
//             _pages[_currentPage].title,
//             style: TextStyle(
//               fontSize: 28.sp,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF1A1A2E),
//               height: 1.25,
//               letterSpacing: -0.5,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           Text(
//             _pages[_currentPage].subtitle,
//             style: TextStyle(
//               fontSize: 13.5.sp,
//               color: const Color(0xFF6B7280),
//               height: 1.5,
//             ),
//           ),
//           SizedBox(height: 24.h),
//           // Dot indicators centered
//           Center(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: List.generate(_pages.length, (i) {
//                 final isActive = i == _currentPage;
//                 return GestureDetector(
//                   onTap: () => _onIndicatorTapped(i),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     margin: EdgeInsets.symmetric(horizontal: 3.w),
//                     width: isActive ? 24.w : 8.w,
//                     height: 8.h,
//                     decoration: BoxDecoration(
//                       color: isActive ? _purple : const Color(0xFFD1D5DB),
//                       borderRadius: BorderRadius.circular(4.r),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//           const Spacer(),
//           // Sign in button
//           SizedBox(
//             width: double.infinity,
//             height: 54.h,
//             child: ElevatedButton(
//               onPressed: _navigateToOnboarding,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: _purple,
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14.r),
//                 ),
//               ),
//               child: Text(
//                 'Sign in',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 14.h),
//           // Create account button
//           SizedBox(
//             width: double.infinity,
//             height: 54.h,
//             child: OutlinedButton(
//               onPressed: () {},
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: _purple,
//                 side: BorderSide(color: const Color(0xFFE5E7EB), width: 1.5.w),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14.r),
//                 ),
//               ),
//               child: Text(
//                 'Create an Account',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 36.h),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Single onboarding page (top curved section) ──────────────────────────────
// class _OnboardingPage extends StatelessWidget {
//   const _OnboardingPage({
//     required this.data,
//     required this.pageIndex,
//   });
//
//   final OnboardingPageData data;
//   final int pageIndex;
//
//   static const Color _bgTop = Color(0xFFC8CCFD);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: _bgTop,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Curved white bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 40.h,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 30.h,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 30.h,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFC8CCFD),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(0),
//                   bottomRight: Radius.circular(0),
//                 ),
//               ),
//             ),
//           ),
//
//           // Phone mockup illustration
//           Center(
//             child: pageIndex == 0
//                 ? _Screen1MockupWidget()
//                 : _Screen2MockupWidget(),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Screen 1 phone mockup ────────────────────────────────────────────────────
// class _Screen1MockupWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 220.w,
//       height: 420.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(36.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.18),
//             blurRadius: 40,
//             offset: const Offset(0, 16),
//             spreadRadius: -4,
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(36.r),
//         child: Column(
//           children: [
//             // Status bar + header
//             Container(
//               height: 130.h,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF8B9FE8), Color(0xFFC8CCFD)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Hello, there! 👋',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 13.sp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       Icon(Icons.notifications_outlined,
//                           color: Colors.white, size: 16.sp),
//                     ],
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     'Ready to save, find a better',
//                     style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 9.sp),
//                   ),
//                   SizedBox(height: 10.h),
//                   Row(
//                     children: [
//                       _StatChip(label: '~ Potential Savings', value: '\$0', sub: 'per year'),
//                       SizedBox(width: 12.w),
//                       _StatChip(label: 'Active Request', value: '0', sub: '0 in progress', isActive: true),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Content
//             Expanded(
//               child: Container(
//                 color: const Color(0xFFF8F9FF),
//                 padding: EdgeInsets.all(12.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Your Utilities',
//                             style: TextStyle(
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.w700,
//                                 color: const Color(0xFF1A1A2E))),
//                         Text('View All',
//                             style: TextStyle(
//                                 fontSize: 8.sp,
//                                 color: const Color(0xFF583BC7),
//                                 fontWeight: FontWeight.w500)),
//                       ],
//                     ),
//                     SizedBox(height: 8.h),
//                     _UtilityRow(name: 'EnergyPlus', type: 'Gas', price: '\$89.99'),
//                     SizedBox(height: 6.h),
//                     _UtilityRow(name: 'EnergyPlus', type: 'Gas', price: '\$89.99'),
//                     SizedBox(height: 12.h),
//                     Text('⚡ How It Works',
//                         style: TextStyle(
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.w700,
//                             color: const Color(0xFF1A1A2E))),
//                     SizedBox(height: 8.h),
//                     _HowItWorksStep(
//                         number: '1',
//                         title: 'Upload Your Bill',
//                         subtitle: 'Take a photo or upload a PDF'),
//                     SizedBox(height: 6.h),
//                     _HowItWorksStep(
//                         number: '2',
//                         title: 'We Analyze & Compare',
//                         subtitle: 'AI finds the best offers for you'),
//                   ],
//                 ),
//               ),
//             ),
//             // Bottom nav
//             Container(
//               height: 44.h,
//               color: Colors.white,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Icon(Icons.home_rounded, color: const Color(0xFF583BC7), size: 18.sp),
//                   Icon(Icons.receipt_long_outlined, color: Colors.grey, size: 18.sp),
//                   Container(
//                     width: 32.w,
//                     height: 32.w,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFF583BC7),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.add, color: Colors.white, size: 18.sp),
//                   ),
//                   Icon(Icons.download_outlined, color: Colors.grey, size: 18.sp),
//                   Icon(Icons.person_outline, color: Colors.grey, size: 18.sp),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Screen 2 double phone mockup ────────────────────────────────────────────
// class _Screen2MockupWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 270.w,
//       height: 380.h,
//       child: Stack(
//         children: [
//           // Back phone (right, rotated)
//           Positioned(
//             right: 0,
//             top: 30.h,
//             child: Transform.rotate(
//               angle: 0.12,
//               child: _UtilityDetailPhone(),
//             ),
//           ),
//           // Front phone (left, slightly rotated other way)
//           Positioned(
//             left: 0,
//             bottom: 0,
//             child: Transform.rotate(
//               angle: -0.08,
//               child: _MyUtilitiesPhone(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MyUtilitiesPhone extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 180.w,
//       height: 320.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(28.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 30,
//             offset: const Offset(-4, 12),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(28.r),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 10.h),
//               color: Colors.white,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('My Utilities',
//                       style: TextStyle(
//                           fontSize: 11.sp,
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF1A1A2E))),
//                   Text('Manage your utility services',
//                       style: TextStyle(fontSize: 7.5.sp, color: Colors.grey)),
//                   SizedBox(height: 10.h),
//                   _CompactUtilityCard(
//                     name: 'EnergyPlus',
//                     price: '\$89.99',
//                     dueDate: '21/07/2025',
//                     plan: 'Rate Base Plan',
//                   ),
//                   SizedBox(height: 6.h),
//                   _CompactUtilityCard(
//                     name: 'EnergyPlus',
//                     price: '\$89.99',
//                     dueDate: '21/07/2025',
//                     plan: 'Rate Base Plan',
//                   ),
//                 ],
//               ),
//             ),
//             // Green save banner
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 12.w),
//               padding: EdgeInsets.all(10.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1DB954),
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Save on your next bill',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 8.sp,
//                           fontWeight: FontWeight.w700)),
//                   SizedBox(height: 4.h),
//                   Text('Upload your bill to find the best\noffers available',
//                       style: TextStyle(color: Colors.white70, fontSize: 6.5.sp)),
//                   SizedBox(height: 8.h),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(6.r),
//                     ),
//                     child: Text('Upload Bill',
//                         style: TextStyle(
//                             color: const Color(0xFF1DB954),
//                             fontSize: 7.sp,
//                             fontWeight: FontWeight.w700)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _UtilityDetailPhone extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 160.w,
//       height: 260.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 24,
//             offset: const Offset(4, 8),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24.r),
//         child: Column(
//           children: [
//             // Dark gradient header
//             Container(
//               height: 100.h,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF2D1B69), Color(0xFF583BC7)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               padding: EdgeInsets.all(12.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Utility Details',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 9.sp,
//                           fontWeight: FontWeight.w700)),
//                   SizedBox(height: 6.h),
//                   Row(
//                     children: [
//                       Icon(Icons.flash_on, color: Colors.amber, size: 14.sp),
//                       SizedBox(width: 4.w),
//                       Text('Next n-Business\nInsight',
//                           style: TextStyle(color: Colors.white, fontSize: 7.5.sp)),
//                     ],
//                   ),
//                   SizedBox(height: 4.h),
//                   Text('\$ 124.5tkm',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.w700)),
//                 ],
//               ),
//             ),
//             // White body
//             Expanded(
//               child: Container(
//                 color: Colors.white,
//                 padding: EdgeInsets.all(10.w),
//                 child: Column(
//                   children: [
//                     _DetailRow(label: 'Due Date', value: '22 May 2023'),
//                     SizedBox(height: 6.h),
//                     _DetailRow(label: 'Next Plan', value: 'Base Plan'),
//                     SizedBox(height: 6.h),
//                     _DetailRow(label: 'Gas', value: ''),
//                     SizedBox(height: 6.h),
//                     Container(
//                       height: 1,
//                       color: const Color(0xFFEEEEEE),
//                     ),
//                     SizedBox(height: 6.h),
//                     _DetailRow(
//                         label: 'Contract Ref',
//                         value: '20.89-94-8/7492'),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Helper widgets ────────────────────────────────────────────────────────────
//
// class _StatChip extends StatelessWidget {
//   const _StatChip({
//     required this.label,
//     required this.value,
//     required this.sub,
//     this.isActive = false,
//   });
//
//   final String label, value, sub;
//   final bool isActive;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.25),
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label,
//                 style: TextStyle(color: Colors.white70, fontSize: 6.5.sp)),
//             SizedBox(height: 2.h),
//             Text(value,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.w700)),
//             Text(sub,
//                 style: TextStyle(color: Colors.white60, fontSize: 6.sp)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _UtilityRow extends StatelessWidget {
//   const _UtilityRow({
//     required this.name,
//     required this.type,
//     required this.price,
//   });
//
//   final String name, type, price;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.r),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 6,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 24.w,
//             height: 24.w,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFF3CD),
//               borderRadius: BorderRadius.circular(6.r),
//             ),
//             child: Icon(Icons.flash_on, color: Colors.amber, size: 12.sp),
//           ),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name,
//                     style: TextStyle(
//                         fontSize: 8.sp, fontWeight: FontWeight.w600)),
//                 Text(type,
//                     style:
//                     TextStyle(fontSize: 6.5.sp, color: Colors.grey)),
//               ],
//             ),
//           ),
//           Text(price,
//               style: TextStyle(
//                   fontSize: 8.sp,
//                   fontWeight: FontWeight.w700,
//                   color: const Color(0xFF1A1A2E))),
//         ],
//       ),
//     );
//   }
// }
//
// class _HowItWorksStep extends StatelessWidget {
//   const _HowItWorksStep({
//     required this.number,
//     required this.title,
//     required this.subtitle,
//   });
//
//   final String number, title, subtitle;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 18.w,
//           height: 18.w,
//           decoration: BoxDecoration(
//             color: const Color(0xFF583BC7),
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Text(number,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 7.sp,
//                     fontWeight: FontWeight.w700)),
//           ),
//         ),
//         SizedBox(width: 8.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title,
//                   style: TextStyle(
//                       fontSize: 8.sp, fontWeight: FontWeight.w600)),
//               Text(subtitle,
//                   style:
//                   TextStyle(fontSize: 6.5.sp, color: Colors.grey)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _CompactUtilityCard extends StatelessWidget {
//   const _CompactUtilityCard({
//     required this.name,
//     required this.price,
//     required this.dueDate,
//     required this.plan,
//   });
//
//   final String name, price, dueDate, plan;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F9FF),
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 22.w,
//             height: 22.w,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFF3CD),
//               borderRadius: BorderRadius.circular(5.r),
//             ),
//             child: Icon(Icons.flash_on, color: Colors.amber, size: 10.sp),
//           ),
//           SizedBox(width: 6.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name,
//                     style: TextStyle(
//                         fontSize: 8.sp, fontWeight: FontWeight.w600)),
//                 Text(plan,
//                     style:
//                     TextStyle(fontSize: 6.sp, color: Colors.grey)),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(price,
//                   style: TextStyle(
//                       fontSize: 8.sp, fontWeight: FontWeight.w700)),
//               Text(dueDate,
//                   style:
//                   TextStyle(fontSize: 6.sp, color: Colors.grey)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _DetailRow extends StatelessWidget {
//   const _DetailRow({required this.label, required this.value});
//
//   final String label, value;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label,
//             style: TextStyle(fontSize: 7.sp, color: Colors.grey)),
//         Text(value,
//             style: TextStyle(
//                 fontSize: 7.sp,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF1A1A2E))),
//       ],
//     );
//   }
// }
//
// // ─── Data model ────────────────────────────────────────────────────────────────
// class OnboardingPageData {
//   final String imagePath, title, subtitle;
//   const OnboardingPageData({
//     required this.imagePath,
//     required this.title,
//     required this.subtitle,
//   });
// }
