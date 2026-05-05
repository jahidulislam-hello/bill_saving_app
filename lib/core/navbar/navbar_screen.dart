//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class CustomBottomNavBar extends StatefulWidget {
//   const CustomBottomNavBar({super.key});
//
//   @override
//   State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }
//
// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = [
//     HomeScreen(),
//     BetMarketScreen(),
//     MessagesScreen(),
//     SettingsProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _screens[_currentIndex],
//       bottomNavigationBar: _buildBottomNavigationBar(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: _buildFloatingActionButton(),
//     );
//   }
//
//   /// Floating Action Button
//   Widget _buildFloatingActionButton() {
//     return SizedBox(
//       height: 69,
//       width: 69,
//       child: FloatingActionButton(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         onPressed: () {
//           Get.to(() => ());
//         },
//
//         shape: const CircleBorder(),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(40),
//           child: Image.asset(
//             "assets/images/icon.png",
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Bottom Navigation Bar
//   Widget _buildBottomNavigationBar() {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(
//             index: 0,
//             activeImage: "assets/images/act_home.png",
//             passiveImage: "assets/images/pass_home.png",
//           ),
//           _buildNavItem(
//             index: 1,
//             activeImage: "assets/images/act_bet.png",
//             passiveImage: "assets/images/pass_bet.png",
//           ),
//           const SizedBox(width: 50), // Space for FAB
//           _buildNavItem(
//             index: 2,
//             activeImage: "assets/images/act_chat.png",
//             passiveImage: "assets/images/pass_chat.png",
//           ),
//           _buildNavItem(
//             index: 3,
//             activeImage: "assets/images/act_profile.png",
//             passiveImage: "assets/images/pass_profile.png",
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Navigation Item with Image Icons
//   Widget _buildNavItem({
//     required int index,
//     required String activeImage,
//     required String passiveImage,
//   }) {
//     bool isSelected = _currentIndex == index;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _currentIndex = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         child: Image.asset(
//           isSelected ? activeImage : passiveImage,
//           width: 60,
//           height: 60,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }