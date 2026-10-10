import 'package:get/get.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/core/services/storage_service.dart';
import 'package:vyzi/features/support/models/faq_model.dart';

class UtilityDetailsController extends GetxController {
  final ApiService _api = ApiService();

  RxBool isFaqLoading = false.obs;
  RxString faqError = ''.obs;
  RxList<FaqModel> faqList = <FaqModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    isFaqLoading.value = true;
    faqError.value = '';

    try {
      final queryParams = <String, dynamic>{
        'category': 'Cambio Fornitore',
      };

      final storage = Get.find<StorageService>();
      final lang =
          storage.getString(StorageKeys.selectedLanguage) ?? 'it';
      queryParams['locale'] = lang;

      final response = await _api.get(
        ApiConstants.faqs,
        queryParameters: queryParams,
      );
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        final data = body['data'] as List<dynamic>;
        faqList.assignAll(
          data
              .map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      } else {
        faqError.value =
            body['message']?.toString() ?? 'Failed to load FAQs';
      }
    } catch (e) {
      faqError.value = e.toString();
    } finally {
      isFaqLoading.value = false;
    }
  }
}
