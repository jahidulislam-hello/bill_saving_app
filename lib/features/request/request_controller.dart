import 'package:flutter/material.dart';
import 'request_model.dart';

class RequestController extends ChangeNotifier {
  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  bool get isYourOffersTab => _selectedTab == 0;
  bool get isMyRequestsTab => _selectedTab == 1;

  void selectTab(int index) {
    if (_selectedTab != index) {
      _selectedTab = index;
      notifyListeners();
    }
  }

  // ── Offers Data ──
  final List<OfferModel> offers = const [
    OfferModel(
      title: 'Green Energy',
      subtitle: 'Green Offer',
      imagePath: '',
      isBestValue: true,
      monthlyCost: 89.99,
      savings: 380,
      savingsPercent: 22,
      hasIndustrialRate: true,
      hasTaxBenefit: true,
    ),
    OfferModel(
      title: 'Green Energy',
      subtitle: 'Green Offer',
      imagePath: '',
      isBestValue: true,
      monthlyCost: 74.50,
      savings: 380,
      savingsPercent: 12,
      hasIndustrialRate: false,
      hasTaxBenefit: true,
    ),
    OfferModel(
      title: 'Solar Plus',
      subtitle: 'Green Energy',
      imagePath: '',
      isBestValue: false,
      monthlyCost: 95.00,
      savings: 310,
      savingsPercent: 28,
      hasIndustrialRate: true,
      hasTaxBenefit: false,
    ),
  ];

  // ── Requests Data (matches screenshot 2) ──
  final List<RequestModel> requests = const [
    RequestModel(
      title: 'Energyplus',
      subtitle: 'Analyzing...',
      status: RequestStatus.processing,
      date: '26/03/2026',
      icon: Icons.bolt,
      iconColor: Color(0xFFFFB800),
    ),
    RequestModel(
      title: 'Energyplus',
      subtitle: 'Analysis complete',
      status: RequestStatus.readyToSign,
      date: '26/03/2026',
      icon: Icons.bolt,
      iconColor: Color(0xFFFFB800),
    ),
    RequestModel(
      title: 'Energyplus',
      subtitle: 'Analysis complete',
      status: RequestStatus.readyToSign,
      date: '26/03/2026',
      icon: Icons.bolt,
      iconColor: Color(0xFFFFB800),
    ),
    RequestModel(
      title: 'PowerGrid Solutions',
      subtitle: 'Contract confirmed',
      status: RequestStatus.completed,
      date: '24/03/2026',
      icon: Icons.bolt,
      iconColor: Color(0xFFFFB800),
    ),
  ];
}
