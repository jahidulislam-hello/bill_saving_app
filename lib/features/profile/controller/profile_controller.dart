
import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  // ── User Info ──
  String name = 'Alex Harrison';
  String email = 'alexsmith.mobbin@gmail.com';
  String accountType = 'Privato';
  String memberSince = 'Membro dal Gennaio 2024';
  String avatarAsset = ''; // set your asset path here

  // ── Personal Data form fields ──
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController =
  TextEditingController(text: 'alexsmith.mobbin@gmail.com');
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codiceFiscaleController =
  TextEditingController(text: 'RSSMRA231X1WDF52');

  bool isSaving = false;

  void switchToBusiness() {
    accountType = accountType == 'Privato' ? 'Azienda' : 'Privato';
    notifyListeners();
  }

  Future<void> saveChanges() async {
    isSaving = true;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    name =
    '${firstNameController.text} ${lastNameController.text}'.trim().isNotEmpty
        ? '${firstNameController.text} ${lastNameController.text}'.trim()
        : name;
    email = emailController.text.isNotEmpty ? emailController.text : email;
    isSaving = false;
    notifyListeners();
  }

  void cancelChanges() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.text = email;
    phoneController.clear();
    codiceFiscaleController.text = 'RSSMRA231X1WDF52';
    notifyListeners();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    codiceFiscaleController.dispose();
    super.dispose();
  }
}