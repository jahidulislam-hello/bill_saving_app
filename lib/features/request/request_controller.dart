import 'package:flutter/material.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/features/bills/models/bill_model.dart';
import 'package:vyzi/features/request/models/api_offer_model.dart';

class RequestController extends ChangeNotifier {
  final ApiService _api = ApiService();

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  int _selectedTab = 0;

  // Offers state
  bool isLoadingOffers = false;
  String offersError = '';
  List<ApiOfferModel> offers = [];
  int totalOffers = 0;

  // Bills (My Requests) state
  bool isLoadingBills = false;
  String billsError = '';
  List<BillModel> bills = [];
  int totalBills = 0;

  int get selectedTab => _selectedTab;

  bool get isYourOffersTab => _selectedTab == 0;
  bool get isMyRequestsTab => _selectedTab == 1;

  void selectTab(int index) {
    if (_selectedTab != index) {
      _selectedTab = index;
      if (index == 1 && bills.isEmpty && !isLoadingBills) {
        fetchBills();
      }
      notifyListeners();
    }
  }

  /// Fetches the user's sent offers from GET /api/v1/offers/my-offers.
  /// These are offers that were sent to the user (auto or manually by admin)
  /// after bill analysis. Deduplicates by offer ID.
  Future<void> fetchOffers() async {
    isLoadingOffers = true;
    offersError = '';
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.getMyOffers);
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final data = body['data'];
        final rawList = data is List<dynamic> ? data : <dynamic>[];

        final seen = <String>{};
        final allOffers = <ApiOfferModel>[];

        for (final item in rawList) {
          final map = item as Map<String, dynamic>;
          final offerData = map['offer'] as Map<String, dynamic>?;
          final snapshot = map['offerSnapshot'] as Map<String, dynamic>?;

          // Prefer live offer data, fall back to snapshot
          if (offerData != null) {
            final enriched = {...offerData, 'estimatedSavings': map['estimatedSavings']};
            final offer = ApiOfferModel.fromJson(enriched);
            if (offer.id.isNotEmpty && seen.add(offer.id)) {
              allOffers.add(offer);
            }
          } else if (snapshot != null) {
            final id = snapshot['id'] as String? ?? '';
            if (id.isNotEmpty && seen.add(id)) {
              allOffers.add(ApiOfferModel(
                id: id,
                name: snapshot['name'] as String? ?? '',
                energyType: snapshot['energyType'] as String? ?? '',
                marketType: snapshot['marketType'] as String? ?? '',
                pricePerKwh: _parseDouble(snapshot['pricePerKwh']),
                pricePerSmc: _parseDouble(snapshot['pricePerSmc']),
                fixedMonthlyFee: _parseDouble(snapshot['fixedMonthlyFee']) ?? 0,
                contractDurationDays:
                    snapshot['contractDurationDays'] as int? ?? 0,
                isGreenEnergy: snapshot['isGreenEnergy'] as bool? ?? false,
                supplier: snapshot['supplierName'] != null
                    ? OfferSupplierModel(
                        id: snapshot['supplierId'] as String? ?? '',
                        name: snapshot['supplierName'] as String)
                    : null,
                estimatedSavings: _parseDouble(map['estimatedSavings']),
              ));
            }
          }
        }

        offers = allOffers;
        totalOffers = allOffers.length;
      } else {
        offersError = body['message']?.toString() ?? 'Failed to load offers';
      }
    } catch (e) {
      offersError = e.toString();
    } finally {
      isLoadingOffers = false;
      notifyListeners();
    }
  }

  /// Fetches user's bills from GET /api/v1/bills
  Future<void> fetchBills() async {
    isLoadingBills = true;
    billsError = '';
    notifyListeners();

    try {
      final response = await _api.get(ApiConstants.getMyBills);
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final data = body['data'];

        List<dynamic> rawList;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          rawList = data['data'] as List<dynamic>;
          final meta = data['meta'] as Map<String, dynamic>?;
          totalBills = meta?['total'] as int? ?? rawList.length;
        } else if (data is List<dynamic>) {
          rawList = data;
          totalBills = rawList.length;
        } else {
          rawList = [];
          totalBills = 0;
        }

        bills = rawList
            .map((e) => BillModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        billsError = body['message']?.toString() ?? 'Failed to load bills';
      }
    } catch (e) {
      billsError = e.toString();
    } finally {
      isLoadingBills = false;
      notifyListeners();
    }
  }
}
