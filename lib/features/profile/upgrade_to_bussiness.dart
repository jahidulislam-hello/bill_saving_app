import 'package:vyzi/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



// ─────────────────────────────────────────────
// PUBLIC FUNCTION – call from anywhere
// ─────────────────────────────────────────────
void showUpgradeToBusinessSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (_) => const _UpgradeToBusinessSheet(),
  );
}

// ─────────────────────────────────────────────
// BOTTOM SHEET WIDGET
// ─────────────────────────────────────────────
class _UpgradeToBusinessSheet extends StatefulWidget {
  const _UpgradeToBusinessSheet();

  @override
  State<_UpgradeToBusinessSheet> createState() =>
      _UpgradeToBusinessSheetState();
}

class _UpgradeToBusinessSheetState extends State<_UpgradeToBusinessSheet> {
  // ── Tokens ──
  static const _purple = AppColors.primaryColor;
  static const _textDark = Color(0xFF1A1A2E);
  static const _textMid = Color(0xFF636E72);
  static const _textLight = Color(0xFFB2BEC3);
  static const _border = Color(0xFFE0E0E8);
  static const _inputBg = Colors.white;
  static const _darkBtn = Color(0xFF1A1A2E);
  static const _checkGreen = Color(0xFF27AE60);

  List<String> get _roles => [
    'upgrade.role_ceo'.tr,
    'upgrade.role_manager'.tr,
    'upgrade.role_finance'.tr,
    'upgrade.role_it'.tr,
    'upgrade.role_other'.tr,
  ];

  final _companyCtrl = TextEditingController();
  final _vatCtrl = TextEditingController();
  String? _selectedRole;
  bool _agreed = true;
  bool _dropdownOpen = false;

  final _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _companyCtrl.dispose();
    _vatCtrl.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown() {
    if (_dropdownOpen) {
      _removeOverlay();
      setState(() => _dropdownOpen = false);
    } else {
      _showDropdown();
      setState(() => _dropdownOpen = true);
    }
  }

  void _showDropdown() {
    final renderBox =
    _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeOverlay();
          setState(() => _dropdownOpen = false);
        },
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 4,
              width: size.width,
              child: _RoleDropdownMenu(
                items: _roles,
                selectedItem: _selectedRole,
                onSelect: (val) {
                  setState(() {
                    _selectedRole = val;
                    _dropdownOpen = false;
                  });
                  _removeOverlay();
                },
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 0),
      child: SafeArea(
        top: false,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Close button ──
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close,
                    size: 16, color: _textDark),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // ── Title ──
          Text(
            'upgrade.title'.tr,
            style: const TextStyle(
              color: _textDark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'upgrade.subtitle'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textMid,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // ── Company Name ──
          _inputField(
            label: 'upgrade.company_name'.tr,
            controller: _companyCtrl,
            hint: 'upgrade.company_hint'.tr,
          ),
          const SizedBox(height: 12),

          // ── Job Role Dropdown ──
          GestureDetector(
            key: _dropdownKey,
            onTap: _toggleDropdown,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: _inputBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _dropdownOpen ? _purple : _border,
                  width: 1.22,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'upgrade.job_role'.tr,
                        style: const TextStyle(
                            color: _textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'upgrade.optional'.tr,
                        style: const TextStyle(
                            color: _textLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        turns: _dropdownOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down,
                            color: _textDark, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedRole ?? 'upgrade.select_role'.tr,
                    style: TextStyle(
                      color: _selectedRole != null
                          ? _textDark
                          : _textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── VAT ──
          _inputField(
            label: 'upgrade.vat_label'.tr,
            controller: _vatCtrl,
            hint: 'upgrade.vat_hint'.tr,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),

          // ── Checkbox ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => setState(() => _agreed = !_agreed),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _agreed ? _checkGreen : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _agreed ? _checkGreen : _border,
                      width: 1.5,
                    ),
                  ),
                  child: _agreed
                      ? const Icon(Icons.check,
                      color: Colors.white, size: 14)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: _textMid, fontSize: 12, height: 1.5),
                    children: [
                      TextSpan(text: 'upgrade.terms_accept'.tr),
                      TextSpan(
                        text: 'upgrade.terms_link'.tr,
                        style: const TextStyle(
                            color: _purple,
                            fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                          text: 'upgrade.terms_suffix'.tr),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── CTA Button ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _agreed ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkBtn,
                disabledBackgroundColor: _darkBtn.withOpacity(0.5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                'upgrade.cta_button'.tr,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _inputBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border, width: 1.22),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
            color: _textDark, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: _textMid, fontSize: 12, fontWeight: FontWeight.w500),
          hintText: hint,
          hintStyle:
          const TextStyle(color: _textLight, fontSize: 14),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _purple, width: 1.5),
          ),
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Role Dropdown Overlay Menu
// ─────────────────────────────────────────────
class _RoleDropdownMenu extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onSelect;

  const _RoleDropdownMenu({
    required this.items,
    required this.selectedItem,
    required this.onSelect,
  });

  static const _purple = AppColors.primaryColor;
  static const _purpleBg = Color(0xFFEEEAFB);
  static const _textDark = Color(0xFF1A1A2E);
  static const _textMid = Color(0xFF636E72);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E8), width: 1.22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final isSelected = item == selectedItem;
            final isLast = i == items.length - 1;

            return Column(
              children: [
                GestureDetector(
                  onTap: () => onSelect(item),
                  child: Container(
                    width: double.infinity,
                    color: isSelected ? _purpleBg : Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isSelected ? _purple : _textDark,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        height: 1.22,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  const Divider(height: 1, color: Color(0xFFF0F0F5)),
              ],
            );
          }),
        ),
      ),
    );
  }
}
