import 'package:get/get.dart';

class CaseModel {
  final String id;
  final String status;
  final String? caseNumber;
  final String? caseType;
  final String? billId;
  final String? selectedOfferId;
  final String? notes;
  final String createdAt;
  final String? updatedAt;
  final CaseOfferModel? selectedOffer;
  final CaseContractModel? contract;
  final List<CaseEventModel> events;

  const CaseModel({
    required this.id,
    required this.status,
    this.caseNumber,
    this.caseType,
    this.billId,
    this.selectedOfferId,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.selectedOffer,
    this.contract,
    this.events = const [],
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      caseNumber: json['caseNumber'] as String?,
      caseType: json['caseType'] as String?,
      billId: json['billId'] as String?,
      selectedOfferId: json['selectedOfferId'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String?,
      selectedOffer: json['selectedOffer'] != null
          ? CaseOfferModel.fromJson(json['selectedOffer'] as Map<String, dynamic>)
          : null,
      contract: json['contract'] != null
          ? CaseContractModel.fromJson(json['contract'] as Map<String, dynamic>)
          : null,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => CaseEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get statusLabel {
    switch (status) {
      case 'new':
        return 'case.status.new'.tr;
      case 'in_progress':
        return 'case.status.in_progress'.tr;
      case 'documents_pending':
        return 'case.status.documents_pending'.tr;
      case 'contract_sent':
        return 'case.status.contract_sent'.tr;
      case 'contract_signed':
        return 'case.status.contract_signed'.tr;
      case 'activated':
        return 'case.status.activated'.tr;
      case 'rejected':
        return 'case.status.rejected'.tr;
      case 'cancelled':
        return 'case.status.cancelled'.tr;
      default:
        return status;
    }
  }

  int get statusStep {
    switch (status) {
      case 'new':
        return 0;
      case 'in_progress':
        return 1;
      case 'documents_pending':
        return 1;
      case 'contract_sent':
        return 2;
      case 'contract_signed':
        return 3;
      case 'activated':
        return 4;
      default:
        return 0;
    }
  }
}

class CaseOfferModel {
  final String id;
  final String? name;
  final String? energyType;
  final CaseSupplierModel? supplier;

  const CaseOfferModel({
    required this.id,
    this.name,
    this.energyType,
    this.supplier,
  });

  factory CaseOfferModel.fromJson(Map<String, dynamic> json) {
    return CaseOfferModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      energyType: json['energyType'] as String?,
      supplier: json['supplier'] != null
          ? CaseSupplierModel.fromJson(json['supplier'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CaseSupplierModel {
  final String id;
  final String? name;
  final String? logoUrl;

  const CaseSupplierModel({required this.id, this.name, this.logoUrl});

  factory CaseSupplierModel.fromJson(Map<String, dynamic> json) {
    return CaseSupplierModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );
  }
}

class CaseContractModel {
  final String id;
  final String status;
  final String? contractNumber;
  final String? deliveryMethod;
  final String? documentUrl;
  final String? signedDocumentUrl;
  final String? activationDate;
  final String? expiryDate;
  final String? signedAt;

  const CaseContractModel({
    required this.id,
    required this.status,
    this.contractNumber,
    this.deliveryMethod,
    this.documentUrl,
    this.signedDocumentUrl,
    this.activationDate,
    this.expiryDate,
    this.signedAt,
  });

  factory CaseContractModel.fromJson(Map<String, dynamic> json) {
    return CaseContractModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      contractNumber: json['contractNumber'] as String?,
      deliveryMethod: json['deliveryMethod'] as String?,
      documentUrl: json['documentUrl'] as String?,
      signedDocumentUrl: json['signedDocumentUrl'] as String?,
      activationDate: json['activationDate'] as String?,
      expiryDate: json['expiryDate'] as String?,
      signedAt: json['signedAt'] as String?,
    );
  }

  String get statusLabel {
    switch (status) {
      case 'draft':
        return 'contract.status.draft'.tr;
      case 'sent':
        return 'contract.status.sent'.tr;
      case 'signed':
        return 'contract.status.signed'.tr;
      case 'active':
        return 'contract.status.active'.tr;
      case 'expired':
        return 'contract.status.expired'.tr;
      case 'cancelled':
        return 'contract.status.cancelled'.tr;
      default:
        return status;
    }
  }

  String get deliveryMethodLabel {
    switch (deliveryMethod) {
      case 'app':
        return 'contract.delivery.app'.tr;
      case 'email':
        return 'contract.delivery.email'.tr;
      case 'mail':
        return 'contract.delivery.mail'.tr;
      case 'phone':
        return 'contract.delivery.phone'.tr;
      default:
        return deliveryMethod ?? '';
    }
  }
}

class CaseEventModel {
  final String id;
  final String eventType;
  final String title;
  final String? description;
  final String createdAt;

  const CaseEventModel({
    required this.id,
    required this.eventType,
    required this.title,
    this.description,
    required this.createdAt,
  });

  factory CaseEventModel.fromJson(Map<String, dynamic> json) {
    return CaseEventModel(
      id: json['id'] as String? ?? '',
      eventType: json['eventType'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
