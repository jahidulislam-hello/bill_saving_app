import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vyzi/core/navbar/navbar_controller.dart';

/// Navigation utility that routes through the tab navigator when inside
/// the navbar scaffold, falling back to root navigation otherwise.
class NavHelper {
  NavHelper._();

  static NavbarController? get _controller =>
      Get.isRegistered<NavbarController>() ? Get.find<NavbarController>() : null;

  /// Push a screen onto the current tab's navigator.
  /// Falls back to root navigator if navbar is not active.
  static void push(Widget screen) {
    final c = _controller;
    if (c != null) {
      c.navigateInCurrentTab(screen);
    } else {
      Get.to(() => screen);
    }
  }

  /// Replace the top route in the current tab's navigator.
  static void pushReplacement(Widget screen) {
    final c = _controller;
    if (c != null) {
      c.replaceInCurrentTab(screen);
    } else {
      Get.off(() => screen);
    }
  }

  /// Pop the current tab's navigator.
  static void pop() {
    final c = _controller;
    if (c != null && c.canPopCurrentTab()) {
      c.popCurrentTab();
    } else {
      Get.back();
    }
  }

  /// Pop the current tab to its root screen.
  static void popToRoot() {
    final c = _controller;
    if (c != null) {
      c.popToRootCurrentTab();
    }
  }

  /// Switch to a tab (and pop it to root).
  static void switchTab(int index) {
    final c = _controller;
    if (c != null) {
      c.navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      c.changeIndex(index);
    }
  }
}
