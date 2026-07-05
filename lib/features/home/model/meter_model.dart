class MeterModel {
  final String id;
  final String utilityType;
  final String meterCode;
  final String status;
  final String? annualConsumption;
  final String? consumptionUnit;
  final String? contractedPowerKw;
  final String? activationDate;
  final String? notes;
  final SupplierModel supplier;
  final AddressModel address;

  const MeterModel({
    required this.id,
    required this.utilityType,
    required this.meterCode,
    required this.status,
    this.annualConsumption,
    this.consumptionUnit,
    this.contractedPowerKw,
    this.activationDate,
    this.notes,
    required this.supplier,
    required this.address,
  });

  factory MeterModel.fromJson(Map<String, dynamic> json) {
    return MeterModel(
      id: json['id'] as String,
      utilityType: json['utilityType'] as String,
      meterCode: json['meterCode'] as String,
      status: json['status'] as String,
      annualConsumption: json['annualConsumption'] as String?,
      consumptionUnit: json['consumptionUnit'] as String?,
      contractedPowerKw: json['contractedPowerKw'] as String?,
      activationDate: json['activationDate'] as String?,
      notes: json['notes'] as String?,
      supplier: SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>),
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'utilityType': utilityType,
        'meterCode': meterCode,
        'status': status,
        'annualConsumption': annualConsumption,
        'consumptionUnit': consumptionUnit,
        'contractedPowerKw': contractedPowerKw,
        'activationDate': activationDate,
        'notes': notes,
        'supplier': supplier.toJson(),
        'address': address.toJson(),
      };
}

class SupplierModel {
  final String id;
  final String name;
  final String? logoUrl;
  final String? description;
  final String? rating;
  final bool isActive;
  final String? contactEmail;
  final String? contactPhone;
  final String? website;
  final String? supplierCode;

  const SupplierModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.description,
    this.rating,
    required this.isActive,
    this.contactEmail,
    this.contactPhone,
    this.website,
    this.supplierCode,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      description: json['description'] as String?,
      rating: json['rating'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      website: json['website'] as String?,
      supplierCode: json['supplierCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logoUrl': logoUrl,
        'description': description,
        'rating': rating,
        'isActive': isActive,
        'contactEmail': contactEmail,
        'contactPhone': contactPhone,
        'website': website,
        'supplierCode': supplierCode,
      };
}

class AddressModel {
  final String id;
  final String? addressType;
  final String? streetAddress;
  final String? city;
  final String? province;
  final String? postalCode;
  final String? country;
  final bool isPrimary;

  const AddressModel({
    required this.id,
    this.addressType,
    this.streetAddress,
    this.city,
    this.province,
    this.postalCode,
    this.country,
    required this.isPrimary,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      addressType: json['addressType'] as String?,
      streetAddress: json['streetAddress'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'addressType': addressType,
        'streetAddress': streetAddress,
        'city': city,
        'province': province,
        'postalCode': postalCode,
        'country': country,
        'isPrimary': isPrimary,
      };
}
