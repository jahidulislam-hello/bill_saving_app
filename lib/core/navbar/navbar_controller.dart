// import 'package:get/get.dart';
//
// class BottomNavbarController extends GetxController {
//   var currentIndex = 0.obs;
//   var previousIndex = 0.obs;
//
//   void changeIndex(int index) {
//     previousIndex.value = currentIndex.value;
//     currentIndex.value = index;
//
//     // Auto refresh when switching to a tab
//     _refreshScreenIfNeeded(index);
//   }
//
//   void _refreshScreenIfNeeded(int index) {
//     switch (index) {
//       case 0:
//         _refreshHomeScreen();
//         break;
//       case 1:
//         _refreshFollowingScreen();
//         break;
//       case 2:
//       // Camera - no refresh needed
//         break;
//       case 3:
//         _refreshMessagesScreen();
//         break;
//       case 4:
//         _refreshProfileScreen();
//         break;
//     }
//   }
//
//   void _refreshHomeScreen() {
//     try {
//       if (Get.isRegistered<VideoController>()) {
//         final controller = Get.find<VideoController>();
//         controller.refreshPosts();
//       }
//     } catch (e) {
//       // Silently ignore
//     }
//   }
//
//   void _refreshFollowingScreen() {
//     try {
//       if (Get.isRegistered<FollowingVideoController>(tag: 'following')) {
//         final controller = Get.find<FollowingVideoController>(tag: 'following');
//         controller.refreshFollowingPosts();
//       }
//     } catch (e) {
//       // Silently ignore
//     }
//   }
//
//   void _refreshMessagesScreen() {
//     try {
//       if (Get.isRegistered<MessageController>()) {
//         final controller = Get.find<MessageController>();
//         controller.refreshConversations();
//       }
//     } catch (e) {
//       // Silently ignore
//     }
//   }
//
//   void _refreshProfileScreen() {
//     try {
//       if (Get.isRegistered<ProfileController>()) {
//         final controller = Get.find<ProfileController>();
//         controller.refreshProfile();
//       }
//     } catch (e) {
//       // Silently ignore
//     }
//   }
//
//   /// Force refresh all screens (call after post creation or significant changes)
//   void refreshAllFeeds() {
//     _refreshHomeScreen();
//     _refreshFollowingScreen();
//     _refreshMessagesScreen();
//     _refreshProfileScreen();
//   }
// }