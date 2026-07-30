class ApiOfferModel {
  final String id;
  final String name;
  final String? description;
  final String energyType;
  final String marketType;
  final double? pricePerKwh;
  final double? pricePerSmc;
  final double fixedMonthlyFee;
  final double activationCost;
  final int contractDurationDays;
  final bool isGreenEnergy;
  final String? validFrom;
  final String? validUntil;
  final String? termsUrl;
  final String? economicConditionsUrl;
  final String target;
  final List<String> highlights;
  final String? offerCode;
  final OfferSupplierModel? supplier;
  final double? estimatedSavings;

  const ApiOfferModel({
    required this.id,
    required this.name,
    this.description,
    required this.energyType,
    required this.marketType,
    this.pricePerKwh,
    this.pricePerSmc,
    this.fixedMonthlyFee = 0,
    this.activationCost = 0,
    this.contractDurationDays = 0,
    this.isGreenEnergy = false,
    this.validFrom,
    this.validUntil,
    this.termsUrl,
    this.economicConditionsUrl,
    this.target = 'both',
    this.highlights = const [],
    this.offerCode,
    this.supplier,
    this.estimatedSavings,
  });

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int _parseInt(dynamic value, [int fallback = 0]) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  factory ApiOfferModel.fromJson(Map<String, dynamic> json) {
    return ApiOfferModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      energyType: json['energyType'] as String? ?? '',
      marketType: json['marketType'] as String? ?? '',
      pricePerKwh: _parseDouble(json['pricePerKwh']),
      pricePerSmc: _parseDouble(json['pricePerSmc']),
      fixedMonthlyFee: _parseDouble(json['fixedMonthlyFee']) ?? 0,
      activationCost: _parseDouble(json['activationCost']) ?? 0,
      contractDurationDays: _parseInt(json['contractDurationDays']),
      isGreenEnergy: json['isGreenEnergy'] as bool? ?? false,
      validFrom: json['validFrom'] as String?,
      validUntil: json['validUntil'] as String?,
      termsUrl: json['termsUrl'] as String?,
      economicConditionsUrl: json['economicConditionsUrl'] as String?,
      target: json['target'] as String? ?? 'both',
      highlights: (json['highlights'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      offerCode: json['offerCode'] as String?,
      supplier: json['supplier'] != null
          ? OfferSupplierModel.fromJson(
              json['supplier'] as Map<String, dynamic>)
          : null,
      estimatedSavings: _parseDouble(json['estimatedSavings']),
    );
  }

  /// Formatted estimated savings for display
  String get estimatedSavingsDisplay {
    if (estimatedSavings == null) return '-';
    return '€${estimatedSavings!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Formatted energy price string for display
  String get energyPriceDisplay {
    if (marketType == 'indexed') {
      final price = pricePerKwh ?? pricePerSmc ?? 0;
      final unit = pricePerKwh != null ? 'KWh' : 'Sm³';
      return 'PUN GME + €${price.toStringAsFixed(2)}/$unit';
    }
    final price = pricePerKwh ?? pricePerSmc;
    if (price == null) return '';
    final unit = pricePerKwh != null ? 'KWh' : 'Sm³';
    return '€${price.toStringAsFixed(4)}/$unit';
  }

  /// Market type display label
  String get marketTypeDisplay {
    switch (marketType) {
      case 'fixed':
        return 'Prezzo fisso';
      case 'variable':
        return 'Prezzo variabile';
      case 'indexed':
        return 'Prezzo indicizzato';
      default:
        return marketType;
    }
  }

  /// Contract duration display — months by default, days if < 30
  String get contractDurationDisplay {
    if (contractDurationDays <= 0) return 'Durata indeterminata';
    if (contractDurationDays < 30) {
      return contractDurationDays == 1 ? '1 giorno' : '$contractDurationDays giorni';
    }
    final months = contractDurationDays ~/ 30;
    return months == 1 ? '1 mese' : '$months mesi';
  }

  /// Contractual binding display — months by default, days if < 30
  String get bindingDisplay {
    if (contractDurationDays <= 0) return 'Nessun vincolo';
    if (contractDurationDays < 30) return '$contractDurationDays giorni';
    final months = contractDurationDays ~/ 30;
    return '$months mesi';
  }
}

class OfferSupplierModel {
  final String id;
  final String name;
  final String? logoUrl;
  final String? description;
  final double? rating;

  const OfferSupplierModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.description,
    this.rating,
  });

  factory OfferSupplierModel.fromJson(Map<String, dynamic> json) {
    return OfferSupplierModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
      description: json['description'] as String?,
      rating: ApiOfferModel._parseDouble(json['rating']),
    );
  }
}
