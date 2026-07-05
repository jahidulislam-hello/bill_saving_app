import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/core/services/storage_service.dart';

class ProfileController extends ChangeNotifier {
  final ApiService _api = ApiService();

  // ── User Info ──
  String name = '';
  String email = '';
  String accountType = 'Privato';
  String memberSince = '';
  String avatarAsset = '';

  // ── Personal Data form fields ──
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codiceFiscaleController = TextEditingController();

  bool isSaving = false;
  bool isLoading = false;

  ProfileController() {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      final storage = Get.find<StorageService>();
      final token = storage.getString(StorageKeys.authToken) ?? '';

      final response = await _api.get(
        ApiConstants.getMyProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final data = body['data'] as Map<String, dynamic>;

        final firstName = data['firstName'] as String? ?? '';
        final lastName = data['lastName'] as String? ?? '';

        name = '$firstName $lastName'.trim();
        email = data['email'] as String? ?? '';
        accountType = data['role'] == 'business' ? 'Azienda' : 'Privato';

        // memberSince from createdAt
        final createdAt = data['createdAt'] as String?;
        if (createdAt != null) {
          final dt = DateTime.tryParse(createdAt);
          if (dt != null) {
            const months = [
              'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
              'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
            ];
            memberSince = 'Membro dal ${months[dt.month - 1]} ${dt.year}';
          }
        }

        // Populate form fields
        firstNameController.text = firstName;
        lastNameController.text = lastName;
        emailController.text = email;
        phoneController.text = data['phone'] as String? ?? '';
        codiceFiscaleController.text = data['codiceFiscale'] as String? ?? '';
      }
    } catch (_) {
      // Keep existing values on error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void switchToBusiness() {
    accountType = accountType == 'Privato' ? 'Azienda' : 'Privato';
    notifyListeners();
  }

  Future<void> saveChanges() async {
    isSaving = true;
    notifyListeners();

    try {
      final storage = Get.find<StorageService>();
      final token = storage.getString(StorageKeys.authToken) ?? '';

      final body = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'codiceFiscale': codiceFiscaleController.text.trim(),
      };

      final response = await _api.patch(
        ApiConstants.updateProfile,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final resBody = response.data as Map<String, dynamic>;
      final data = resBody['data'] as Map<String, dynamic>?;

      if (data != null) {
        final firstName = data['firstName'] as String? ?? firstNameController.text;
        final lastName = data['lastName'] as String? ?? lastNameController.text;
        name = '$firstName $lastName'.trim();
        email = data['email'] as String? ?? email;
        firstNameController.text = firstName;
        lastNameController.text = lastName;
        emailController.text = email;
      }
    } catch (_) {
      // Keep existing values on error
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  void cancelChanges() {
    // Restore form fields from current values
    final parts = name.split(' ');
    firstNameController.text = parts.isNotEmpty ? parts.first : '';
    lastNameController.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    emailController.text = email;
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
