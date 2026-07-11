import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/core/services/storage_service.dart';

class AgreementModel {
  final String id;
  final String name;       // partnerName
  final String city;       // parsed from discountDescription / empty fallback
  final String discount;   // discountDescription short
  final String imageUrl;   // partnerLogoUrl
  final String fullName;   // title
  final String description;
  final String offerDate;  // validFrom – validUntil
  final String discountCode; // extracted from discountDescription
  final String address;    // termsUrl fallback / empty
  final List<String> howToUse;

  const AgreementModel({
    required this.id,
    required this.name,
    required this.city,
    required this.discount,
    required this.imageUrl,
    required this.fullName,
    required this.description,
    required this.offerDate,
    required this.discountCode,
    required this.address,
    required this.howToUse,
  });

  factory AgreementModel.fromJson(Map<String, dynamic> json) {
    final partnerName = json['partnerName'] as String? ?? '';
    final title = json['title'] as String? ?? '';
    final description = json['description'] as String? ?? '';
    final discountDesc = json['discountDescription'] as String? ?? '';
    final logoUrl = json['partnerLogoUrl'] as String? ?? '';
    final validFrom = json['validFrom'] as String? ?? '';
    final validUntil = json['validUntil'] as String?;
    final termsUrl = json['termsUrl'] as String? ?? '';
    final id = json['id'] as String? ?? '';

    // Build offerDate string
    final offerDate = validUntil != null
        ? '$validFrom – $validUntil'
        : 'Dal $validFrom';

    // Extract discount code — look for word matching pattern like EASY20, EASY150 etc.
    final codeMatch = RegExp(r'\b([A-Z]{2,}[0-9]+)\b').firstMatch(discountDesc);
    final discountCode = codeMatch?.group(0) ?? '';

    // Use discountDescription as the "discount" display text
    // Shorten to first sentence for the card list
    final discountShort = discountDesc.split('.').first.trim();

    // How to use steps
    final howToUse = [
      'agreements.how_to_1'.tr,
      '${'agreements.how_to_2'.tr}$termsUrl',
      'agreements.how_to_3'.tr,
      'agreements.how_to_4'.tr,
    ];

    return AgreementModel(
      id: id,
      name: partnerName,
      city: '',
      discount: discountShort,
      imageUrl: logoUrl,
      fullName: title,
      description: description,
      offerDate: offerDate,
      discountCode: discountCode,
      address: termsUrl,
      howToUse: howToUse,
    );
  }
}

class AgreementsController extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool isCopied = false;
  String? copiedCode;
  bool isLoading = false;

  List<AgreementModel> agreements = [];

  AgreementsController() {
    fetchAgreements();
  }

  Future<void> fetchAgreements() async {
    isLoading = true;
    notifyListeners();

    try {
      final storage = Get.find<StorageService>();
      final token = storage.getString(StorageKeys.authToken) ?? '';

      final response = await _api.get(
        ApiConstants.getListMyAgreements,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final rawList = body['data'] as List<dynamic>;
        agreements = rawList
            .map((e) => AgreementModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Keep empty list on error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<AgreementModel?> fetchAgreementDetails(String agreementId) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.getString(StorageKeys.authToken) ?? '';

      final url = ApiConstants.getMyAgreementDetails
          .replaceAll('{{agreementId}}', agreementId);

      final response = await _api.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        return AgreementModel.fromJson(
            body['data'] as Map<String, dynamic>);
      }
    } catch (_) {
      // Return null on error
    }
    return null;
  }

  Future<void> copyCode(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    copiedCode = code;
    isCopied = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    isCopied = false;
    copiedCode = null;
    notifyListeners();
  }
}
