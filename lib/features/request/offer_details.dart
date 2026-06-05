import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/request/complete_request/complete_request_screen.dart';
import 'package:vyzi/features/request/price_calculation_dialog.dart';
import 'package:vyzi/features/request/price_type_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OfferDetailsController extends ChangeNotifier {
  // Offer data
  final String supplierName = 'EnergyPlus';
  final String planName = 'Piano Residenziale Standard';
  final String badge = 'Miglior Valore';
  final String savingsAmount = '€306';
  final String savingsLabel = 'Risparmio Annuale';

  // Detail rows
  final List<OfferDetailRow> detailRows = [
    OfferDetailRow(
      label: 'Vincolo contrattuale',
      value: 'Nessun vincolo',
      linkText: null,
    ),
    OfferDetailRow(
      label: 'Tipo di prezzo',
      value: 'Prezzo indicizzato',
      linkText: "Cosa significa?",
      linkColor: AppColors.linkBlue,
    ),
    OfferDetailRow(
      label: 'Prezzo energia',
      value: 'PUN GME + 0.01 €/kWh',
      linkText: 'Come viene calcolato?',
      linkColor: AppColors.linkGreen,
    ),
    OfferDetailRow(
      label: 'Costi fissi materia energia',
      value: '14 €/mese',
      linkText: null,
    ),
    OfferDetailRow(
      label: 'Metodo di pagamento',
      value: 'Addebito diretto su conto corrente',
      linkText: null,
    ),
    OfferDetailRow(
      label: 'Durata del contratto',
      value: 'Durata indeterminata',
      linkText: null,
    ),
  ];

  // FAQ state
  final Set<int> expandedFAQ = {};

  void toggleFAQ(int index) {
    if (expandedFAQ.contains(index)) {
      expandedFAQ.remove(index);
    } else {
      expandedFAQ.add(index);
    }
    notifyListeners();
  }

  void selectOffer() {
    Get.to(() => const CompleteRequestScreen());
  }
}

class OfferDetailRow {
  final String label;
  final String value;
  final String? linkText;
  final Color linkColor;

  const OfferDetailRow({
    required this.label,
    required this.value,
    this.linkText,
    this.linkColor = AppColors.linkBlue,
  });
}

