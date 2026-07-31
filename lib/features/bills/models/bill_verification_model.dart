class BillVerificationModel {
  final String id;
  final String billId;
  final String adminMessage;
  final List<String> missingFields;
  final bool requireReupload;
  final String status; // pending, submitted, resolved
  final String? userMessage;
  final Map<String, dynamic>? userData;
  final String createdAt;

  const BillVerificationModel({
    required this.id,
    required this.billId,
    required this.adminMessage,
    required this.missingFields,
    required this.requireReupload,
    required this.status,
    this.userMessage,
    this.userData,
    required this.createdAt,
  });

  factory BillVerificationModel.fromJson(Map<String, dynamic> json) {
    return BillVerificationModel(
      id: json['id']?.toString() ?? '',
      billId: json['billId']?.toString() ?? '',
      adminMessage: json['adminMessage']?.toString() ?? '',
      missingFields: (json['missingFields'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      requireReupload: json['requireReupload'] == true,
      status: json['status']?.toString() ?? 'pending',
      userMessage: json['userMessage']?.toString(),
      userData: json['userData'] is Map<String, dynamic>
          ? json['userData'] as Map<String, dynamic>
          : null,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  bool get isPending => status == 'pending';

  static const Map<String, String> fieldLabels = {
    'podNumber': 'POD Number',
    'pdrNumber': 'PDR Number',
    'totalAmount': 'Total Amount (€)',
    'consumptionKwh': 'Consumption (kWh)',
    'consumptionSmc': 'Consumption (Smc)',
    'costPerUnit': 'Cost per Unit (€)',
    'fixedCharges': 'Fixed Charges (€)',
    'taxes': 'Taxes (€)',
    'billingPeriodStart': 'Billing Period Start',
    'billingPeriodEnd': 'Billing Period End',
    'supplyAddress': 'Supply Address',
    'codiceFiscale': 'Codice Fiscale',
    'partitaIva': 'Partita IVA',
    'contractNumber': 'Contract Number',
    'meterNumber': 'Meter Number',
    'customerName': 'Account Holder',
    'supplierName': 'Supplier Name',
  };

  String labelForField(String field) =>
      fieldLabels[field] ?? field;
}
