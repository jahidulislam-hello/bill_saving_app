class RecommendedOfferModel {
  final String id;
  final String name;
  final String? supplierName;
  final String supplierId;
  final double? pricePerKwh;
  final double? pricePerSmc;
  final double? fixedMonthlyFee;
  final String energyType;
  final String marketType;
  final int contractDurationMonths;
  final bool isGreenEnergy;
  final double? estimatedSavings;

  const RecommendedOfferModel({
    required this.id,
    required this.name,
    this.supplierName,
    required this.supplierId,
    this.pricePerKwh,
    this.pricePerSmc,
    this.fixedMonthlyFee,
    required this.energyType,
    required this.marketType,
    this.contractDurationMonths = 0,
    this.isGreenEnergy = false,
    this.estimatedSavings,
  });

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  factory RecommendedOfferModel.fromJson(Map<String, dynamic> json) {
    return RecommendedOfferModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      supplierName: json['supplierName'] as String?,
      supplierId: json['supplierId'] as String? ?? '',
      pricePerKwh: _parseDouble(json['pricePerKwh']),
      pricePerSmc: _parseDouble(json['pricePerSmc']),
      fixedMonthlyFee: _parseDouble(json['fixedMonthlyFee']),
      energyType: json['energyType'] as String? ?? '',
      marketType: json['marketType'] as String? ?? '',
      contractDurationMonths: json['contractDurationMonths'] as int? ?? 0,
      isGreenEnergy: json['isGreenEnergy'] as bool? ?? false,
      estimatedSavings: _parseDouble(json['estimatedSavings']),
    );
  }

  String get estimatedSavingsDisplay {
    if (estimatedSavings == null) return '-';
    return '€${estimatedSavings!.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}

class BillAnalysisModel {
  final String id;
  final double? potentialSavings;
  final double? currentMonthlyAvg;
  final String? recommendedMarketType;
  final String? analysisSummary;
  final Map<String, dynamic>? analysisDetails;
  final double? confidenceScore;
  final List<RecommendedOfferModel> recommendedOffers;
  final bool offersSentToUser;
  final String billId;
  final String createdAt;
  final String updatedAt;

  const BillAnalysisModel({
    required this.id,
    this.potentialSavings,
    this.currentMonthlyAvg,
    this.recommendedMarketType,
    this.analysisSummary,
    this.analysisDetails,
    this.confidenceScore,
    this.recommendedOffers = const [],
    this.offersSentToUser = false,
    required this.billId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BillAnalysisModel.fromJson(Map<String, dynamic> json) {
    return BillAnalysisModel(
      id: json['id'] as String? ?? '',
      potentialSavings: RecommendedOfferModel._parseDouble(json['potentialSavings']),
      currentMonthlyAvg: RecommendedOfferModel._parseDouble(json['currentMonthlyAvg']),
      recommendedMarketType: json['recommendedMarketType'] as String?,
      analysisSummary: json['analysisSummary'] as String?,
      analysisDetails: json['analysisDetails'] as Map<String, dynamic>?,
      confidenceScore: RecommendedOfferModel._parseDouble(json['confidenceScore']),
      recommendedOffers: (json['recommendedOffers'] as List<dynamic>?)
              ?.map((e) =>
                  RecommendedOfferModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      offersSentToUser: json['offersSentToUser'] as bool? ?? false,
      billId: json['billId'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  String get potentialSavingsDisplay {
    if (potentialSavings == null) return '-';
    return '€${potentialSavings!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get currentMonthlyAvgDisplay {
    if (currentMonthlyAvg == null) return '-';
    return '€${currentMonthlyAvg!.toStringAsFixed(2).replaceAll('.', ',')}/mese';
  }

  String get recommendedMarketTypeDisplay {
    switch (recommendedMarketType) {
      case 'fixed':
        return 'Prezzo fisso';
      case 'variable':
        return 'Prezzo variabile';
      case 'indexed':
        return 'Prezzo indicizzato';
      default:
        return recommendedMarketType ?? '-';
    }
  }

  String get confidenceDisplay {
    if (confidenceScore == null) return '-';
    return '${(confidenceScore! * 100).toStringAsFixed(0)}%';
  }
}
