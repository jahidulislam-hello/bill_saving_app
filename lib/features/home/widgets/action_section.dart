import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Update this import path to match your project structure
import 'action_card.dart';

class ActionSection extends StatelessWidget {
  ActionSection({super.key});

  final List<Map<String, dynamic>> actions = [
    {
      "title": "Cambia Fornitore",
      "subtitle": "Controlla il mercato e scopri quanto puoi risparmiare!",
      "icon": Icons.swap_horiz,
      "color": const Color(0xFF27AE60), // green
      "isHighlighted": false,
      "showBadge": false,
    },
    {
      "title": "Trasferimento di Proprietà",
      "subtitle": "2-in-1: Trasferisci la proprietà e cambia fornitore!",
      "icon": Icons.people_alt_outlined,
      "color": const Color(0xFFE67E22), // orange
      "isHighlighted": false,
      "showBadge": false,
    },
    {
      "title": "Attiva Utenza",
      "subtitle": "Completa la tua richiesta e attiva il servizio ora!",
      "icon": Icons.bolt,
      "color": const Color(0xFF27AE60), // border accent color
      "isHighlighted": true,  // ← dark icon bg
      "showBadge": true,      // ← "Nuovo" badge
      "badgeText": "Nuovo",
    },
    {
      "title": "Controllo Fattura",
      "subtitle": "Controlla se le tue fatture sono corrette e trova risparmi!",
      "icon": Icons.manage_search_rounded,
      "color": const Color(0xFF2980B9), // blue
      "isHighlighted": false,
      "showBadge": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(18.r),
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

          SizedBox(height: 14.h),

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
                icon: item['icon'],
                color: item['color'],
                isHighlighted: item['isHighlighted'] ?? false,
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