// HOME CONTROLLER

import 'package:get/get.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/features/home/model/dashboard_model.dart';
import 'package:vyzi/features/home/model/user_service_model.dart';

class HomeController extends GetxController {
  final ApiService _api = ApiService();

  RxBool isLoadingServices = false.obs;
  RxBool isLoadingDashboard = false.obs;
  RxString servicesError = ''.obs;
  RxString dashboardError = ''.obs;

  /// summary data — updated from /api/v1/dashboard/user
  RxString savingAmount = '€0,00'.obs;
  RxInt activeRequest = 0.obs;

  /// Full dashboard model from API
  Rx<UserDashboardModel?> dashboard = Rx<UserDashboardModel?>(null);

  /// User's activated services from /api/v1/meters/my-services
  RxList<UserServiceModel> serviceList = <UserServiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
    fetchServices();
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
        activeRequest.value = model.activeRequests.count;
      } else {
        dashboardError.value =
            body['message']?.toString() ?? 'Failed to load dashboard';
      }
    } catch (e) {
      dashboardError.value = e.toString();
    } finally {
      isLoadingDashboard.value = false;
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
    }
  }
}
