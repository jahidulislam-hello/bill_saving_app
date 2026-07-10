import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vyzi/features/profile/settings/faq_question.dart';
import 'package:vyzi/features/profile/settings/fq.dart';
import 'package:vyzi/features/profile/settings/fq_bill.dart';
import 'package:vyzi/features/profile/settings/fq_utilities.dart';


// ─────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────
class _T {
  static const bg = Colors.white;
  static const textDark = Color(0xFF1A1A2E);
  static const textMid = Colors.black;
  static const purple = Color(0xFF5A1ABE);
  static const purpleBg = Color(0xFFEEEAFB);
  static const green = Color(0xFF00C896);
  static const orange = Color(0xFFE67E22);
  static const orangeBg = Color(0xFFFEF0E6);
  static const teal = Color(0xFF00B4D8);
  static const tealBg = Color(0xFFE0F7FA);
  static const cardBg = Colors.white;
  static const inputBg = Color(0xFFF3F3F5);
  static const darkBtn = Color(0xFF155DFC);
  static const segmentActiveBg = Color(0xFF5218AD);
}

// ─────────────────────────────────────────────
// SCREEN 1 – SUPPORTO (Italian)
// ─────────────────────────────────────────────
class SupportoScreen extends StatelessWidget {
  const SupportoScreen({super.key});

