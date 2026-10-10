import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  /// One GlobalKey<NavigatorState> per tab
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  GlobalKey<NavigatorState> get currentNavigatorKey =>
      navigatorKeys[_selectedIndex.value];

  void changeIndex(int index) {
    if (_selectedIndex.value == index) {
      // Tapping active tab pops to root
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      _selectedIndex.value = index;
    }
  }

  /// Push a screen onto the current tab's navigator
  void navigateInCurrentTab(Widget screen) {
    currentNavigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Push replacement onto the current tab's navigator
  void replaceInCurrentTab(Widget screen) {
    currentNavigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Whether the current tab's navigator can pop
  bool canPopCurrentTab() {
    return currentNavigatorKey.currentState?.canPop() ?? false;
  }

  /// Pop the current tab's navigator
  void popCurrentTab() {
    currentNavigatorKey.currentState?.pop();
  }

  /// Pop the current tab's navigator to its root
  void popToRootCurrentTab() {
    currentNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  }
}
