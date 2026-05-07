import 'package:flutter/material.dart';

class SelectUtilityScreen extends StatefulWidget {
  const SelectUtilityScreen({super.key});

  @override
  State<SelectUtilityScreen> createState() => _SelectUtilityScreenState();
}

class _SelectUtilityScreenState extends State<SelectUtilityScreen> {
  String? selectedType; // "luce" or "gas"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// Back + Title
              Row(
                children: const [
                  Icon(Icons.arrow_back_ios, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Select Utility",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Title
              const Text(
                "Which users do you want to\noptimize?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Select the service for which you want to find the best deals",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              /// Cards
              Row(
                children: [
                  Expanded(
                    child: _buildCard(
                      title: "LUCE",
                      subtitle: "Optimize your power bill",
                      asset: "assets/icons/luce.png",
                      type: "luce",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCard(
                      title: "GAS",
                      subtitle: "Reduce your gas expenses",
                      asset: "assets/icons/gas.png",
                      type: "gas",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Tip Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEBFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("💡"),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Tip: You can upload more bills later to compare all your utilities.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: selectedType == null ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedType == null
                        ? Colors.grey.shade400
                        : const Color(0xFF5B4BFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String asset,
    required String type,
  }) {
    final bool isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF5B4BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.grey.shade300,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Stack(
          children: [
            /// Radio circle
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : Colors.grey.shade400,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: Colors.deepPurple)
                    : null,
              ),
            ),

            /// Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  asset,
                  height: 26,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected
                        ? Colors.white70
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}