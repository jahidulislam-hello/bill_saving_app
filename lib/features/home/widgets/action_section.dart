
import 'package:billo/features/home/widgets/action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionSection extends StatelessWidget {
  ActionSection({super.key});

  final List<Map<String, dynamic>> actions = [
    {
      "title": "Cambia Fornitore",
      "subtitle": "Controlla il mercato e scopri quanto puoi risparmiare!",
      "icon": Icons.swap_horiz,
      "color": Colors.green,
    },
    {
      "title": "Trasferimento di Proprietà",
      "subtitle": "2-in-1: Trasferisci la proprietà e cambia fornitore!",
      "icon": Icons.person_outline,
      "color": Colors.orange,
    },
    {
      "title": "Attiva Utenza",
      "subtitle": "Completa la tua richiesta e attiva il servizio ora!",
      "icon": Icons.bolt,
      "color": Colors.green,
    },
    {
      "title": "Controllo Fattura",
      "subtitle": "Controlla se le tue fatture sono corrette e puoi risparmiare!",
      "icon": Icons.receipt_long,
      "color": Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Cosa vuoi fare oggi?",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: 16.h),

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
            );
          },
        ),
      ],
    );
  }
}