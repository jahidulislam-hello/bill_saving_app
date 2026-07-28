import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// CONTROLLER CLASS
// ─────────────────────────────────────────────
class CompleteRequestController extends ChangeNotifier {
  // ── Business Information ──
  final firstNameCtrl = TextEditingController(text: 'mahmudul');
  final lastNameCtrl = TextEditingController(text: 'tamim');
  final companyCtrl = TextEditingController(text: 'Spark Tech Agency');
  final vatCtrl = TextEditingController(text: 'IT 00150030484');
  final emailCtrl = TextEditingController(text: 'mahmudul14286@gmail.com');
  final phoneCtrl = TextEditingController(text: '+88018926883582');

  // ── Supply Address ──
  final streetCtrl = TextEditingController(text: '123 Main Street');
  final cityCtrl = TextEditingController(text: 'New York');
  final zipCtrl = TextEditingController(text: '10001');

  // ── Supply Information ──
  final meterCtrl = TextEditingController(text: 'MTR-WXP3KBF9E');
  final supplyPointCtrl = TextEditingController(text: 'SP-M0T7Z5QZ4Z');

  // ── Payment ──
  String paymentType = 'Bank Transfer';
  String account = '****1234';
  String contactPreference = 'Email';

  // ── Edit states ──
  bool _editingBusiness = false;
  bool _editingAddress = false;

  bool get editingBusiness => _editingBusiness;
  bool get editingAddress => _editingAddress;

  void toggleBusinessEdit() {
    _editingBusiness = !_editingBusiness;
    notifyListeners();
  }

  void toggleAddressEdit() {
    _editingAddress = !_editingAddress;
    notifyListeners();
  }

  void saveBusiness() {
    _editingBusiness = false;
    notifyListeners();
  }

  void saveAddress() {
    _editingAddress = false;
    notifyListeners();
  }

