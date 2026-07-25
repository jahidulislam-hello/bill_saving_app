import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vyzi/features/bills/models/bill_analysis_model.dart';

class BillSupplierModel {
  final String id;
  final String name;

  const BillSupplierModel({
    required this.id,
    required this.name,
  });

  factory BillSupplierModel.fromJson(Map<String, dynamic> json) {
    return BillSupplierModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class BillModel {
  final String id;
  final String fileUrl;
  final String billType;
  final String status;
  final String source;
  final String? podNumber;
  final String? pdrNumber;
  final String? billingPeriodStart;
  final String? billingPeriodEnd;
  final double? totalAmount;
  final double? consumptionKwh;
  final double? consumptionSmc;
  final double? costPerUnit;
  final double? fixedCharges;
  final double? taxes;
  final String? supplyAddress;
  final String? codiceFiscale;
  final String? partitaIva;
  final String? contractNumber;
  final String? meterNumber;
  final String? customerName;
  final Map<String, dynamic>? rawAnalysisData;
  final String userId;
  final String? supplierId;
  final String? meterId;
  final String createdAt;
  final String updatedAt;
  final BillSupplierModel? supplier;
  final BillAnalysisModel? analysis;

  const BillModel({
    required this.id,
    required this.fileUrl,
    required this.billType,
    required this.status,
    this.source = 'upload',
    this.podNumber,
    this.pdrNumber,
    this.billingPeriodStart,
    this.billingPeriodEnd,
    this.totalAmount,
    this.consumptionKwh,
    this.consumptionSmc,
    this.costPerUnit,
    this.fixedCharges,
    this.taxes,
    this.supplyAddress,
    this.codiceFiscale,
    this.partitaIva,
    this.contractNumber,
    this.meterNumber,
    this.customerName,
    this.rawAnalysisData,
    required this.userId,
    this.supplierId,
    this.meterId,
    required this.createdAt,
    required this.updatedAt,
    this.supplier,
    this.analysis,
  });

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Resolves the effective bill status from switch case statuses.
  /// Mirrors the backend's resolveBillStatusFromCases priority logic.
  static String _resolveEffectiveStatus(String billStatus, List<dynamic>? switchCases) {
    if (switchCases == null || switchCases.isEmpty) return billStatus;

    const caseToBill = {
      'activated': 'activated',
      'contract_signed': 'contract_signed',
      'contract_sent': 'contract_sent',
      'in_progress': 'case_created',
      'documents_pending': 'case_created',
      'new': 'case_created',
      'rejected': 'cancelled',
      'cancelled': 'cancelled',
    };
    const priority = {
      'activated': 5,
      'contract_signed': 4,
      'contract_sent': 3,
      'case_created': 2,
      'offer_sent': 1,
      'cancelled': 0,
    };

    int best = -1;
    String resolved = billStatus;
    for (final sc in switchCases) {
      final cs = (sc as Map<String, dynamic>)['status'] as String? ?? '';
      final mapped = caseToBill[cs];
      if (mapped != null && (priority[mapped] ?? 0) > best) {
        best = priority[mapped] ?? 0;
        resolved = mapped;
      }
    }

    // Only use resolved status if it's more advanced than the raw bill status
    if (best > (priority[billStatus] ?? -1)) return resolved;
    return billStatus;
  }

  factory BillModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'] as String? ?? '';
    final effectiveStatus = _resolveEffectiveStatus(
      rawStatus,
      json['switchCases'] as List<dynamic>?,
    );

    return BillModel(
      id: json['id'] as String? ?? '',
      fileUrl: json['fileUrl'] as String? ?? '',
      billType: json['billType'] as String? ?? '',
      status: effectiveStatus,
      source: json['source'] as String? ?? 'upload',
      podNumber: json['podNumber'] as String?,
      pdrNumber: json['pdrNumber'] as String?,
      billingPeriodStart: json['billingPeriodStart'] as String?,
      billingPeriodEnd: json['billingPeriodEnd'] as String?,
      totalAmount: _parseDouble(json['totalAmount']),
      consumptionKwh: _parseDouble(json['consumptionKwh']),
      consumptionSmc: _parseDouble(json['consumptionSmc']),
      costPerUnit: _parseDouble(json['costPerUnit']),
      fixedCharges: _parseDouble(json['fixedCharges']),
      taxes: _parseDouble(json['taxes']),
      supplyAddress: json['supplyAddress'] as String?,
      codiceFiscale: json['codiceFiscale'] as String?,
      partitaIva: json['partitaIva'] as String?,
      contractNumber: json['contractNumber'] as String?,
      meterNumber: json['meterNumber'] as String?,
      customerName: json['customerName'] as String?,
      rawAnalysisData: json['rawAnalysisData'] as Map<String, dynamic>?,
      userId: json['userId'] as String? ?? '',
      supplierId: json['supplierId'] as String?,
      meterId: json['meterId'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      supplier: json['supplier'] != null
          ? BillSupplierModel.fromJson(
              json['supplier'] as Map<String, dynamic>)
          : null,
      analysis: json['analysis'] != null
          ? BillAnalysisModel.fromJson(
              json['analysis'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isEmailSource => source == 'email';

  // ── Display Getters ──

  String get billTypeDisplay {
    switch (billType) {
      case 'electricity':
        return 'bills.type.electricity'.tr;
      case 'gas':
        return 'bills.type.gas'.tr;
      default:
        return billType;
    }
  }

  String get statusDisplay {
    switch (status) {
      case 'pending_email':
        return 'bills.status.pending_email'.tr;
      case 'uploaded':
        return 'bills.status.uploaded'.tr;
      case 'analyzing':
        return 'bills.status.analyzing'.tr;
      case 'analyzed':
        return 'bills.status.analyzed'.tr;
      case 'error':
        return 'bills.status.error'.tr;
      case 'offer_sent':
        return 'bills.status.offer_sent'.tr;
      case 'case_created':
        return 'bills.status.case_created'.tr;
      case 'contract_sent':
        return 'bills.status.contract_sent'.tr;
      case 'contract_signed':
        return 'bills.status.contract_signed'.tr;
      case 'activated':
        return 'bills.status.activated'.tr;
      case 'cancelled':
        return 'bills.status.cancelled'.tr;
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending_email':
        return const Color(0xFF6A1B9A);
      case 'uploaded':
        return const Color(0xFFDFB400);
      case 'analyzing':
        return const Color(0xFFDFB400);
      case 'analyzed':
        return const Color(0xFF1FC16B);
      case 'error':
        return const Color(0xFFE53935);
      case 'offer_sent':
        return const Color(0xFF0097A7);
      case 'case_created':
        return const Color(0xFF7B1FA2);
      case 'contract_sent':
        return const Color(0xFFF57F17);
      case 'contract_signed':
        return const Color(0xFFE65100);
      case 'activated':
        return const Color(0xFF1FC16B);
      case 'cancelled':
        return const Color(0xFF757575);
      default:
        return const Color(0xFFDFB400);
    }
  }

  Color get statusBgColor {
    switch (status) {
      case 'pending_email':
        return const Color(0xFFF3E5F5);
      case 'uploaded':
        return const Color(0xFFFFF3E0);
      case 'analyzing':
        return const Color(0xFFFFF3E0);
      case 'analyzed':
        return const Color(0xFFDCFCE7);
      case 'error':
        return const Color(0xFFFFEBEE);
      case 'offer_sent':
        return const Color(0xFFE0F7FA);
      case 'case_created':
        return const Color(0xFFF3E5F5);
      case 'contract_sent':
        return const Color(0xFFFFF8E1);
      case 'contract_signed':
        return const Color(0xFFFBE9E7);
      case 'activated':
        return const Color(0xFFDCFCE7);
      case 'cancelled':
        return const Color(0xFFF5F5F5);
      default:
        return const Color(0xFFFFF3E0);
    }
  }

  IconData get billTypeIcon {
    return billType == 'gas' ? Icons.local_fire_department : Icons.bolt;
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

  String get totalAmountDisplay {
    if (totalAmount == null) return '-';
    return '€${totalAmount!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get consumptionDisplay {
    if (billType == 'gas' && consumptionSmc != null) {
      return '${consumptionSmc!.toStringAsFixed(2)} Smc';
    }
    if (consumptionKwh != null) {
      return '${consumptionKwh!.toStringAsFixed(2)} kWh';
    }
    return '-';
  }

  String get billingPeriodDisplay {
    if (billingPeriodStart == null && billingPeriodEnd == null) return '-';
    final start = _formatDateStr(billingPeriodStart);
    final end = _formatDateStr(billingPeriodEnd);
    if (start.isNotEmpty && end.isNotEmpty) return '$start - $end';
    if (start.isNotEmpty) return '${'bills.period.from'.tr} $start';
    return end;
  }

  String get costPerUnitDisplay {
    if (costPerUnit == null) return '-';
    final unit = billType == 'gas' ? 'Smc' : 'kWh';
    return '€${costPerUnit!.toStringAsFixed(4)}/$unit';
  }

  String get fixedChargesDisplay {
    if (fixedCharges == null) return '-';
    return '€${fixedCharges!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get taxesDisplay {
    if (taxes == null) return '-';
    return '€${taxes!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get supplierName {
    return supplier?.name ??
        rawAnalysisData?['ocrSupplierName'] as String? ??
        'bills.supplier.unknown'.tr;
  }

  String _formatDateStr(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
