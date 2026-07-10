import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_styles.dart';
import 'package:vyzi/core/widgets/primary_button.dart';
import 'package:vyzi/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarmupController extends GetxController {
  var currentIndex = 0.obs;

  void next() {
    if (currentIndex.value < 2) {
      currentIndex.value++;
    }
  }
}

class WarmupOnboarding extends StatelessWidget {
  WarmupOnboarding({super.key});

  final controller = Get.put(WarmupController());

  final List<Map<String, String>> data = [
    {
      "image": AppAssets.onboarding1,
      "title": "Carica le tue bollette in secondi",
      "desc":
      "Basta scattare una foto o caricare un PDF della tua bolletta attuale. La nostra IA la analizzerà e troverà le migliori offerte in pochi minuti.",
    },
    {
      "image": AppAssets.onboarding2,
      "title": "Carica le tue bollette in secondi",
      "desc":
      "Basta scattare una foto o caricare un PDF della tua bolletta attuale. La nostra IA la analizzerà e troverà le migliori offerte in pochi minuti.",
    },
    {
      "image": AppAssets.onboarding3,
      "title": "Risparmia denaro e rimani aggiornato",
      "desc":
      "Ricevi notifiche istantanee su offerte migliori e monitora i tuoi risparmi. Monitoriamo il mercato così non devi farlo tu.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final item = data[controller.currentIndex.value];

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // TOP CURVED BACKGROUND + IMAGE
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Shifted circular background
                        Positioned(
                          top: -128,
                          left: -81,
                          child: Container(
                            width: 555,
                            height: 551,
                            decoration: const BoxDecoration(
                              color: Color(0xFFCCB8EB),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // PHONE IMAGE
                        Positioned(
                          bottom: -208,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Image.asset(
                              item["image"]!,
                              height: 580,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 220),

                  // TEXT SECTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          item["title"]!,
                          textAlign: TextAlign.center,
                          style: AppStyles.h3,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item["desc"]!,
                          textAlign: TextAlign.center,
                          style: AppStyles.body2.copyWith(color: Colors.black, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // BOTTOM INDICATOR + BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    child: controller.currentIndex.value == 2
                        ? PrimaryButton(
                      title: 'onboarding.next'.tr,
                      onPress: () {
                        Get.offNamed(AppRoutes.onboardScreen);
                      },
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SKIP BUTTON
                        TextButton(
                          onPressed: () {
                            Get.offNamed(AppRoutes.onboardScreen);
                          },
                          child: Text(
                            'onboarding.skip'.tr,
                            style: AppStyles.body1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // MIDDLE DOT INDICATORS
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              height: 6,
                              width: controller.currentIndex.value == index ? 20 : 6,
                              decoration: BoxDecoration(
                                color: controller.currentIndex.value == index
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),

                        // NEXT BUTTON
                        GestureDetector(
                          onTap: controller.next,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