  static final _items = [
    _SupportItem(
      icon: Icons.play_circle_filled,
      iconColor: _T.purple,
      iconBg: _T.purpleBg,
      titleKey: 'support.getting_started',
      subtitleKey: 'support.getting_started_desc',
      screen: const FaqScreen(),
    ),
    _SupportItem(
      icon: Icons.settings,
      iconColor: _T.orange,
      iconBg: _T.orangeBg,
      titleKey: 'support.utilities_setup',
      subtitleKey: 'support.utilities_setup_desc',
      screen: const FaqUtiliesScreen(),
    ),
    _SupportItem(
      icon: Icons.receipt_long,
      iconColor: _T.orange,
      iconBg: _T.orangeBg,
      titleKey: 'support.bills',
      subtitleKey: 'support.bills_desc',
      screen: const FaqBillScreen(),
    ),
    _SupportItem(
      icon: Icons.headset_mic_outlined,
      iconColor: _T.teal,
      iconBg: _T.tealBg,
      titleKey: 'support.contact_us',
      subtitleKey: 'support.contact_us_desc',
      screen: const SupportFormScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _T.bg,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        children: [
          const SizedBox(height: 12),
          Text(
            'support.greeting'.tr,
            style: const TextStyle(
              color: _T.textDark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'support.subtitle'.tr,
            style: const TextStyle(
              color: _T.textMid,
              fontSize: 13,
              height: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ..._items.map((item) => _SupportTile(item: item)),
          const SizedBox(height: 20),
          _featuredCard(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _T.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, color: _T.textDark, size: 28),
        ),
      ),
      title: Text(
        'support.title'.tr,
        style: const TextStyle(
            color: _T.textDark, fontSize: 17, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _featuredCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          // Dark overlay background
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1.22),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=600',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0x99000000),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Content
          Positioned(
            left: 18,
            bottom: 18,
            right: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'support.featured_label'.tr,
                  style: const TextStyle(
                    color: _T.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'support.featured_title'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String titleKey;
  final String subtitleKey;
  final Widget screen;

  const _SupportItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.titleKey,
    required this.subtitleKey,
    required this.screen,
  });
}

class _SupportTile extends StatelessWidget {
  final _SupportItem item;
  const _SupportTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => item.screen)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _T.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.22),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.titleKey.tr,
                      style: const TextStyle(
                          color: _T.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(item.subtitleKey.tr,
                      style: const TextStyle(
                          color: _T.textMid, fontSize: 12, height: 1.4, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.black, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 2 – SUPPORT FORM (English)
// ─────────────────────────────────────────────
class SupportFormScreen extends StatefulWidget {
  const SupportFormScreen({super.key});

  @override
  State<SupportFormScreen> createState() => _SupportFormScreenState();
}

class _SupportFormScreenState extends State<SupportFormScreen> {
  int _selectedTab = 0; // 0 = Technical Support, 1 = Billing and Payments
  String? _selectedTopic;
  final _messageCtrl = TextEditingController();
  bool _dropdownOpen = false;
  final _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  static const _tabKeys = ['support.form.tab.technical', 'support.form.tab.billing'];
  static const _topicKeys = [
    'support.form.topic.billing_question',
    'support.form.topic.technical_issue',
    'support.form.topic.switching_process',
    'support.form.topic.contact_question',
    'support.form.topic.account_management',
    'support.form.topic.other',
  ];

  @override
  void dispose() {
    _messageCtrl.dispose();
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
              child: _TopicDropdownMenu(
                items: _topicKeys,
                selectedItem: _selectedTopic,
                onSelect: (val) {
                  setState(() {
                    _selectedTopic = val;
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
    return Scaffold(
      backgroundColor: _T.bg,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
        children: [
          Text(
            'support.form.intro'.tr,
            style: const TextStyle(
              color: _T.textMid,
              fontSize: 13,
              height: 1.55,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),

          // ── Tab Switcher ──
          _tabSwitcher(),
          const SizedBox(height: 22),

          // ── Topic Dropdown ──
          Text('support.form.topic_label'.tr,
              style: const TextStyle(
                  color: _T.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          GestureDetector(
            key: _dropdownKey,
            onTap: _toggleDropdown,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: _T.inputBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF3F3F5), width: 1.22),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTopic?.tr ?? 'support.default_topic'.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _dropdownOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.black, size: 22),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── Message ──
          Text('support.form.message_label'.tr,
              style: const TextStyle(
                  color: _T.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          TextField(
            controller: _messageCtrl,
            maxLines: 5,
            style: const TextStyle(
                color: _T.cardBg, fontSize: 14, height: 1.5, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: 'support.form.message_hint'.tr,
              hintStyle:
              const TextStyle(color: Colors.black45, fontSize: 13),
              filled: true,
              fillColor: _T.inputBg,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFF3F3F5), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                const BorderSide(color: _T.inputBg, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // ── Submit Button ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _T.textMid,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('support.form.submit'.tr,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(height: 28),

          // ── Divider ──
          const Divider(color: Color(0xFFE5E7EB), height: 1),
          const SizedBox(height: 24),

          // ── Other Ways to Contact ──
          Text('support.other_contact_methods'.tr,
              style: const TextStyle(
                  color: _T.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          _contactRow('support.contact.phone_label'.tr, '1-800-UTILITY', _T.darkBtn),
          const SizedBox(height: 14),
          _contactRow('support.contact.email_label'.tr, 'support@utility.com', _T.darkBtn),
          const SizedBox(height: 14),
          _contactRow('support.contact.hours_label'.tr, 'support.contact.hours_value'.tr, _T.textDark),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _T.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.arrow_back_rounded, color: _T.textDark, size: 28),
        ),
      ),
      title: Text('support.title'.tr,
          style: const TextStyle(
              color: _T.textDark,
              fontSize: 17,
              fontWeight: FontWeight.w900)),
    );
  }

  Widget _tabSwitcher() {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFFEFE8F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9066D3), width: 1.22),
      ),
      child: Row(
        children: List.generate(_tabKeys.length, (i) {
          final isActive = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color:
                  isActive ? _T.segmentActiveBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(
                  _tabKeys[i].tr,
                  style: TextStyle(
                    color:
                    isActive ? _T.cardBg : Colors.black,
                    fontSize: 13,
                    fontWeight: isActive
                        ? FontWeight.w900
                        : FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _contactRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w700)),
        Text(value,
            style: TextStyle(
                color: valueColor,
                fontSize: 13,
                fontWeight: FontWeight.w900)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Custom Topic Dropdown Overlay
// ─────────────────────────────────────────────
class _TopicDropdownMenu extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onSelect;

  const _TopicDropdownMenu({
    required this.items,
    required this.selectedItem,
    required this.onSelect,
  });

  // Alternating bg colors matching image 3
  static const _rowColors = [
    Color(0xFFB2EEF8), // light cyan  – Billing Question
    Colors.white,      // white       – Technical Issue
    Color(0xFFFEF0E6), // light peach – Switching Process
    Colors.white,      // white       – Contact Question
    Color(0xFFFEF0E6), // light peach – Account Management
    Colors.white,      // white       – Other
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF3F3F5), width: 1.22),
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
            final rowBg = isSelected
                ? _T.purpleBg
                : (_rowColors.length > i ? _rowColors[i] : Colors.white);

            return Column(
              children: [
                GestureDetector(
                  onTap: () => onSelect(item),
                  child: Container(
                    width: double.infinity,
                    color: rowBg,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 15),
                    child: Text(
                      item.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? _T.purple : Colors.black,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w900
                            : FontWeight.w700,
                        height: 1.22,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF3F3F5)),
              ],
            );
          }),
        ),
      ),
    );
  }
}
