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

  /// Fetches personalized recommended offers across all user bills.
  /// For each bill the user uploaded, calls GET /api/v1/offers/recommended/:billId
  /// and aggregates the results (deduplicated by offer ID).
  Future<void> fetchOffers() async {
    isLoadingOffers = true;
    offersError = '';
    notifyListeners();

    try {
      // Step 1: Ensure bills are loaded
      if (bills.isEmpty && !isLoadingBills) {
        await fetchBills();
      }

      // Step 2: No bills means no personalized offers
      if (bills.isEmpty) {
        offers = [];
        totalOffers = 0;
        return;
      }

      // Step 3: Fetch recommended offers for each bill in parallel
      final futures = bills.map((bill) async {
        try {
          final response = await _api.get(
            ApiConstants.getRecommendedOffers(bill.id),
          );
          final body = response.data as Map<String, dynamic>;
          if (body['success'] == true) {
            final data = body['data'];
            List<dynamic> rawList;
            if (data is List<dynamic>) {
              rawList = data;
            } else if (data is Map<String, dynamic> &&
                data.containsKey('data')) {
              rawList = data['data'] as List<dynamic>;
            } else {
              rawList = [];
            }
            return rawList
                .map((e) =>
                    ApiOfferModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        } catch (_) {
          // Skip bills whose recommendations fail
        }
        return <ApiOfferModel>[];
      }).toList();

      final results = await Future.wait(futures);

      // Step 4: Combine and deduplicate by offer ID
      final seen = <String>{};
      final allOffers = <ApiOfferModel>[];
      for (final list in results) {
        for (final offer in list) {
          if (offer.id.isNotEmpty && seen.add(offer.id)) {
            allOffers.add(offer);
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
