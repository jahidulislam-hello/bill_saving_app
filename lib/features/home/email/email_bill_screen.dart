import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'email_bill_controller.dart';

class EmailBillScreen extends StatelessWidget {
  EmailBillScreen({super.key});

  final controller = Get.put(EmailBillController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Invia la tua Bolletta via Email",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Top Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [

                     Image.asset(
                      'assets/images/send_mail.png',
                      fit: BoxFit.contain,


                    ),


                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Instruction Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Istruzioni",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Puoi inviarci la bolletta quando preferisci, allegandola all'indirizzo qui sotto.",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "Casella Email",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 8),

                  /// Email Box
                  Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.email.value,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.copyEmail,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Copia",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),

                  const SizedBox(height: 12),

                  /// Notes
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• "),
                      Expanded(
                        child: Text(
                          "Se invii foto della bolletta, assicurati di allegare le prime 3 pagine.",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• "),
                      Expanded(
                        child: Text(
                          "Puoi anche inviare eventuali nuove condizioni economiche o documenti utili per l'analisi",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.onEmailSent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B3FD8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Ho inviato l'email"),
              ),
            ),

            const SizedBox(height: 10),

            /// Back Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Torna Indietro"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}