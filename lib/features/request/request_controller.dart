import 'package:flutter/material.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/features/bills/models/bill_model.dart';
import 'package:vyzi/features/request/models/api_offer_model.dart';

class RequestController extends ChangeNotifier {
  final ApiService _api = ApiService();

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

  /// Fetches personalized recommended offers from the user's bill analyses.
  /// Each analyzed bill stores its own recommended offers — this method
  /// aggregates them across all bills, deduplicated by offer ID.
  Future<void> fetchOffers() async {
    isLoadingOffers = true;
    offersError = '';
    notifyListeners();

    try {
      // Step 1: Ensure bills are loaded (bills response includes analysis data)
      if (bills.isEmpty && !isLoadingBills) {
        await fetchBills();
      }

      // Step 2: No bills means no personalized offers
      if (bills.isEmpty) {
        offers = [];
        totalOffers = 0;
        return;
      }

      // Step 3: Extract recommended offers from each bill's analysis
      final seen = <String>{};
      final allOffers = <ApiOfferModel>[];

      for (final bill in bills) {
        if (bill.analysis == null) continue;
        for (final rec in bill.analysis!.recommendedOffers) {
          if (rec.id.isNotEmpty && seen.add(rec.id)) {
            allOffers.add(ApiOfferModel(
              id: rec.id,
              name: rec.name,
              energyType: rec.energyType,
              marketType: rec.marketType,
              pricePerKwh: rec.pricePerKwh,
              pricePerSmc: rec.pricePerSmc,
              fixedMonthlyFee: rec.fixedMonthlyFee ?? 0,
              contractDurationMonths: rec.contractDurationMonths,
              isGreenEnergy: rec.isGreenEnergy,
              supplier: rec.supplierName != null
                  ? OfferSupplierModel(
                      id: rec.supplierId, name: rec.supplierName!)
                  : null,
            ));
          }
        }
      }

      offers = allOffers;
      totalOffers = allOffers.length;
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
