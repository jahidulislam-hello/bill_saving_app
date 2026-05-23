import 'package:flutter/material.dart';

enum UploadMethod { uploadFile, scanFile, sendEmail }

class UploadBillController extends ChangeNotifier {
  UploadMethod? selectedMethod;
  bool isLoading = false;

  void selectMethod(UploadMethod method) {
    selectedMethod = method;
    notifyListeners();
  }
}
