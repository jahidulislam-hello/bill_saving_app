/// HOME CONTROLLER

import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool hasData = false.obs;

  /// summary data
  RxString savingAmount = '€128,50'.obs;
  RxInt activeRequest = 0.obs;

  /// utility list
  RxList<Map<String, dynamic>> utilityList = <Map<String, dynamic>>[].obs;

  void startSavingFlow() {

    hasData.value = true;

    utilityList.assignAll([
      {
        "title": "EnergyPlus",
        "subtitle": "gas",
        "price": "\$89.99",
      },
      {
        "title": "EnergyPlus",
        "subtitle": "gas",
        "price": "\$89.99",
      },
    ]);
  }
}
