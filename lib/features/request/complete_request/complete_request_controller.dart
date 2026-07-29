import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/navbar/nav_helper.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/features/bills/models/bill_model.dart';
import 'package:vyzi/features/request/models/api_offer_model.dart';
import 'package:vyzi/features/request/models/case_model.dart';
import 'package:vyzi/features/request/request_success_screen.dart';

enum PaymentMethod { directDebit, postalOrder }

enum InvoiceMethod { digital, paper }

enum AddressMatch { same, different }

class UploadedDocumentInfo {
  final String localPath;
  final String remoteUrl;
  final String fileName;
  final String documentType;

  const UploadedDocumentInfo({
    required this.localPath,
    required this.remoteUrl,
    required this.fileName,
    required this.documentType,
  });
}

class CompleteRequestController extends ChangeNotifier {
  final ApiService _api = ApiService();

  // ── Passed-in data ──
  final ApiOfferModel offer;
  BillModel? bill;

  // ── Profile data ──
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String codiceFiscale = '';

  // ── Bill-derived data ──
  String podNumber = '';
  String address = '';
  String city = '';

  // ── Payment ──
  String fullName = '';
  String taxCode = '';
  PaymentMethod? selectedPayment;

  // ── Address ──
  AddressMatch? addressMatch;
  String residentialStreet = '';
  String residentialCity = '';
  String residentialZip = '';
  String residentialProvince = '';

  // ── Invoice ──
  InvoiceMethod? selectedInvoice;

  // ── Document upload ──
  List<UploadedDocumentInfo> uploadedDocuments = [];
  bool isUploading = false;

  // ── Loading states ──
  bool isLoadingProfile = true;
  bool isLoadingBill = false;
  bool isSubmitting = false;
  String? error;

  CompleteRequestController({
    required this.offer,
    this.bill,
  }) {
    _initialize();
  }

  Future<void> _initialize() async {
    await fetchProfile();
    if (bill != null) {
      _prefillFromBill(bill!);
    } else {
      await fetchLatestBill();
    }
  }

  // ── Profile fetch ──
  Future<void> fetchProfile() async {
    isLoadingProfile = true;
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.getMyProfile);
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final data = body['data'] as Map<String, dynamic>;

        firstName = data['firstName'] as String? ?? '';
        lastName = data['lastName'] as String? ?? '';
        email = data['email'] as String? ?? '';
        phone = data['phone'] as String? ?? '';
        codiceFiscale = data['codiceFiscale'] as String? ?? '';

        fullName = '$firstName $lastName'.trim();
        taxCode = codiceFiscale;
      }
    } catch (_) {
      // Non-blocking — user can manually enter data
    } finally {
      isLoadingProfile = false;
      notifyListeners();
    }
  }

  // ── Bill fetch ──
  Future<void> fetchLatestBill() async {
    isLoadingBill = true;
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.getMyBills);
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final data = body['data'];
        List<dynamic> rawList;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          rawList = data['data'] as List<dynamic>;
        } else if (data is List<dynamic>) {
          rawList = data;
        } else {
          rawList = [];
        }

        if (rawList.isNotEmpty) {
          bill = BillModel.fromJson(rawList.first as Map<String, dynamic>);
          _prefillFromBill(bill!);
        }
      }
    } catch (_) {
      // Non-blocking — user can proceed without bill pre-fill
    } finally {
      isLoadingBill = false;
      notifyListeners();
    }
  }

  void _prefillFromBill(BillModel b) {
    podNumber = b.podNumber ?? b.pdrNumber ?? '';
    if (b.supplyAddress != null && b.supplyAddress!.isNotEmpty) {
      address = b.supplyAddress!;
    }
    if (b.customerName != null && b.customerName!.isNotEmpty) {
      fullName = b.customerName!;
    }
    if (b.codiceFiscale != null && b.codiceFiscale!.isNotEmpty) {
      taxCode = b.codiceFiscale!;
    }
    notifyListeners();
  }

  // ── Selections ──
  void selectAddressMatch(AddressMatch match) {
    addressMatch = match;
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

  // ── Document upload ──
  Future<void> uploadDocument(String filePath) async {
    if (uploadedDocuments.length >= 3) return;

    isUploading = true;
    notifyListeners();

    try {
      final fileName = filePath.split('/').last;
      final multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      );

      final response = await _api.uploadFile(
        ApiConstants.fileUpload,
        file: multipartFile,
      );

      final body = response.data as Map<String, dynamic>;
      if (body['success'] == true) {
        final data = body['data'] as Map<String, dynamic>;
        final remoteUrl = data['url'] as String? ?? '';
        final remoteName = data['originalName'] as String? ?? fileName;

        // Default to id_card for first doc, codice_fiscale for second
        String docType = 'id_card';
        if (uploadedDocuments.length == 1) {
          docType = 'codice_fiscale';
        } else if (uploadedDocuments.length >= 2) {
          docType = 'id_card';
        }

        uploadedDocuments.add(UploadedDocumentInfo(
          localPath: filePath,
          remoteUrl: remoteUrl,
          fileName: remoteName,
          documentType: docType,
        ));
      } else {
        Get.snackbar(
          'Upload Error',
          body['message']?.toString() ?? 'Failed to upload file',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Upload Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void removeDocument(int index) {
    uploadedDocuments.removeAt(index);
    notifyListeners();
  }

  // ── Case creation ──
  bool get canActivate =>
      bill != null &&
      !isSubmitting &&
      addressMatch != null &&
      selectedPayment != null &&
      selectedInvoice != null &&
      uploadedDocuments.isNotEmpty;

  Future<void> activateOffer() async {
    if (!canActivate) return;

    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      // Step 1: Create the case
      final data = <String, dynamic>{
        'billId': bill!.id,
        'selectedOfferId': offer.id,
      };

      if (addressMatch == AddressMatch.different) {
        data['residentialStreet'] = residentialStreet;
        data['residentialCity'] = residentialCity;
        data['residentialZip'] = residentialZip;
        data['residentialProvince'] = residentialProvince;
      }

      final caseResponse = await _api.post(
        ApiConstants.casesBase,
        data: data,
      );

      final caseBody = caseResponse.data as Map<String, dynamic>;
      if (caseBody['success'] != true) {
        throw Exception(
            caseBody['message']?.toString() ?? 'Failed to create case');
      }

      final caseData = caseBody['data'] as Map<String, dynamic>;
      final createdCase = CaseModel.fromJson(caseData);

      // Step 2: Attach uploaded documents
      for (final doc in uploadedDocuments) {
        try {
          await _api.post(
            ApiConstants.caseDocuments(createdCase.id),
            data: {
              'documentType': doc.documentType,
              'fileUrl': doc.remoteUrl,
              'fileName': doc.fileName,
            },
          );
        } catch (_) {
          // Document attachment failure is non-fatal — case already created
        }
      }

      // Step 3: Navigate to success with case ID
      NavHelper.pushReplacement(RequestSuccessScreen(caseId: createdCase.id));
    } catch (e) {
      error = e.toString();
      Get.snackbar(
        'Error',
        error!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
