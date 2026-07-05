/// HOME CONTROLLER

import 'package:get/get.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/features/home/model/meter_model.dart';

class HomeController extends GetxController {
  final ApiService _api = ApiService();

  RxBool hasData = false.obs;
  RxBool isLoadingMeters = false.obs;
  RxString metersError = ''.obs;

  /// summary data
  RxString savingAmount = '€128,50'.obs;
  RxInt activeRequest = 0.obs;

  /// Full meter objects — all data from the API is stored here
  RxList<MeterModel> meterList = <MeterModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> startSavingFlow() async {
    hasData.value = true;

    isLoadingMeters.value = true;
    metersError.value = '';

    try {
      final response = await _api.get(
        ApiConstants.activeOffers,
      );

      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final rawList = body['data'] as List<dynamic>;
        final meters = rawList
            .map((e) => MeterModel.fromJson(e as Map<String, dynamic>))
            .toList();
        meterList.assignAll(meters);
      } else {
        metersError.value = body['message']?.toString() ?? 'Failed to load meters';
      }
    } catch (e) {
      metersError.value = e.toString();
    } finally {
      isLoadingMeters.value = false;
    }
  }
}
