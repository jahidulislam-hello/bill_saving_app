import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  MODELS
// ─────────────────────────────────────────────

class OfferModel {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isBestValue;
  final double monthlyCost;
  final double savings;
  final int savingsPercent;
  final bool hasIndustrialRate;
  final bool hasTaxBenefit;

  const OfferModel({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isBestValue,
    required this.monthlyCost,
    required this.savings,
    required this.savingsPercent,
    required this.hasIndustrialRate,
    required this.hasTaxBenefit,
  });
}

enum RequestStatus { processing, readyToSign, completed }

class RequestModel {
  final String title;
  final String subtitle;
  final RequestStatus status;
  final String date;
  final IconData icon;
  final Color iconColor;

  const RequestModel({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.date,
    required this.icon,
    required this.iconColor,
  });
}

// ─────────────────────────────────────────────
//  CONTROLLER
// ─────────────────────────────────────────────

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
      title: 'Business Energy pro',
      subtitle: 'Commercial',
      imagePath: '',
      isBestValue: true,
      monthlyCost: 89.99,
      savings: 25.5,
      savingsPercent: 22,
      hasIndustrialRate: true,
      hasTaxBenefit: true,
    ),
    OfferModel(
      title: 'Energy Basic',
      subtitle: 'Residential',
      imagePath: '',
      isBestValue: false,
      monthlyCost: 74.50,
      savings: 10.0,
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
      savings: 30.0,
      savingsPercent: 28,
      hasIndustrialRate: true,
      hasTaxBenefit: false,
    ),
  ];

  // ── Requests Data ──
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
      subtitle: 'Analyzing...',
      status: RequestStatus.processing,
      date: '26/03/2026',
      icon: Icons.bolt,
      iconColor: Color(0xFFFFB800),
    ),
    RequestModel(
      title: 'Gas',
      subtitle: 'EnergyPlus',
      status: RequestStatus.readyToSign,
      date: '26/03/2026',
      icon: Icons.local_fire_department,
      iconColor: Color(0xFFFF5722),
    ),
  ];
}

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  final RequestController _controller = RequestController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.selectTab(_tabController.index);
        setState(() {});
      }
    });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildYourOffersTab(),
                  _buildMyRequestsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Center(
        child: Text(
          'Request',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  // ── Tab Bar ──
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF1A1A2E),
        unselectedLabelColor: const Color(0xFF9E9E9E),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        indicatorColor: const Color(0xFF1A1A2E),
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: 'Your Offers'),
          Tab(text: 'My Requests'),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  YOUR OFFERS TAB
  // ─────────────────────────────────────────────

  Widget _buildYourOffersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          _buildOffersHeader(),
          const SizedBox(height: 12),
          ..._controller.offers.map((offer) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOfferCard(offer),
          )),
        ],
      ),
    );
  }

  Widget _buildOffersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Best Offers for You',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        Text(
          '${_controller.offers.length} found',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(OfferModel offer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              // Image / icon placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.bolt, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      offer.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
              if (offer.isBestValue)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Best Value',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 14),

          // Cost row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly cost',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${offer.monthlyCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'You save',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${offer.savings}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${offer.savingsPercent}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Badges row
          Row(
            children: [
              if (offer.hasIndustrialRate)
                _buildBadge(Icons.business, 'Industrial Rate'),
              if (offer.hasIndustrialRate && offer.hasTaxBenefit)
                const SizedBox(width: 12),
              if (offer.hasTaxBenefit)
                _buildBadge(Icons.home_work_outlined, 'Tax Benefit Eligible'),
            ],
          ),

          const SizedBox(height: 14),

          // View Details button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF9E9E9E)),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  MY REQUESTS TAB
  // ─────────────────────────────────────────────

  Widget _buildMyRequestsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: _controller.requests
            .map((req) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildRequestCard(req),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildRequestCard(RequestModel request) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          // Icon box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: request.iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(request.icon, color: request.iconColor, size: 22),
          ),
          const SizedBox(width: 12),

          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  request.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatusChip(request.status),
              ],
            ),
          ),

          // Right side: icon + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatusIcon(request.status),
              const SizedBox(height: 18),
              Text(
                request.date,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(RequestStatus status) {
    switch (status) {
      case RequestStatus.processing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Processing',
            style: TextStyle(
              color: Color(0xFFF57F17),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case RequestStatus.readyToSign:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE7F6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Ready to Sign',
            style: TextStyle(
              color: Color(0xFF7B1FA2),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case RequestStatus.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Completed',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }

  Widget _buildStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.processing:
        return const Icon(Icons.access_time_rounded,
            color: Color(0xFF9E9E9E), size: 18);
      case RequestStatus.readyToSign:
        return const Icon(Icons.insert_drive_file_outlined,
            color: Color(0xFF7B1FA2), size: 18);
      case RequestStatus.completed:
        return const Icon(Icons.check_circle_outline,
            color: Color(0xFF4CAF50), size: 18);
    }
  }
}

// ─────────────────────────────────────────────
//  ENTRY POINT (for standalone testing)
// ─────────────────────────────────────────────

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),
      home: const RequestScreen(),
    );
  }
}