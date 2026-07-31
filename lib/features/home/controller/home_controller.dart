// HOME CONTROLLER

import 'package:get/get.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/core/services/storage_service.dart';
import 'package:vyzi/features/home/model/dashboard_model.dart';
import 'package:vyzi/features/home/model/user_service_model.dart';

class HomeController extends GetxController {
  final ApiService _api = ApiService();

  RxBool isLoadingServices = false.obs;
  RxBool isLoadingDashboard = false.obs;
  RxString servicesError = ''.obs;
  RxString dashboardError = ''.obs;

  /// True only for a genuinely new user who has zero server-side activity.
  RxBool isFirstVisit = false.obs;

  /// Whether the first-visit decision still needs server data.
  bool _needsServerCheck = false;

  /// summary data — updated from /api/v1/dashboard/user
  RxString savingAmount = '€0,00'.obs;
  RxInt activeUtilities = 0.obs;

  /// Full dashboard model from API
  Rx<UserDashboardModel?> dashboard = Rx<UserDashboardModel?>(null);

  /// User's activated services from /api/v1/meters/my-services
  RxList<UserServiceModel> serviceList = <UserServiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _checkFirstVisitLocal();
    fetchDashboard();
    fetchServices();
  }

  /// Fast path: if the local flag is already set, skip onboarding immediately.
  /// Otherwise, defer the decision until API data arrives.
  void _checkFirstVisitLocal() {
    final storage = Get.find<StorageService>();
    final userId = storage.getString(StorageKeys.userId) ?? '';
    final key = '${StorageKeys.hasSeenHome}_$userId';
    final seen = storage.getBool(key) ?? false;

    if (seen) {
      isFirstVisit.value = false;
      _needsServerCheck = false;
    } else {
      // Don't show onboarding yet — wait for API to confirm the user is new
      isFirstVisit.value = false;
      _needsServerCheck = true;
    }
  }

  /// Called after each API finishes. Once both are done, decides whether
  /// the user is truly new (zero activity) or an existing user on a new device.
  void _resolveFirstVisit() {
    if (!_needsServerCheck) return;
    if (isLoadingDashboard.value || isLoadingServices.value) return;

    _needsServerCheck = false;

    final hasActivity = (dashboard.value?.totalCases ?? 0) > 0 ||
        (dashboard.value?.activeContracts ?? 0) > 0 ||
        serviceList.isNotEmpty;

    isFirstVisit.value = !hasActivity;

    // Persist the flag so we never check again for this user
    final storage = Get.find<StorageService>();
    final userId = storage.getString(StorageKeys.userId) ?? '';
    final key = '${StorageKeys.hasSeenHome}_$userId';
    storage.setBool(key, true);
  }

  /// Fetches user dashboard data (potential savings + active requests)
  Future<void> fetchDashboard() async {
    isLoadingDashboard.value = true;
    dashboardError.value = '';

    try {
      final response = await _api.get(ApiConstants.userDashboard);
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final data = body['data'] as Map<String, dynamic>;
        final model = UserDashboardModel.fromJson(data);
        dashboard.value = model;

        final savings = model.potentialSavings.totalSavings;
        savingAmount.value =
            '€${savings.toStringAsFixed(2).replaceAll('.', ',')}';
        activeUtilities.value = model.activeContracts;
      } else {
        dashboardError.value =
            body['message']?.toString() ?? 'Failed to load dashboard';
      }
    } catch (e) {
      dashboardError.value = e.toString();
    } finally {
      isLoadingDashboard.value = false;
      _resolveFirstVisit();
    }
  }

  /// Fetches user's activated services (utilities)
  Future<void> fetchServices() async {
    isLoadingServices.value = true;
    servicesError.value = '';

    try {
      final response = await _api.get(ApiConstants.myServices);
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final rawList = body['data'] as List<dynamic>;
        final services = rawList
            .map((e) => UserServiceModel.fromJson(e as Map<String, dynamic>))
            .toList();
        serviceList.assignAll(services);
      } else {
        servicesError.value =
            body['message']?.toString() ?? 'Failed to load services';
      }
    } catch (e) {
      servicesError.value = e.toString();
    } finally {
      isLoadingServices.value = false;
      _resolveFirstVisit();
    }
  }
}
