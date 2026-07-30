class UserServiceModel {
  final String id;
  final String? caseId;
  final String? offerId;
  final String? energyType;
  final String? offerName;
  final String? supplierName;
  final String? contractNumber;
  final String? podPdrNumber;
  final String? activationDate;
  final String? expiryDate;
  final String? monthlyEstimate;
  final String? pricePerKwh;
  final String? pricePerSmc;
  final String? fixedMonthlyFee;
  final int? contractDurationDays;
  final bool isGreenEnergy;

  const UserServiceModel({
    required this.id,
    this.caseId,
    this.offerId,
    this.energyType,
    this.offerName,
    this.supplierName,
    this.contractNumber,
    this.podPdrNumber,
    this.activationDate,
    this.expiryDate,
    this.monthlyEstimate,
    this.pricePerKwh,
    this.pricePerSmc,
    this.fixedMonthlyFee,
    this.contractDurationDays,
    this.isGreenEnergy = false,
  });

  factory UserServiceModel.fromJson(Map<String, dynamic> json) {
    return UserServiceModel(
      id: json['id'] as String? ?? '',
      caseId: json['caseId'] as String?,
      offerId: json['offerId'] as String?,
      energyType: json['energyType'] as String?,
      offerName: json['offerName'] as String?,
      supplierName: json['supplierName'] as String?,
      contractNumber: json['contractNumber'] as String?,
      podPdrNumber: json['podPdrNumber'] as String?,
      activationDate: json['activationDate'] as String?,
      expiryDate: json['expiryDate'] as String?,
      monthlyEstimate: json['monthlyEstimate']?.toString(),
      pricePerKwh: json['pricePerKwh']?.toString(),
      pricePerSmc: json['pricePerSmc']?.toString(),
      fixedMonthlyFee: json['fixedMonthlyFee']?.toString(),
      contractDurationDays: json['contractDurationDays'] as int?,
      isGreenEnergy: json['isGreenEnergy'] as bool? ?? false,
    );
  }
}