  void activateOffer() {
    // handle activation
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    companyCtrl.dispose();
    vatCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    zipCtrl.dispose();
    meterCtrl.dispose();
    supplyPointCtrl.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────
class CompleteRequestScreen extends StatefulWidget {
  const CompleteRequestScreen({super.key});

  @override
  State<CompleteRequestScreen> createState() => _CompleteRequestScreenState();
}

class _CompleteRequestScreenState extends State<CompleteRequestScreen> {
  final _ctrl = CompleteRequestController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Colors ──
  static const _purple = Color(0xFF6C5CE7);
  static const _green = Color(0xFF00B894);
  static const _bg = Color(0xFFF7F8FC);
  static const _cardBg = Colors.white;
  static const _textDark = Color(0xFF2D3436);
  static const _textGrey = Color(0xFF636E72);
  static const _divider = Color(0xFFEEEEEE);
  static const _inputBorder = Color(0xFFDFE6E9);
  static const _greenBg = Color(0xFFE8F8F5);
  static const _greenBorder = Color(0xFF00B894);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _productCard(),
          const SizedBox(height: 14),
          _businessSection(),
          const SizedBox(height: 14),
          _addressSection(),
          const SizedBox(height: 14),
          _supplyInfoSection(),
          const SizedBox(height: 14),
          _paymentSection(),
          const SizedBox(height: 14),
          _contactSection(),
          const SizedBox(height: 14),
          _almostThereBanner(),
          const SizedBox(height: 20),
          _activateButton(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      leadingWidth: 40,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, color: _textDark, size: 28),
        ),
      ),
      title: const Text(
        'Complete Your Request',
        style: TextStyle(
          color: _textDark,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── Product Card ──
  Widget _productCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFF2D6A9F),
                  child: const Icon(Icons.bolt, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Business Energy pro',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: _textDark)),
                    Text('Commercial',
                        style: TextStyle(fontSize: 12, color: _textGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: _divider, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _priceStat('Monthly Payment', '\$89.99'),
              _priceStat('Annual Savings', '\$306', align: CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceStat(String label, String value, {CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: const TextStyle(color: _textGrey, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: _textDark, fontSize: 22, fontWeight: FontWeight.w800)),
      ],
    );
  }

  // ── Section Card ──
  Widget _sectionCard({required String title, required Widget child, VoidCallback? onEdit, bool isSave = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: _textDark)),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSave ? _green.withOpacity(0.1) : _purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(isSave ? Icons.check : Icons.edit_outlined,
                            size: 13, color: isSave ? _green : _purple),
                        const SizedBox(width: 4),
                        Text(isSave ? 'Save' : 'Edit',
                            style: TextStyle(
                                color: isSave ? _green : _purple,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  // ── Business Section ──
  Widget _businessSection() {
    final editing = _ctrl.editingBusiness;
    return _sectionCard(
      title: 'Business Information',
      isSave: editing,
      onEdit: editing ? _ctrl.saveBusiness : _ctrl.toggleBusinessEdit,
      child: Column(
        children: editing
            ? [
          _inputField('First Name', _ctrl.firstNameCtrl),
          _inputField('Last Name', _ctrl.lastNameCtrl),
          _inputField('Company Name', _ctrl.companyCtrl),
          _inputField('VAT No.', _ctrl.vatCtrl),
          _inputField('Email', _ctrl.emailCtrl, keyboardType: TextInputType.emailAddress),
          _inputField('Phone', _ctrl.phoneCtrl, keyboardType: TextInputType.phone),
        ]
            : [
          _infoRow('First Name', _ctrl.firstNameCtrl.text),
          _infoRow('Last Name', _ctrl.lastNameCtrl.text),
          _infoRow('Company Name', _ctrl.companyCtrl.text),
          _infoRow('VAT No.', _ctrl.vatCtrl.text),
          _infoRow('Email', _ctrl.emailCtrl.text),
          _infoRow('Phone', _ctrl.phoneCtrl.text, last: true),
        ],
      ),
    );
  }

  // ── Address Section ──
  Widget _addressSection() {
    final editing = _ctrl.editingAddress;
    return _sectionCard(
      title: 'Supply Address',
      isSave: editing,
      onEdit: editing ? _ctrl.saveAddress : _ctrl.toggleAddressEdit,
      child: Column(
        children: editing
            ? [
          _inputField('Street Address', _ctrl.streetCtrl),
          _inputField('City', _ctrl.cityCtrl),
          _inputField('ZIP Code', _ctrl.zipCtrl, keyboardType: TextInputType.number),
        ]
            : [
          _infoRow('Street Address', _ctrl.streetCtrl.text),
          _infoRow('City', _ctrl.cityCtrl.text),
          _infoRow('ZIP Code', _ctrl.zipCtrl.text, last: true),
        ],
      ),
    );
  }

  // ── Supply Info (read-only) ──
  Widget _supplyInfoSection() {
    return _sectionCard(
      title: 'Supply Information',
      child: Column(
        children: [
          _infoRow('Meter Number', _ctrl.meterCtrl.text),
          _infoRow('Supply Point', _ctrl.supplyPointCtrl.text, last: true),
        ],
      ),
    );
  }

  // ── Payment ──
  Widget _paymentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Method',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: _textDark)),
          const SizedBox(height: 14),
          const Text('Payment Type', style: TextStyle(color: _textGrey, fontSize: 12)),
          const SizedBox(height: 6),
          _dropdownField(_ctrl.paymentType),
          const SizedBox(height: 12),
          const Text('Account', style: TextStyle(color: _textGrey, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              border: Border.all(color: _inputBorder),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(_ctrl.account,
                style: const TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: _inputBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: _textGrey),
          style: const TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500),
          items: ['Bank Transfer', 'Credit Card', 'Direct Debit']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _ctrl.paymentType = v);
          },
        ),
      ),
    );
  }

  // ── Contact ──
  Widget _contactSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Contact Preference',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: _textDark)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: _inputBorder),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _ctrl.contactPreference,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: _textGrey),
                style: const TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500),
                items: ['Email', 'Phone', 'SMS']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _ctrl.contactPreference = v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Almost There Banner ──
  Widget _almostThereBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _greenBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _greenBorder.withOpacity(0.4)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: _green, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Almost there!',
                    style: TextStyle(color: _green, fontWeight: FontWeight.w700, fontSize: 13)),
                SizedBox(height: 2),
                Text(
                  'Once you activate, we\'ll send your contract within 24 hours for signing.',
                  style: TextStyle(color: _green, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Activate Button ──
  Widget _activateButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _ctrl.activateOffer,
        style: ElevatedButton.styleFrom(
          backgroundColor: _purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: const Text('Activate Offer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }

  // ── Info Row (view mode) ──
  Widget _infoRow(String label, String value, {bool last = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: _textGrey, fontSize: 13)),
              Flexible(
                child: Text(value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        color: _textDark, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        if (!last) const Divider(color: _divider, height: 1),
      ],
    );
  }

  // ── Input Field (edit mode) ──
  Widget _inputField(String label, TextEditingController ctrl,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _textGrey, fontSize: 12)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            style: const TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _purple, width: 1.5),
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
            ),
          ),
        ],
      ),
    );
  }
}
