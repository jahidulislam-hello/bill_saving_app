
import 'package:flutter/material.dart';
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
  static const textMid = Color(0xFF636E72);
  static const textLight = Color(0xFFB2BEC3);
  static const purple = Color(0xFF6C5CE7);
  static const purpleBg = Color(0xFFEEEAFB);
  static const green = Color(0xFF00C896);
  static const orange = Color(0xFFE67E22);
  static const orangeBg = Color(0xFFFEF0E6);
  static const teal = Color(0xFF00B4D8);
  static const tealBg = Color(0xFFE0F7FA);
  static const blue = Color(0xFF2980B9);
  static const cardBg = Colors.white;
  static const inputBg = Color(0xFFF4F5F7);
  static const darkBtn = Color(0xFF1A1A2E);
  static const segmentActive = Color(0xFF6C5CE7);
  static const segmentActiveBg = Color(0xFFEEEAFB);
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
      title: 'Come iniziare',
      subtitle: 'Scopri come utilizzare l\'app passo dopo passo',
      screen: const FaqQuestion(),
    ),
    _SupportItem(
      icon: Icons.settings,
      iconColor: _T.orange,
      iconBg: _T.orangeBg,
      title: 'Utilità di Configurazione',
      subtitle: 'Gestisci l\'app e configura le tue utilità',
      screen: const FaqUtiliesScreen(),
    ),
    _SupportItem(
      icon: Icons.receipt_long,
      iconColor: _T.orange,
      iconBg: _T.orangeBg,
      title: 'Fatture',
      subtitle: 'Carica e controlla le tue fatture',
      screen: const FaqBillScreen(),
    ),
    _SupportItem(
      icon: Icons.headset_mic_outlined,
      iconColor: _T.teal,
      iconBg: _T.tealBg,
      title: 'Richiedi assistenza',
      subtitle: 'Apri un ticket e ricevi aiuto',
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
          const Text(
            'Ciao, come possiamo aiutarti?',
            style: TextStyle(
              color: _T.textDark,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Cerca le nostre guide o contatta il supporto tecnico.',
            style: TextStyle(
              color: _T.textMid,
              fontSize: 13,
              height: 1.5,
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
      title: const Text(
        'Supporto',
        style: TextStyle(
            color: _T.textDark, fontSize: 17, fontWeight: FontWeight.w700),
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
                const Text(
                  'ARTICOLO IN EVIDENZA',
                  style: TextStyle(
                    color: _T.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '5 consigli per ridurre la tua fattura del 20%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
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
  final String title;
  final String subtitle;
  final Widget screen;

  const _SupportItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
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
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1.22),
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
                  Text(item.title,
                      style: const TextStyle(
                          color: _T.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(item.subtitle,
                      style: const TextStyle(
                          color: _T.textMid, fontSize: 12, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
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

  static const _tabs = ['Supporto Tecnico', 'Fatturazione e Pagamenti'];
  static const _topics = [
    'Domanda Fatturazione',
    'Problema Tecnico',
    'Processo di Passaggio',
    'Domanda Contatto',
    'Gestione Account',
    'Altro',
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
                items: _topics,
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
          const Text(
            'Hai bisogno di aiuto? Seleziona un argomento e descrivi la tua richiesta. Il nostro team specializzato risponderà il prima possibile.',
            style: TextStyle(
              color: _T.textMid,
              fontSize: 13,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),

          // ── Tab Switcher ──
          _tabSwitcher(),
          const SizedBox(height: 22),

          // ── Topic Dropdown ──
          const Text('Argomento',
              style: TextStyle(
                  color: _T.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
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
                border: _dropdownOpen
                    ? Border.all(color: _T.purple, width: 1.5)
                    : Border.all(color: Colors.transparent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTopic ?? 'Richiesta Fatturazione',
                    style: TextStyle(
                      color: _selectedTopic != null
                          ? _T.textDark
                          : _T.textMid,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _dropdownOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down,
                        color: _T.textLight, size: 22),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── Message ──
          const Text('Messaggio',
              style: TextStyle(
                  color: _T.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _messageCtrl,
            maxLines: 5,
            style: const TextStyle(
                color: _T.textDark, fontSize: 14, height: 1.5),
            decoration: InputDecoration(
              hintText: 'Descrivi il tuo problema o domanda...',
              hintStyle:
              const TextStyle(color: _T.textLight, fontSize: 13),
              filled: true,
              fillColor: _T.inputBg,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                const BorderSide(color: _T.purple, width: 1.5),
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
                backgroundColor: _T.darkBtn,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Invia Richiesta',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 28),

          // ── Divider ──
          const Divider(color: Color(0xFFEEEEEE), height: 1),
          const SizedBox(height: 24),

          // ── Other Ways to Contact ──
          const Text('Altri modi per contattarci',
              style: TextStyle(
                  color: _T.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          _contactRow('Telefono', '1-800-UTILITY', _T.blue),
          const SizedBox(height: 14),
          _contactRow('Email', 'support@utility.com', _T.blue),
          const SizedBox(height: 14),
          _contactRow('Orari', 'Lun-Ven, 09:00 – 18:00', _T.textDark),
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
          child: Icon(Icons.chevron_left, color: _T.textDark, size: 28),
        ),
      ),
      title: const Text('Supporto',
          style: TextStyle(
              color: _T.textDark,
              fontSize: 17,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget _tabSwitcher() {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _T.inputBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
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
                  _tabs[i],
                  style: TextStyle(
                    color:
                    isActive ? _T.segmentActive : _T.textMid,
                    fontSize: 13,
                    fontWeight: isActive
                        ? FontWeight.w700
                        : FontWeight.w500,
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
            style: const TextStyle(color: _T.textMid, fontSize: 13)),
        Text(value,
            style: TextStyle(
                color: valueColor,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
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
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1.22),
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
                      item,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? _T.purple : _T.textDark,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        height: 1.22,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0)),
              ],
            );
          }),
        ),
      ),
    );
  }
}
