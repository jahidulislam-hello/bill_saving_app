// import 'package:flutter/material.dart';
//
// // ─────────────────────────────────────────────
// //  MODELS
// // ─────────────────────────────────────────────
//
// enum SupportCategory { technical, billing }
//
// class ContactInfo {
//   final String phone;
//   final String email;
//   final String hours;
//
//   const ContactInfo({
//     required this.phone,
//     required this.email,
//     required this.hours,
//   });
// }
//
// // ─────────────────────────────────────────────
// //  CONTROLLER
// // ─────────────────────────────────────────────
//
// class SupportController extends ChangeNotifier {
//   SupportCategory _selectedCategory = SupportCategory.technical;
//   String? _selectedTopic;
//   String _message = '';
//   bool _isDropdownOpen = false;
//   bool _isSending = false;
//
//   SupportCategory get selectedCategory => _selectedCategory;
//   String? get selectedTopic => _selectedTopic;
//   String get message => _message;
//   bool get isDropdownOpen => _isDropdownOpen;
//   bool get isSending => _isSending;
//
//   final List<String> topics = [
//     'Billing Question',
//     'Technical Issue',
//     'Switching Process',
//     'Contact Question',
//     'Account Management',
//     'Other',
//   ];
//
//   final ContactInfo contactInfo = const ContactInfo(
//     phone: '1-800-UTILITY',
//     email: 'support@utility.com',
//     hours: 'Mon-Fri, 9am-6pm',
//   );
//
//   void selectCategory(SupportCategory category) {
//     _selectedCategory = category;
//     _selectedTopic = null;
//     _isDropdownOpen = false;
//     notifyListeners();
//   }
//
//   void toggleDropdown() {
//     _isDropdownOpen = !_isDropdownOpen;
//     notifyListeners();
//   }
//
//   void closeDropdown() {
//     _isDropdownOpen = false;
//     notifyListeners();
//   }
//
//   void selectTopic(String topic) {
//     _selectedTopic = topic;
//     _isDropdownOpen = false;
//     notifyListeners();
//   }
//
//   void updateMessage(String value) {
//     _message = value;
//     notifyListeners();
//   }
//
//   Future<void> sendRequest() async {
//     if (_isSending) return;
//     _isSending = true;
//     notifyListeners();
//
//     await Future.delayed(const Duration(seconds: 2));
//
//     _isSending = false;
//     _message = '';
//     _selectedTopic = null;
//     notifyListeners();
//     debugPrint('Request sent!');
//   }
//
//   void requestCallback() {
//     debugPrint('Callback requested');
//   }
// }
//
// // ─────────────────────────────────────────────
// //  SCREEN
// // ─────────────────────────────────────────────
//
// class SupportScreen extends StatefulWidget {
//   const SupportScreen({super.key});
//
//   @override
//   State<SupportScreen> createState() => _SupportScreenState();
// }
//
// class _SupportScreenState extends State<SupportScreen> {
//   final SupportController _controller = SupportController();
//   final TextEditingController _messageController = TextEditingController();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() => setState(() {}));
//   }
//
//   @override
//   void dispose() {
//     _removeOverlay();
//     _messageController.dispose();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   // ── Overlay Dropdown ──
//   void _toggleDropdown() {
//     if (_overlayEntry != null) {
//       _removeOverlay();
//       _controller.closeDropdown();
//     } else {
//       _showOverlay();
//       _controller.toggleDropdown();
//     }
//   }
//
//   void _showOverlay() {
//     _overlayEntry = _buildOverlayEntry();
//     Overlay.of(context).insert(_overlayEntry!);
//   }
//
//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
//
//   OverlayEntry _buildOverlayEntry() {
//     return OverlayEntry(
//       builder: (context) => GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () {
//           _removeOverlay();
//           _controller.closeDropdown();
//         },
//         child: Stack(
//           children: [
//             CompositedTransformFollower(
//               link: _layerLink,
//               showWhenUnlinked: false,
//               offset: const Offset(0, 52),
//               child: Material(
//                 color: Colors.transparent,
//                 child: _buildDropdownMenu(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDropdownMenu() {
//     return Container(
//       width: 280,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.12),
//             blurRadius: 20,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(14),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: _controller.topics.asMap().entries.map((entry) {
//             final i = entry.key;
//             final topic = entry.value;
//             final isSelected = _controller.selectedTopic == topic;
//             final isLast = i == _controller.topics.length - 1;
//
//             return GestureDetector(
//               onTap: () {
//                 _controller.selectTopic(topic);
//                 _removeOverlay();
//               },
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? const Color(0xFFF0F4FF)
//                       : Colors.white,
//                   border: !isLast
//                       ? const Border(
//                     bottom: BorderSide(
//                       color: Color(0xFFF0F0F0),
//                       width: 1,
//                     ),
//                   )
//                       : null,
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 18, vertical: 14),
//                 child: Text(
//                   topic,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: isSelected
//                         ? FontWeight.w600
//                         : FontWeight.w400,
//                     color: isSelected
//                         ? const Color(0xFF5E35B1)
//                         : const Color(0xFF1A1A2E),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         if (_overlayEntry != null) {
//           _removeOverlay();
//           _controller.closeDropdown();
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 16),
//                   _buildAppBar(),
//                   const SizedBox(height: 20),
//                   _buildSubtitle(),
//                   const SizedBox(height: 22),
//                   _buildCategoryToggle(),
//                   const SizedBox(height: 22),
//                   _buildTopicDropdown(),
//                   const SizedBox(height: 20),
//                   _buildMessageField(),
//                   const SizedBox(height: 22),
//                   _buildSendButton(),
//                   const SizedBox(height: 12),
//                   _buildCallbackButton(),
//                   const SizedBox(height: 32),
//                   _buildDivider(),
//                   const SizedBox(height: 24),
//                   _buildContactSection(),
//                   const SizedBox(height: 32),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── App Bar ──
//   Widget _buildAppBar() {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () => Navigator.maybePop(context),
//           child: const Icon(Icons.arrow_back_rounded,
//               size: 22, color: Color(0xFF1A1A2E)),
//         ),
//         const SizedBox(width: 12),
//         const Text(
//           'Support',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1A1A2E),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ── Subtitle ──
//   Widget _buildSubtitle() {
//     return const Text(
//       "Need help? Select a topic and describe your request. Our specialized team we'll get back to you as soon as possible.",
//       style: TextStyle(
//         fontSize: 13.5,
//         color: Color(0xFF757575),
//         height: 1.55,
//       ),
//     );
//   }
//
//   // ── Category Toggle ──
//   Widget _buildCategoryToggle() {
//     return Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF0F0F6),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           _buildToggleOption('Technical Support', SupportCategory.technical),
//           _buildToggleOption('Billing & Payments', SupportCategory.billing),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToggleOption(String label, SupportCategory category) {
//     final isSelected = _controller.selectedCategory == category;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => _controller.selectCategory(category),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             color: isSelected ? const Color(0xFF5E35B1) : Colors.transparent,
//             borderRadius: BorderRadius.circular(9),
//             boxShadow: isSelected
//                 ? [
//               BoxShadow(
//                 color: const Color(0xFF5E35B1).withOpacity(0.25),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ]
//                 : null,
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight:
//                 isSelected ? FontWeight.w600 : FontWeight.w400,
//                 color: isSelected
//                     ? Colors.white
//                     : const Color(0xFF757575),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── Topic Dropdown ──
//   Widget _buildTopicDropdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Topic',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF1A1A2E),
//           ),
//         ),
//         const SizedBox(height: 8),
//         CompositedTransformTarget(
//           link: _layerLink,
//           child: GestureDetector(
//             onTap: _toggleDropdown,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               height: 50,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF7F8FA),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: _controller.isDropdownOpen
//                       ? const Color(0xFF5E35B1)
//                       : const Color(0xFFE0E0E0),
//                   width: 1.5,
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       _controller.selectedTopic ?? 'Select a topic...',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: _controller.selectedTopic != null
//                             ? const Color(0xFF1A1A2E)
//                             : const Color(0xFFBDBDBD),
//                         fontWeight: _controller.selectedTopic != null
//                             ? FontWeight.w500
//                             : FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                   AnimatedRotation(
//                     turns: _controller.isDropdownOpen ? 0.5 : 0,
//                     duration: const Duration(milliseconds: 200),
//                     child: const Icon(
//                       Icons.keyboard_arrow_down_rounded,
//                       color: Color(0xFF9E9E9E),
//                       size: 22,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ── Message Field ──
//   Widget _buildMessageField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Message',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF1A1A2E),
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: _messageController,
//           onChanged: _controller.updateMessage,
//           maxLines: 5,
//           minLines: 5,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Color(0xFF1A1A2E),
//           ),
//           decoration: InputDecoration(
//             hintText: 'Describe your issue or question...',
//             hintStyle: const TextStyle(
//               color: Color(0xFFBDBDBD),
//               fontSize: 14,
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF7F8FA),
//             contentPadding: const EdgeInsets.all(14),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(
//                   color: Color(0xFFE0E0E0), width: 1.5),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(
//                   color: Color(0xFFE0E0E0), width: 1.5),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(
//                   color: Color(0xFF5E35B1), width: 1.5),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ── Send Button ──
//   Widget _buildSendButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: ElevatedButton(
//         onPressed: _controller.isSending ? null : _controller.sendRequest,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF1A1A2E),
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//           disabledBackgroundColor: const Color(0xFF1A1A2E).withOpacity(0.5),
//         ),
//         child: _controller.isSending
//             ? const SizedBox(
//           width: 20,
//           height: 20,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             color: Colors.white,
//           ),
//         )
//             : const Text(
//           'Send Request',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── Callback Button ──
//   Widget _buildCallbackButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: OutlinedButton(
//         onPressed: _controller.requestCallback,
//         style: OutlinedButton.styleFrom(
//           side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//         child: const Text(
//           'Request a Call Back',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF1A1A2E),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── Divider ──
//   Widget _buildDivider() {
//     return const Divider(color: Color(0xFFF0F0F0), height: 1);
//   }
//
//   // ── Contact Section ──
//   Widget _buildContactSection() {
//     final info = _controller.contactInfo;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Other Ways to Reach Us',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1A1A2E),
//           ),
//         ),
//         const SizedBox(height: 18),
//         _buildContactRow('Phone', info.phone, isLink: true),
//         const SizedBox(height: 14),
//         _buildContactRow('Email', info.email, isLink: true),
//         const SizedBox(height: 14),
//         _buildContactRow('Hours', info.hours, isLink: false),
//       ],
//     );
//   }
//
//   Widget _buildContactRow(String label, String value,
//       {required bool isLink}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Color(0xFF757575),
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: isLink
//                 ? const Color(0xFF5E35B1)
//                 : const Color(0xFF1A1A2E),
//           ),
//         ),
//       ],
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
//       title: 'Support',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: const SupportScreen(),
//     );
//   }
// }