// import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
//
// // ─────────────────────────────────────────────
// //  MODELS
// // ─────────────────────────────────────────────
//
// enum AccountType { business, personal }
//
// class UserProfile {
//   final String name;
//   final String email;
//   final AccountType accountType;
//
//   const UserProfile({
//     required this.name,
//     required this.email,
//     required this.accountType,
//   });
//
//   UserProfile copyWith({
//     String? name,
//     String? email,
//     AccountType? accountType,
//   }) {
//     return UserProfile(
//       name: name ?? this.name,
//       email: email ?? this.email,
//       accountType: accountType ?? this.accountType,
//     );
//   }
// }
//
// class ProfileMenuItem {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Color iconBgColor;
//   final Color iconColor;
//   final VoidCallback? onTap;
//
//   const ProfileMenuItem({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.iconBgColor,
//     required this.iconColor,
//     this.onTap,
//   });
// }
//
// // ─────────────────────────────────────────────
// //  CONTROLLER
// // ─────────────────────────────────────────────
//
// class ProfileController extends ChangeNotifier {
//   UserProfile _user = const UserProfile(
//     name: 'Alex Harrison',
//     email: 'alexsmith.mobbin@gmail.com',
//     accountType: AccountType.business,
//   );
//
//   bool _isLoggingOut = false;
//
//   UserProfile get user => _user;
//   bool get isLoggingOut => _isLoggingOut;
//   bool get isBusiness => _user.accountType == AccountType.business;
//
//   String get accountTypeLabel =>
//       _user.accountType == AccountType.business ? 'Business' : 'Personal';
//
//   String get switchLabel =>
//       _user.accountType == AccountType.business
//           ? 'Switch to Personal'
//           : 'Switch to Business';
//
//   void switchAccountType() {
//     _user = _user.copyWith(
//       accountType: _user.accountType == AccountType.business
//           ? AccountType.personal
//           : AccountType.business,
//     );
//     notifyListeners();
//   }
//
//   void navigateTo(BuildContext context, String route) {
//     // Handle navigation based on route
//     debugPrint('Navigating to: $route');
//   }
//
//   Future<void> logout(BuildContext context) async {
//     _isLoggingOut = true;
//     notifyListeners();
//
//     // Simulate logout delay
//     await Future.delayed(const Duration(seconds: 1));
//
//     _isLoggingOut = false;
//     notifyListeners();
//
//     // Navigate to login or handle logout
//     debugPrint('User logged out');
//   }
//
//   List<ProfileMenuItem> menuItems(BuildContext context) => [
//     ProfileMenuItem(
//       title: 'Personal Data',
//       subtitle: 'Edit your profile information',
//       icon: Icons.person_outline_rounded,
//       iconBgColor: const Color(0xFFE8F0FE),
//       iconColor: const Color(0xFF4285F4),
//       onTap: () => navigateTo(context, '/personal-data'),
//     ),
//     ProfileMenuItem(
//       title: 'My Utilities',
//       subtitle: 'View active services',
//       icon: Icons.bolt_rounded,
//       iconBgColor: const Color(0xFFE8F5E9),
//       iconColor: const Color(0xFF4CAF50),
//       onTap: () => navigateTo(context, '/utilities'),
//     ),
//     ProfileMenuItem(
//       title: 'My Requests',
//       subtitle: 'Track your switches',
//       icon: Icons.description_outlined,
//       iconBgColor: const Color(0xFFEDE7F6),
//       iconColor: const Color(0xFF7E57C2),
//       onTap: () => navigateTo(context, '/requests'),
//     ),
//     ProfileMenuItem(
//       title: 'Support',
//       subtitle: 'Get help and contact us',
//       icon: Icons.help_outline_rounded,
//       iconBgColor: const Color(0xFFFFF3E0),
//       iconColor: const Color(0xFFFFA726),
//       onTap: () => navigateTo(context, '/support'),
//     ),
//     ProfileMenuItem(
//       title: 'More',
//       subtitle: 'Legal Privacy',
//       icon: Icons.description_outlined,
//       iconBgColor: const Color(0xFFEDE7F6),
//       iconColor: const Color(0xFF7E57C2),
//       onTap: () => navigateTo(context, '/more'),
//     ),
//   ];
// }
//
// // ─────────────────────────────────────────────
// //  SCREEN
// // ─────────────────────────────────────────────
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final ProfileController _controller = ProfileController();
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
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 24),
//                 _buildPageTitle(),
//                 const SizedBox(height: 20),
//                 _buildProfileCard(),
//                 const SizedBox(height: 20),
//                 _buildMenuItems(),
//                 const SizedBox(height: 16),
//                 _buildLogoutButton(),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── Page Title ──
//   Widget _buildPageTitle() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text(
//           'Profile',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w800,
//             color: Color(0xFF1A1A2E),
//             letterSpacing: -0.3,
//           ),
//         ),
//         SizedBox(height: 3),
//         Text(
//           'Manage your account settings',
//           style: TextStyle(
//             fontSize: 13,
//             color: Color(0xFF9E9E9E),
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ── Profile Card ──
//   Widget _buildProfileCard() {
//     final user = _controller.user;
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF3949AB), AppColors.primaryColor],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Avatar + Name + Email
//           Row(
//             children: [
//               // Avatar circle
//               Container(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.person_outline_rounded,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       user.name,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.1,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       user.email,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.75),
//                         fontSize: 12.5,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 18),
//
//           // Divider
//           Divider(
//             color: Colors.white.withOpacity(0.25),
//             height: 1,
//           ),
//
//           const SizedBox(height: 16),
//
//           // Account Type + Switch Button
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Account Type',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.65),
//                       fontSize: 12,
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Text(
//                     _controller.accountTypeLabel,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: _controller.switchAccountType,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 14, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.swap_horiz_rounded,
//                         size: 15,
// color: AppColors.primaryColor,
// ),
// const SizedBox(width: 5),
// Text(
// _controller.switchLabel,
// style: const TextStyle(
//   color: AppColors.primaryColor,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Menu Items ──
//   Widget _buildMenuItems() {
//     final items = _controller.menuItems(context);
//     return Column(
//       children: items.asMap().entries.map((entry) {
//         final i = entry.key;
//         final item = entry.value;
//         return Padding(
//           padding: EdgeInsets.only(bottom: i < items.length - 1 ? 10 : 0),
//           child: _buildMenuItem(item),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildMenuItem(ProfileMenuItem item) {
//     return GestureDetector(
//       onTap: item.onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Icon box
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: item.iconBgColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(item.icon, color: item.iconColor, size: 22),
//             ),
//             const SizedBox(width: 14),
//
//             // Title + Subtitle
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.title,
//                     style: const TextStyle(
//                       fontSize: 14.5,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1A1A2E),
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     item.subtitle,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xFF9E9E9E),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Chevron
//             const Icon(
//               Icons.chevron_right_rounded,
//               color: Color(0xFFBDBDBD),
//               size: 22,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Logout Button ──
//   Widget _buildLogoutButton() {
//     return GestureDetector(
//       onTap: _controller.isLoggingOut
//           ? null
//           : () => _controller.logout(context),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: _controller.isLoggingOut
//             ? const Center(
//           child: SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//               color: Color(0xFFE53935),
//             ),
//           ),
//         )
//             : Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Icon(
//               Icons.logout_rounded,
//               color: Color(0xFFE53935),
//               size: 18,
//             ),
//             SizedBox(width: 8),
//             Text(
//               'Log Out',
//               style: TextStyle(
//                 color: Color(0xFFE53935),
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
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
//       title: 'Profile',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         scaffoldBackgroundColor: const Color(0xFFF7F8FA),
//       ),
//       home: const ProfileScreen(),
//     );
//   }
// }
