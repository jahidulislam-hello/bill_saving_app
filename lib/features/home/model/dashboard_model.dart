class UserDashboardModel {
  final int totalCases;
  final int activeContracts;
  final PotentialSavingsModel potentialSavings;
  final ActiveRequestsSummaryModel activeRequests;

  const UserDashboardModel({
    required this.totalCases,
    required this.activeContracts,
    required this.potentialSavings,
    required this.activeRequests,
  });

  factory UserDashboardModel.fromJson(Map<String, dynamic> json) {
    return UserDashboardModel(
      totalCases: json['totalCases'] as int? ?? 0,
      activeContracts: json['activeContracts'] as int? ?? 0,
      potentialSavings: PotentialSavingsModel.fromJson(
        json['potentialSavings'] as Map<String, dynamic>? ?? {},
      ),
      activeRequests: ActiveRequestsSummaryModel.fromJson(
        json['activeRequests'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class PotentialSavingsModel {
  final double totalSavings;
  final int analyzedBills;

  const PotentialSavingsModel({
    required this.totalSavings,
    required this.analyzedBills,
  });

  factory PotentialSavingsModel.fromJson(Map<String, dynamic> json) {
    return PotentialSavingsModel(
      totalSavings: (json['totalSavings'] as num?)?.toDouble() ?? 0.0,
      analyzedBills: json['analyzedBills'] as int? ?? 0,
    );
  }
}

class ActiveRequestsSummaryModel {
  final int count;
  final List<ActiveCaseModel> requests;

  const ActiveRequestsSummaryModel({
    required this.count,
    required this.requests,
  });

  factory ActiveRequestsSummaryModel.fromJson(Map<String, dynamic> json) {
    return ActiveRequestsSummaryModel(
      count: json['count'] as int? ?? 0,
      requests: (json['requests'] as List<dynamic>?)
              ?.map((e) => ActiveCaseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ActiveCaseModel {
  final String id;
  final String status;
  final String caseNumber;
  final String? caseType;
  final String? priority;
  final String? estimatedAnnualValue;
  final String createdAt;
  final CaseSupplierModel? fromSupplier;
  final CaseSupplierModel? toSupplier;
  final CaseOfferModel? selectedOffer;

  const ActiveCaseModel({
    required this.id,
    required this.status,
    required this.caseNumber,
    this.caseType,
    this.priority,
    this.estimatedAnnualValue,
    required this.createdAt,
    this.fromSupplier,
    this.toSupplier,
    this.selectedOffer,
  });

  factory ActiveCaseModel.fromJson(Map<String, dynamic> json) {
    return ActiveCaseModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      caseNumber: json['caseNumber'] as String? ?? '',
      caseType: json['caseType'] as String?,
      priority: json['priority'] as String?,
      estimatedAnnualValue: json['estimatedAnnualValue']?.toString(),
      createdAt: json['createdAt'] as String? ?? '',
      fromSupplier: json['fromSupplier'] != null
          ? CaseSupplierModel.fromJson(
              json['fromSupplier'] as Map<String, dynamic>)
          : null,
      toSupplier: json['toSupplier'] != null
          ? CaseSupplierModel.fromJson(
              json['toSupplier'] as Map<String, dynamic>)
          : null,
      selectedOffer: json['selectedOffer'] != null
          ? CaseOfferModel.fromJson(
              json['selectedOffer'] as Map<String, dynamic>)
          : null,
    );
  }

  String get displayStatus {
    switch (status) {
      case 'new':
      case 'in_progress':
      case 'documents_pending':
        return 'processing';
      case 'contract_sent':
        return 'readyToSign';
      case 'contract_signed':
      case 'activated':
        return 'completed';
      case 'rejected':
        return 'rejected';
      case 'cancelled':
        return 'cancelled';
      default:
        return 'processing';
    }
  }

  String get displaySubtitle {
    switch (status) {
      case 'new':
        return 'Nuova richiesta';
      case 'in_progress':
        return 'In lavorazione...';
      case 'documents_pending':
        return 'Documenti richiesti';
      case 'contract_sent':
        return 'Contratto inviato';
      case 'contract_signed':
        return 'Contratto firmato';
      case 'activated':
        return 'Contratto confermato';
      case 'rejected':
        return 'Richiesta rifiutata';
      case 'cancelled':
        return 'Richiesta annullata';
      default:
        return status;
    }
  }

  String get formattedDate {
    if (createdAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return createdAt;
    }
  }
}

class CaseSupplierModel {
  final String id;
  final String name;
  final String? logoUrl;

  const CaseSupplierModel({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  factory CaseSupplierModel.fromJson(Map<String, dynamic> json) {
    return CaseSupplierModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
    );
  }
}

class CaseOfferModel {
  final String id;
  final String name;
  final String? energyType;
  final String? pricePerKwh;
  final String? pricePerSmc;
  final String? fixedMonthlyFee;

  const CaseOfferModel({
    required this.id,
    required this.name,
    this.energyType,
    this.pricePerKwh,
    this.pricePerSmc,
    this.fixedMonthlyFee,
  });

  factory CaseOfferModel.fromJson(Map<String, dynamic> json) {
    return CaseOfferModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      energyType: json['energyType'] as String?,
      pricePerKwh: json['pricePerKwh']?.toString(),
      pricePerSmc: json['pricePerSmc']?.toString(),
      fixedMonthlyFee: json['fixedMonthlyFee']?.toString(),
    );
  }
}
