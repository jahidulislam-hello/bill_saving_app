// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
//
// class BottomNavbar extends StatefulWidget {
//   const BottomNavbar({super.key});
//
//   @override
//   State<BottomNavbar> createState() => _BottomNavbarState();
// }
//
// class _BottomNavbarState extends State<BottomNavbar> {
//   final BottomNavbarController controller = Get.put(BottomNavbarController());
//
//   final List<Widget> pages = [
//     HomeVideoScreen(),
//     FollowingVideoScreen(),
//     CameraScreen(),
//     MessagesScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.navbarHome,
//       // Use IndexedStack to keep all screens in memory and prevent rebuilding
//       body: Obx(() => IndexedStack(
//         index: controller.currentIndex.value,
//         children: pages,
//       )),
//       bottomNavigationBar: Obx(() {
//         // Hide navbar when Camera tab is selected
//         if (controller.currentIndex.value == 2) {
//           return const SizedBox.shrink();
//         }
//         return Container(
//           height:54.h, // fixed height
//           margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Row(
//             children: [
//               _buildNavItem(
//                 activeImage: "assets/images/act_home.png",
//                 passiveImage: "assets/images/pass_home.png",
//                 index: 0,
//               ),
//               _buildNavItem(
//                 activeImage: "assets/images/act_following.png",
//                 passiveImage: "assets/images/following.png",
//                 index: 1,
//               ),
//               _buildNavItem(
//                 activeImage: "assets/images/lock.png",
//                 passiveImage: "assets/images/lock.png",
//                 index: 2,
//               ),
//               _buildNavItem(
//                 activeImage: "assets/images/act_chat.png",
//                 passiveImage: "assets/images/chat.png",
//                 index: 3,
//               ),
//               _buildNavItem(
//                 activeImage: "assets/images/act_profile.png",
//                 passiveImage: "assets/images/profile.png",
//                 index: 4,
//               ),
//             ].map((e) => Expanded(child: e)).toList(),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildNavItem({
//     required String activeImage,
//     required String passiveImage,
//     required int index,
//   }) {
//     return GestureDetector(
//       onTap: () => controller.changeIndex(index),
//       child: Obx(() {
//         final isSelected = controller.currentIndex.value == index;
//
//         return Image.asset(
//           isSelected ? activeImage : passiveImage,
//           height: 56.h,
//           fit: BoxFit.contain,
//         );
//       }),
//     );
//   }
// }