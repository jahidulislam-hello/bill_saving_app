import 'package:flutter/material.dart';

class SignContractController extends ChangeNotifier {
  bool isBottomSheetOpen = false;
  int tutorialStep = 0; // 0, 1, 2

  final int totalSteps = 3;

  void openTutorial() {
    tutorialStep = 0;
    isBottomSheetOpen = true;
    notifyListeners();
  }

  void closeTutorial() {
    isBottomSheetOpen = false;
    notifyListeners();
  }

  void nextStep() {
    if (tutorialStep < totalSteps - 1) {
      tutorialStep++;
      notifyListeners();
    }
  }

  bool get isLastStep => tutorialStep == totalSteps - 1;
}