// ─────────────────────────────────────────────
// SCREEN 1 – OFFER DETAILS
// ─────────────────────────────────────────────
class OfferDetailsScreen extends StatefulWidget {
  const OfferDetailsScreen({super.key});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  final _ctrl = OfferDetailsController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Scrollable content
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              _supplierCard(),
              const SizedBox(height: 14),
              _savingsCard(),
              const SizedBox(height: 6),
              ..._ctrl.detailRows.map((row) => _detailRow(row)),
              const SizedBox(height: 10),
              _economicConditionsCard(),
              const SizedBox(height: 10),
              _easyBanner(),
              const SizedBox(height: 16),
            ],
          ),
          // Fixed bottom button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _bottomButton(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.chevron_left, color: AppColors.textDark, size: 28),
        ),
      ),
      title: const Text(
        'Dettagli Offerta',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OfferInfoScreen()),
          ),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 24,
            height: 24,

            child: const Icon(Icons.info_outline, color: AppColors.textDark, size: 18),
          ),
        ),
      ],
    );
  }

  // ── Supplier Card ──
  Widget _supplierCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1.2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A0A4C), Color(0xFF3A1F8C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_ctrl.supplierName,
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(_ctrl.planName,
                    style:
                    const TextStyle(color: AppColors.textMid, fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _ctrl.badge,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  // ── Savings Hero Card ──
  Widget _savingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B2FB9), Color(0xFF7B5FE9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text(
            'MASSIMO BENEFICIO POTENZIALE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _ctrl.savingsAmount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _ctrl.savingsLabel,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLinkTap(String text) {
    if (text == "Cosa significa?") {
      showDialog(
        context: context,
        builder: (_) => const PriceTypeSheet(),
      );
    } else if (text == 'Come viene calcolato?') {
      showDialog(
        context: context,
        builder: (_) => const PriceCalculationDialog(),
      );
    }
  }

  // ── Detail Row ──
  Widget _detailRow(OfferDetailRow row) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        row.label,
                        style: const TextStyle(
                          color: AppColors.textDarkest,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward,
                        size: 13, color: AppColors.textLight),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Value
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      row.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                    if (row.linkText != null) ...[
                      const SizedBox(height: 3),
                      GestureDetector(
                        onTap: () => _handleLinkTap(row.linkText!),
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          row.linkText!,
                          style: TextStyle(
                            color: row.linkColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.divider, height: 1.2),
      ],
    );
  }

  // ── Economic Conditions Card ──
  Widget _economicConditionsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFB396E1), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.description_outlined,
                color: AppColors.purple, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Condizioni economiche',
              style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight, size: 22),
        ],
      ),
    );
  }

  // ── Easy Saving Banner ──
  Widget _easyBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.star_outline, color: AppColors.textMid, size: 17),
          SizedBox(width: 8),
          Text(
            'Attivazione con Easy Saving',
            style: TextStyle(
                color: AppColors.textMid,
                fontSize: 13,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ── Fixed Bottom Button ──
  Widget _bottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
      decoration: BoxDecoration(
        color: AppColors.bg,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _ctrl.selectOffer,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: const Text(
            'Seleziona questa Offerta',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 2 – OFFER INFO
// ─────────────────────────────────────────────
class OfferInfoScreen extends StatefulWidget {
  const OfferInfoScreen({super.key});

  @override
  State<OfferInfoScreen> createState() => _OfferInfoScreenState();
}

class _OfferInfoScreenState extends State<OfferInfoScreen> {
  final Set<int> _expandedFAQ = {};

  static const _features = [
    (
    'Energia 100% rinnovabile',
    'Elettricità a zero emissioni di carbonio proveniente da parchi eolici e solari.'
    ),
    (
    'Nessun costo nascosto',
    'Fatturazione trasparente con zero oneri amministrativi imprevisti.'
    ),
    (
    'Garanzia prezzo fisso',
    'La tua tariffa energetica è bloccata per l\'intera durata del contratto.'
    ),
    (
    'Assistenza clienti 24/7',
    'Accesso a servizi esperti di concierge energetico in qualsiasi momento.'
    ),
  ];

  static const _faqs = [
    ('Come funziona il processo di cambio?',
    'Gestiamo l\'intero passaggio per tuo conto. Una volta firmato, ci coordiniamo con il tuo fornitore attuale e quello nuovo.'),
    ('Il mio servizio sarà interrotto?',
    'No. Il tuo servizio continua ininterrottamente durante tutto il processo di cambio.'),
    ('Cosa succede se sono ancora sotto contratto?',
    'Controlliamo eventuali costi di uscita e ti informiamo prima di procedere. Alcuni fornitori rinunciano ai costi in determinate situazioni.'),
    ('Quanto tempo ci vuole per ricevere il mio contratto?',
    'Il tuo contratto è solitamente pronto entro 24 ore dal completamento della tua richiesta.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          _whatsIncludedCard(),
          const SizedBox(height: 20),
          _aboutCard(),
          const SizedBox(height: 20),
          _faqSection(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.chevron_left, color: AppColors.textDark, size: 28),
        ),
      ),
      title: const Text(
        'Info Offerta',
        style: TextStyle(
            color: AppColors.textDark, fontSize: 17, fontWeight: FontWeight.w900),
      ),
    );
  }

  // ── What's Included ──
  Widget _whatsIncludedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cosa è Incluso",
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),

          ..._features.map((f) => _featureItem(f.$1, f.$2)),
        ],
      ),
    );
  }

  Widget _featureItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle,
                color: AppColors.green, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textMid,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── About EnergyPlus ──
  Widget _aboutCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Su EnergyPlus',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'EnergyPlus è un fornitore di energia affidabile impegnato a fornire un servizio eccellente e tariffe competitive. Si specializzano in soluzioni di energia rinnovabile e hanno una comprovata esperienza di soddisfazione del cliente.',
            style: TextStyle(
              color: AppColors.textMid,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }

  // ── FAQ Section ──
  Widget _faqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Domande Frequenti',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),

        ...List.generate(_faqs.length, (i) {
          final isExpanded = _expandedFAQ.contains(i);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedFAQ.remove(i);
                        } else {
                          _expandedFAQ.add(i);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _faqs[i].$1,
                              style: const TextStyle(
                                color: AppColors.textDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 24,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        16,
                      ),
                      child: Text(
                        _faqs[i].$2,
                        style: const TextStyle(
                          color: AppColors.textMid,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
