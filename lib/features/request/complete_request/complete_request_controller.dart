import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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
  String? remoteUrl;
  final String fileName;
  final String documentType;

  UploadedDocumentInfo({
    required this.localPath,
    this.remoteUrl,
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
  String iban = '';
  bool ibanSameAsContract = true;
  String holderFirstName = '';
  String holderLastName = '';
  String holderTaxCode = '';

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

  // ── IBAN validation ──
  static bool isValidItalianIban(String value) {
    final cleaned = value.replaceAll(RegExp(r'\s'), '').toUpperCase();
    if (cleaned.length != 27) return false;
    if (!cleaned.startsWith('IT')) return false;
    return RegExp(r'^[A-Z0-9]+$').hasMatch(cleaned);
  }

  bool get _isPaymentValid {
    if (selectedPayment != PaymentMethod.directDebit) return true;
    if (!isValidItalianIban(iban)) return false;
    if (!ibanSameAsContract) {
      return holderFirstName.trim().isNotEmpty &&
          holderLastName.trim().isNotEmpty &&
          holderTaxCode.trim().isNotEmpty;
    }
    return true;
  }

  // ── Document selection (multi-file, deferred upload) ──
  Future<void> pickDocuments() async {
    final remaining = 3 - uploadedDocuments.length;
    if (remaining <= 0) return;

    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      );

      if (result == null || result.files.isEmpty) return;

      final filesToAdd = result.files.take(remaining);
      for (final file in filesToAdd) {
        if (file.path == null) continue;
        final fileName = file.name;
        final currentCount = uploadedDocuments.length;

        String docType = 'id_card';
        if (currentCount == 1) {
          docType = 'codice_fiscale';
        }

        uploadedDocuments.add(UploadedDocumentInfo(
          localPath: file.path!,
          fileName: fileName,
          documentType: docType,
        ));
      }
      notifyListeners();
    } catch (e) {
      Get.snackbar(
        'File Selection Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  /// Uploads all pending local documents to the server.
  /// Returns true if all uploads succeeded.
  Future<bool> _uploadPendingDocuments() async {
    bool allSucceeded = true;
    for (final doc in uploadedDocuments) {
      if (doc.remoteUrl != null) continue; // already uploaded

      try {
        final multipartFile = await MultipartFile.fromFile(
          doc.localPath,
          filename: doc.fileName,
        );

        final response = await _api.uploadFile(
          ApiConstants.fileUpload,
          file: multipartFile,
        );

        final body = response.data as Map<String, dynamic>;
        if (body['success'] == true) {
          final data = body['data'] as Map<String, dynamic>;
          doc.remoteUrl = data['url'] as String? ?? '';
        } else {
          allSucceeded = false;
        }
      } catch (_) {
        allSucceeded = false;
      }
    }
    return allSucceeded;
  }

  void removeDocument(int index) {
    uploadedDocuments.removeAt(index);
    notifyListeners();
  }

  // ── Case creation ──
  bool get canActivate =>
      bill != null &&
      !isSubmitting &&
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      podNumber.trim().isNotEmpty &&
      addressMatch != null &&
      selectedPayment != null &&
      selectedInvoice != null &&
      uploadedDocuments.isNotEmpty &&
      _isPaymentValid;

  Future<void> activateOffer() async {
    if (!canActivate) return;

    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      // Step 1: Upload all pending identity documents
      final uploadSuccess = await _uploadPendingDocuments();
      if (!uploadSuccess) {
        throw Exception('Failed to upload one or more identity documents');
      }

      // Step 2: Create the case
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

      // Payment method & IBAN
      data['paymentMethod'] = selectedPayment == PaymentMethod.directDebit
          ? 'rid_bancario'
          : 'postal_order';
      data['invoiceDelivery'] = selectedInvoice == InvoiceMethod.digital
          ? 'digital'
          : 'paper';
      if (selectedPayment == PaymentMethod.directDebit) {
        data['iban'] = iban.replaceAll(RegExp(r'\s'), '').toUpperCase();
        if (!ibanSameAsContract) {
          data['ibanHolderFirstName'] = holderFirstName;
          data['ibanHolderLastName'] = holderLastName;
          data['ibanHolderTaxCode'] = holderTaxCode;
        }
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

      // Step 3: Attach uploaded documents
      for (final doc in uploadedDocuments) {
        try {
          await _api.post(
            ApiConstants.caseDocuments(createdCase.id),
            data: {
              'documentType': doc.documentType,
              'fileUrl': doc.remoteUrl ?? '',
              'fileName': doc.fileName,
            },
          );
        } catch (_) {
          // Document attachment failure is non-fatal — case already created
        }
      }

      // Step 4: Navigate to success with case ID
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
