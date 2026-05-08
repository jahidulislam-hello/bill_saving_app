
import 'package:flutter/material.dart';

enum PaymentMethod { directDebit, postalOrder }
enum InvoiceMethod { digital, paper }
enum AddressMatch { same, different }

class CompleteRequestController extends ChangeNotifier {
  // ── Personal Info ──
  String firstName = 'mahmudul';
  String lastName = 'tamim';
  String email = 'mahmudul14286@gmail.com';
  String phone = '+8801892683582';
  String podNumber = '***********';

  // ── Address ──
  String address = 'Via Roma 123';
  String city = '20100 Milano (MI)';
  AddressMatch? addressMatch;

  // ── Identity Verification ──
  List<String> uploadedFiles = []; // stores file paths
  bool isUploading = false;

  // ── Payment ──
  String fullName = 'Mario Rossi';
  String taxCode = 'RSSMRA8541Y0z';
  PaymentMethod? selectedPayment;

  // ── Invoice ──
  InvoiceMethod? selectedInvoice;

  void selectAddressMatch(AddressMatch match) {
    addressMatch = match;
    notifyListeners();
  }

  void addUploadedFile(String path) {
    if (uploadedFiles.length < 3) {
      uploadedFiles.add(path);
      notifyListeners();
    }
  }

  void removeFile(int index) {
    uploadedFiles.removeAt(index);
    notifyListeners();
  }

  void selectPayment(PaymentMethod method) {
    selectedPayment = method;
    notifyListeners();
  }

  void selectInvoice(InvoiceMethod method) {
    selectedInvoice = method;
    notifyListeners();
  }

  bool get canActivate =>
      addressMatch != null &&
          selectedPayment != null &&
          selectedInvoice != null;
}