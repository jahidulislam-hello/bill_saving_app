import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vyzi/core/utils/app_images.dart';

import 'action_card.dart';

class ActionSection extends StatelessWidget {
  ActionSection({super.key});

  final List<Map<String, dynamic>> actions = [
    {
      "title": "Cambia Fornitore",
      "subtitle": "Controlla il mercato e scopri quanto puoi risparmiare!",
      "image": AppImages.h_1,
      "showBadge": false,
    },
    {
      "title": "Trasferimento di Proprietà",
      "subtitle": "2-in-1: Trasferisci la proprietà e cambia fornitore!",
      "image": AppImages.h_2,
      "showBadge": false,
    },
    {
      "title": "Attiva Utenza",
      "subtitle": "Completa la tua richiesta e attiva il servizio ora!",
      "image": AppImages.h_3,
      "showBadge": true,
      "badgeText": "Nuovo",
    },
    {
      "title": "Controllo Fattura",
      "subtitle": "Controlla se le tue fatture sono corrette e trova risparmi!",
      "image": AppImages.h_4,
      "showBadge": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cosa vuoi fare oggi?",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
            ),
          ),

          SizedBox(height: 1.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            separatorBuilder: (_, __) => SizedBox(height: 14.h),
            itemBuilder: (_, index) {
              final item = actions[index];
              return ActionCard(
                title: item['title'],
                subtitle: item['subtitle'],
                image: item['image'],
                showBadge: item['showBadge'] ?? false,
                badgeText: item['badgeText'],
                onTap: () {
                  debugPrint("Action tapped: ${item['title']}");
                },
              );
            },
          ),
        ],
      ),
    );
  }
}