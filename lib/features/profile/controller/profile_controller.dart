import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/exceptions/app_exceptions.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/core/utils/app_colors.dart';

class ProfileController extends ChangeNotifier {
  final ApiService _api = ApiService();
  final ImagePicker _picker = ImagePicker();

  // ── User Info ──
  String name = '';
  String email = '';
  String accountType = 'Privato';
  String memberSince = '';
  String avatarAsset = '';
  String avatarUrl = '';
  bool isUploadingAvatar = false;

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
      final response = await _api.get(ApiConstants.getMyProfile);

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

        // Avatar
        final avatar = data['avatar'] as String?;
        if (avatar != null && avatar.isNotEmpty) {
          avatarUrl = avatar.startsWith('http')
              ? avatar
              : '${ApiConstants.baseUrl}$avatar';
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

  Future<bool> saveChanges() async {
    isSaving = true;
    notifyListeners();

    try {
      final body = <String, dynamic>{
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
      };

      // Only include optional fields if they have a value — empty strings
      // fail backend regex validation for codiceFiscale
      final phone = phoneController.text.trim();
      if (phone.isNotEmpty) {
        body['phone'] = phone;
      }

      final codiceFiscale = codiceFiscaleController.text.trim();
      if (codiceFiscale.isNotEmpty) {
        body['codiceFiscale'] = codiceFiscale;
      }

      final response = await _api.patch(
        ApiConstants.updateProfile,
        data: body,
      );

      final resBody = response.data as Map<String, dynamic>;

      if (resBody['success'] == true) {
        final data = resBody['data'] as Map<String, dynamic>?;
        if (data != null) {
          final firstName = data['firstName'] as String? ?? firstNameController.text;
          final lastName = data['lastName'] as String? ?? lastNameController.text;
          name = '$firstName $lastName'.trim();
          email = data['email'] as String? ?? email;
          phoneController.text = data['phone'] as String? ?? phone;
          codiceFiscaleController.text = data['codiceFiscale'] as String? ?? codiceFiscale;
          firstNameController.text = firstName;
          lastNameController.text = lastName;
          emailController.text = email;
        }

        Get.snackbar(
          'personal_data.update_success_title'.tr,
          'personal_data.update_success_message'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );
        return true;
      }

      return false;
    } on ServerException catch (e) {
      Get.snackbar(
        'personal_data.update_error_title'.tr,
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    } catch (_) {
      Get.snackbar(
        'personal_data.update_error_title'.tr,
        'personal_data.update_error_message'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> pickAndUploadAvatar(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text('personal_data.camera'.tr),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text('personal_data.gallery'.tr),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await _picker.pickImage(source: source, maxWidth: 800, maxHeight: 800, imageQuality: 80);
    if (picked == null) return;

    isUploadingAvatar = true;
    notifyListeners();

    try {
      // Upload the file
      final multipartFile = await MultipartFile.fromFile(
        picked.path,
        filename: picked.name,
      );

      final uploadResponse = await _api.uploadFile(
        ApiConstants.fileUpload,
        file: multipartFile,
      );

      final uploadBody = uploadResponse.data as Map<String, dynamic>;
      if (uploadBody['success'] == true) {
        final data = uploadBody['data'] as Map<String, dynamic>;
        final remoteUrl = data['url'] as String? ?? '';

        // Update profile with the new avatar URL
        await _api.patch(
          ApiConstants.updateProfile,
          data: {'avatar': remoteUrl},
        );

        avatarUrl = remoteUrl.startsWith('http')
            ? remoteUrl
            : '${ApiConstants.baseUrl}$remoteUrl';
        avatarAsset = '';
      }
    } catch (_) {
      // Keep existing avatar on error
    } finally {
      isUploadingAvatar = false;
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
