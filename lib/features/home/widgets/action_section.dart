import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vyzi/core/utils/app_assets.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/core/utils/app_styles.dart';

import 'action_card.dart';

class ActionSection extends StatelessWidget {
  ActionSection({super.key});

  final List<Map<String, dynamic>> actions = [
    {
      "title": "Cambia Fornitore",
      "subtitle": "Controlla il mercato e scopri quanto puoi risparmiare!",
      "image": AppAssets.actionChange,
      "showBadge": false,
    },
    {
      "title": "Trasferimento di Proprietà",
      "subtitle": "2-in-1: Trasferisci la proprietà e cambia fornitore!",
      "image": AppAssets.actionTransfer,
      "showBadge": false,
    },
    {
      "title": "Attiva Utenza",
      "subtitle": "Completa la tua richiesta e attiva il servizio ora!",
      "image": AppAssets.actionActivate,
      "showBadge": true,
      "badgeText": "Nuovo",
    },
    {
      "title": "Controllo Fattura",
      "subtitle": "Controlla se le tue fatture sono corrette e trova risparmi!",
      "image": AppAssets.actionControl,
      "showBadge": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFF5A1ABE), width: 1.22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cosa vuoi fare oggi?",
            style: AppStyles.h3.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
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
