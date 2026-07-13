import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;
import 'package:pdfx/pdfx.dart' as pdfx;

// ─── Supplier Catalog ───────────────────────────────────

class SupplierCatalogEntry {
  final String canonicalName;
  final List<String> vatNumbers;
  final List<String> domains;
  final List<String> legalNames;
  final List<String> aliases;

  const SupplierCatalogEntry({
    required this.canonicalName,
    this.vatNumbers = const [],
    this.domains = const [],
    this.legalNames = const [],
    this.aliases = const [],
  });
}

class SupplierIdentification {
  final String? supplier;
  final String confidence; // "high" | "medium" | "low" | "unrecognized" | "ambiguous"
  final int score;
  final String method; // "vat" | "domain" | "legal" | "alias" | "footer_anchor" | "none"
  final String? rawName;
  final List<String> vatFound;

  const SupplierIdentification({
    this.supplier,
    this.confidence = 'none',
    this.score = 0,
    this.method = 'none',
    this.rawName,
    this.vatFound = const [],
  });
}

// ─── Result Model ───────────────────────────────────────

class BillOcrResult {
  final String? supplierName;
  final String? supplierConfidence; // "high" | "medium" | "low" | "unrecognized" | "ambiguous"
  final String? podNumber;
  final String? pdrNumber;
  final double? totalAmount;
  final double? consumptionKwh;
  final double? consumptionSmc;
  final double? costPerUnit;
  final double? fixedCharges;
  final double? taxes;
  final String? billingPeriodStart; // YYYY-MM-DD
  final String? billingPeriodEnd; // YYYY-MM-DD
  final String? supplyAddress;
  final String? codiceFiscale;
  final String? partitaIva;
  final String? contractNumber;
  final String? meterNumber;
  final String? customerName;
  final String rawText;

  const BillOcrResult({
    this.supplierName,
    this.supplierConfidence,
    this.podNumber,
    this.pdrNumber,
    this.totalAmount,
    this.consumptionKwh,
    this.consumptionSmc,
    this.costPerUnit,
    this.fixedCharges,
    this.taxes,
    this.billingPeriodStart,
    this.billingPeriodEnd,
    this.supplyAddress,
    this.codiceFiscale,
    this.partitaIva,
    this.contractNumber,
    this.meterNumber,
    this.customerName,
    this.rawText = '',
  });

  bool get hasAnyData =>
      supplierName != null ||
      podNumber != null ||
      pdrNumber != null ||
      totalAmount != null ||
      consumptionKwh != null ||
      consumptionSmc != null ||
      costPerUnit != null ||
      fixedCharges != null ||
      taxes != null ||
      billingPeriodStart != null ||
      billingPeriodEnd != null;

  /// Returns list of missing required field labels for the given bill type.
  List<String> getMissingFields(String billType) {
    final missing = <String>[];
    final isElectricity = billType == 'electricity';

    if (isElectricity && podNumber == null) missing.add('POD');
    if (!isElectricity && pdrNumber == null) missing.add('PDR');
    if (totalAmount == null) missing.add('upload_bill.field_total');
    if (isElectricity && consumptionKwh == null) missing.add('upload_bill.field_consumption');
    if (!isElectricity && consumptionSmc == null) missing.add('upload_bill.field_consumption');
    // costPerUnit is NOT required — can be calculated from (totalAmount - fixedCharges - taxes) / consumption
    if (fixedCharges == null) missing.add('upload_bill.field_fixed_charges');
    if (taxes == null) missing.add('upload_bill.field_taxes');
    if (billingPeriodStart == null || billingPeriodEnd == null) missing.add('upload_bill.field_period');
    if (supplyAddress == null) missing.add('upload_bill.field_address');
    if (codiceFiscale == null && partitaIva == null) missing.add('upload_bill.field_tax_code');

    return missing;
  }

  bool isComplete(String billType) => getMissingFields(billType).isEmpty;
}

// ─── Service ────────────────────────────────────────────

class BillOcrService {
  static const List<String> _imageExtensions = ['jpg', 'jpeg', 'png'];
  static const List<String> _pdfExtensions = ['pdf'];

  // ─── Supplier Catalog (Italian Energy Suppliers) ────────
  // VATs are the supplier's own P.IVA (public, Chamber of Commerce).
  // Customer P.IVA will NOT be in this map → won't false-match.

  static const List<SupplierCatalogEntry> _catalog = [
    SupplierCatalogEntry(
      canonicalName: 'Enel Energia',
      vatNumbers: ['06655971007'],
      domains: ['enel.com', 'enelenergia.com'],
      legalNames: ['Enel Energia S.p.A.'],
      aliases: ['Enel', 'ENEL', 'Enel Energia'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Servizio Elettrico Nazionale',
      vatNumbers: ['09633951000'],
      domains: ['servizioelettriconazionale.it'],
      legalNames: ['Servizio Elettrico Nazionale S.p.A.'],
      aliases: ['SEN', 'Servizio Elettrico'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Eni Plenitude',
      vatNumbers: ['15844561009', '00905811006'],
      domains: ['eniplenitude.com', 'eni.com', 'plenitude.com'],
      legalNames: ['Eni Plenitude S.p.A. S.B.', 'Eni Plenitude S.p.A.'],
      aliases: ['Eni', 'Plenitude', 'Eni Plenitude'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'A2A Energia',
      vatNumbers: ['12883420155'],
      domains: ['a2aenergia.eu', 'a2a.eu'],
      legalNames: ['A2A Energia S.p.A.'],
      aliases: ['A2A', 'A2A Energia'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Edison Energia',
      vatNumbers: ['08526440154'],
      domains: ['edison.it', 'edisonenergia.it'],
      legalNames: ['Edison Energia S.p.A.'],
      aliases: ['Edison', 'Edison Energia'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Hera Comm',
      vatNumbers: ['02221101203'],
      domains: ['heracomm.it', 'gruppohera.it'],
      legalNames: ['Hera Comm S.r.l.'],
      aliases: ['Hera', 'Hera Comm'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Iren Mercato',
      vatNumbers: ['01178580997'],
      domains: ['irenlucegas.it', 'gruppoiren.it'],
      legalNames: ['Iren Mercato S.p.A.'],
      aliases: ['Iren', 'Iren Luce Gas', 'Iren Mercato'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Acea Energia',
      vatNumbers: ['07305981002'],
      domains: ['aceaenergia.it', 'acea.it'],
      legalNames: ['Acea Energia S.p.A.'],
      aliases: ['Acea', 'Acea Energia'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'E.ON Energia',
      vatNumbers: ['03543040965'],
      domains: ['eon-energia.com', 'eon.com'],
      legalNames: ['E.ON Energia S.p.A.'],
      aliases: ['E.ON', 'EON'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Sorgenia',
      vatNumbers: ['07756640961'],
      domains: ['sorgenia.it'],
      legalNames: ['Sorgenia S.p.A.'],
      aliases: ['Sorgenia'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Engie Italia',
      vatNumbers: ['04618510965'],
      domains: ['engie.it'],
      legalNames: ['Engie Italia S.p.A.'],
      aliases: ['Engie'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Illumia',
      vatNumbers: ['02576661206'],
      domains: ['illumia.it'],
      legalNames: ['Illumia S.p.A.'],
      aliases: ['Illumia'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Dolomiti Energia',
      vatNumbers: ['01812630224'],
      domains: ['dolomitienergia.it'],
      legalNames: ['Dolomiti Energia S.p.A.'],
      aliases: ['Dolomiti Energia'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Wekiwi',
      vatNumbers: ['09198370963'],
      domains: ['wekiwi.it'],
      legalNames: ['Wekiwi S.r.l.'],
      aliases: ['Wekiwi'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Alperia',
      vatNumbers: ['01580330215'],
      domains: ['alperia.eu'],
      legalNames: ['Alperia Energy S.r.l.'],
      aliases: ['Alperia'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Green Network',
      vatNumbers: ['01517841004'],
      domains: ['greennetwork.it'],
      legalNames: ['Green Network S.p.A.'],
      aliases: ['Green Network'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Optima Italia',
      vatNumbers: ['07972491210'],
      domains: ['optimaitalia.com'],
      legalNames: ['Optima Italia S.p.A.'],
      aliases: ['Optima'],
    ),
    SupplierCatalogEntry(
      canonicalName: 'Estra Energie',
      vatNumbers: ['01219980529'],
      domains: ['estra.it'],
      legalNames: ['Estra Energie S.r.l.'],
      aliases: ['Estra'],
    ),
  ];

  // Lookup maps built once from catalog
  static final Map<String, String> _vatToSupplier = _buildVatMap();
  static final Map<String, String> _domainToSupplier = _buildDomainMap();

  static Map<String, String> _buildVatMap() {
    final map = <String, String>{};
    for (final entry in _catalog) {
      for (final vat in entry.vatNumbers) {
        map[vat] = entry.canonicalName;
      }
    }
    return map;
  }

  static Map<String, String> _buildDomainMap() {
    final map = <String, String>{};
    for (final entry in _catalog) {
      for (final domain in entry.domains) {
        map[domain.toLowerCase()] = entry.canonicalName;
      }
    }
    return map;
  }

  /// Main entry point — extracts bill data from any supported file
  Future<BillOcrResult> extractFromFile(String filePath, String billType) async {
    final ext = filePath.split('.').last.toLowerCase();

    if (_pdfExtensions.contains(ext)) {
      return _extractFromPdf(filePath, billType);
    } else if (_imageExtensions.contains(ext)) {
      return _extractFromImage(filePath, billType);
    }

    return const BillOcrResult(rawText: '');
  }

  /// Check if file is a supported type for OCR
  static bool isSupported(String path) {
    final ext = path.split('.').last.toLowerCase();
    return _imageExtensions.contains(ext) || _pdfExtensions.contains(ext);
  }

  // ─── PDF Handling ───────────────────────────────────────

  /// Smart PDF extraction: embedded text first, fallback to render + ML Kit
  Future<BillOcrResult> _extractFromPdf(String filePath, String billType) async {
    // Step 1: Try embedded text extraction (digital PDFs)
    final embeddedText = await _extractPdfEmbeddedText(filePath);
    if (embeddedText.trim().length > 50) {
      debugPrint('PDF: Using embedded text (${embeddedText.length} chars)');
      return _parseText(embeddedText, billType);
    }

    // Step 2: Fallback — render pages to images and run ML Kit
    debugPrint('PDF: No embedded text found, rendering to image for OCR');
    return _extractFromPdfViaRendering(filePath, billType);
  }

  /// Extract embedded text from a digital PDF using Syncfusion
  Future<String> _extractPdfEmbeddedText(String filePath) async {
    try {
      final bytes = File(filePath).readAsBytesSync();
      final document = syncfusion.PdfDocument(inputBytes: bytes);
      final buffer = StringBuffer();

      final pageCount = document.pages.count;
      final maxPages = pageCount > 5 ? 5 : pageCount;

      for (int i = 0; i < maxPages; i++) {
        final text = syncfusion.PdfTextExtractor(document).extractText(startPageIndex: i, endPageIndex: i);
        buffer.writeln(text);
      }

      document.dispose();
      return buffer.toString();
    } catch (e) {
      debugPrint('PDF embedded text extraction error: $e');
      return '';
    }
  }

  /// Render PDF pages to images, then run ML Kit on each
  Future<BillOcrResult> _extractFromPdfViaRendering(String filePath, String billType) async {
    try {
      final doc = await pdfx.PdfDocument.openFile(filePath);
      final pageCount = doc.pagesCount;
      final maxPages = pageCount > 3 ? 3 : pageCount;
      final buffer = StringBuffer();

      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

      try {
        for (int i = 1; i <= maxPages; i++) {
          final page = await doc.getPage(i);
          final pageImage = await page.render(
            width: page.width * 2,
            height: page.height * 2,
            format: pdfx.PdfPageImageFormat.png,
          );
          await page.close();

          if (pageImage == null) continue;

          // Write rendered image to temp file for ML Kit
          final tempFile = File('${Directory.systemTemp.path}/bill_page_$i.png');
          await tempFile.writeAsBytes(pageImage.bytes);

          final inputImage = InputImage.fromFilePath(tempFile.path);
          final recognized = await recognizer.processImage(inputImage);
          buffer.writeln(recognized.text);

          // Clean up temp file
          try { await tempFile.delete(); } catch (_) {}
        }
      } finally {
        await recognizer.close();
        await doc.close();
      }

      final rawText = buffer.toString();
      if (rawText.trim().isEmpty) {
        return const BillOcrResult(rawText: '');
      }
      return _parseText(rawText, billType);
    } catch (e) {
      debugPrint('PDF render + OCR error: $e');
      return const BillOcrResult(rawText: '');
    }
  }

  // ─── Image Handling ─────────────────────────────────────

  /// Extract text from an image file using Google ML Kit
  Future<BillOcrResult> _extractFromImage(String imagePath, String billType) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognized = await recognizer.processImage(inputImage);
      final rawText = recognized.text;

      if (rawText.trim().isEmpty) {
        return const BillOcrResult(rawText: '');
      }
      return _parseText(rawText, billType);
    } catch (e) {
      debugPrint('ML Kit OCR error: $e');
      return const BillOcrResult(rawText: '');
    } finally {
      await recognizer.close();
    }
  }

  // ─── Text Parsing (Regex/Keyword) ──────────────────────

  BillOcrResult _parseText(String rawText, String billType) {
    final isElectricity = billType == 'electricity';
    final supplierResult = _identifySupplier(rawText);

    return BillOcrResult(
      supplierName: supplierResult.supplier ?? supplierResult.rawName,
      supplierConfidence: supplierResult.confidence,
      podNumber: isElectricity ? _extractPod(rawText) : null,
      pdrNumber: !isElectricity ? _extractPdr(rawText) : null,
      totalAmount: _extractTotalAmount(rawText),
      consumptionKwh: isElectricity ? _extractConsumptionKwh(rawText) : null,
      consumptionSmc: !isElectricity ? _extractConsumptionSmc(rawText) : null,
      costPerUnit: _extractCostPerUnit(rawText, isElectricity),
      fixedCharges: _extractFixedCharges(rawText),
      taxes: _extractTaxes(rawText),
      billingPeriodStart: _extractBillingPeriodStart(rawText),
      billingPeriodEnd: _extractBillingPeriodEnd(rawText),
      supplyAddress: _extractSupplyAddress(rawText),
      codiceFiscale: _extractCodiceFiscale(rawText),
      partitaIva: _extractPartitaIva(rawText),
      contractNumber: _extractContractNumber(rawText),
      meterNumber: _extractMeterNumber(rawText),
      customerName: _extractCustomerName(rawText),
      rawText: rawText,
    );
  }

  // ── Supplier (Multi-Tier Scoring) ──

  SupplierIdentification _identifySupplier(String rawText) {
    // Define text regions
    final header = rawText.substring(0, min(600, rawText.length));
    final footer = rawText.substring(max(0, rawText.length - 400));
    final headerFooter = '$header\n$footer';

    final scores = <String, int>{};
    final methods = <String, String>{}; // track highest-tier method per supplier
    final allVatsFound = <String>[];

    // ── Tier 1: VAT matching (+100) — search full raw text ──
    final vatMatches = RegExp(r'\b(\d{11})\b').allMatches(rawText);
    for (final match in vatMatches) {
      final vat = match.group(1)!;
      final supplier = _vatToSupplier[vat];
      if (supplier != null) {
        scores[supplier] = (scores[supplier] ?? 0) + 100;
        methods[supplier] ??= 'vat';
      } else {
        allVatsFound.add(vat);
      }
    }

    // ── Tier 2a: Domain matching (+50) — search header+footer ──
    // Match emails
    final emailMatches = RegExp(r'[\w.\-]+@([\w.\-]+\.\w{2,})').allMatches(headerFooter);
    for (final match in emailMatches) {
      final domain = match.group(1)!.toLowerCase();
      final supplier = _domainToSupplier[domain];
      if (supplier != null) {
        scores[supplier] = (scores[supplier] ?? 0) + 50;
        methods[supplier] ??= 'domain';
      }
    }
    // Match URLs
    final urlMatches = RegExp(r'(?:https?://)?(?:www\.)?([\w.\-]+\.\w{2,})').allMatches(headerFooter);
    for (final match in urlMatches) {
      final domain = match.group(1)!.toLowerCase();
      final supplier = _domainToSupplier[domain];
      if (supplier != null && !scores.containsKey(supplier)) {
        // Only add if not already scored by email (avoid double-counting)
        scores[supplier] = (scores[supplier] ?? 0) + 50;
        methods[supplier] ??= 'domain';
      }
    }

    // ── Tier 2b: Legal name matching (+40) — exact match in header+footer ──
    for (final entry in _catalog) {
      for (final legalName in entry.legalNames) {
        if (headerFooter.toLowerCase().contains(legalName.toLowerCase())) {
          scores[entry.canonicalName] = (scores[entry.canonicalName] ?? 0) + 40;
          methods[entry.canonicalName] ??= 'legal';
          break; // one legal match per supplier is enough
        }
      }
    }

    // ── Tier 3: Alias matching (+10) — word-boundary in header+footer ONLY ──
    for (final entry in _catalog) {
      for (final alias in entry.aliases) {
        final escaped = RegExp.escape(alias);
        final pattern = RegExp('\\b$escaped\\b', caseSensitive: false);
        if (pattern.hasMatch(headerFooter)) {
          scores[entry.canonicalName] = (scores[entry.canonicalName] ?? 0) + 10;
          methods[entry.canonicalName] ??= 'alias';
          break; // one alias match per supplier is enough
        }
      }
    }

    // ── Decision ──
    if (scores.isEmpty) {
      // No catalog hit — try footer anchor for unknown supplier
      final rawName = _extractRawSupplierName(footer);
      return SupplierIdentification(
        supplier: null,
        confidence: 'unrecognized',
        score: 0,
        method: rawName != null ? 'footer_anchor' : 'none',
        rawName: rawName,
        vatFound: allVatsFound,
      );
    }

    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final best = sorted[0];
    final runnerUp = sorted.length > 1 ? sorted[1] : null;

    // Check for ambiguity
    if (runnerUp != null && (best.value - runnerUp.value) < 10) {
      return SupplierIdentification(
        supplier: best.key,
        confidence: 'ambiguous',
        score: best.value,
        method: methods[best.key] ?? 'none',
        rawName: null,
        vatFound: allVatsFound,
      );
    }

    // Determine confidence from score
    final String confidence;
    if (best.value >= 100) {
      confidence = 'high';
    } else if (best.value >= 40) {
      confidence = 'medium';
    } else {
      confidence = 'low';
    }

    return SupplierIdentification(
      supplier: best.key,
      confidence: confidence,
      score: best.value,
      method: methods[best.key] ?? 'none',
      rawName: null,
      vatFound: allVatsFound,
    );
  }

  /// Fallback: extract raw supplier name from footer via legal entity pattern
  String? _extractRawSupplierName(String footer) {
    final match = RegExp(
      r'([A-Z][\w&.\s]{2,40}?)\s+(?:S\.p\.A\.|S\.r\.l\.|S\.a\.s\.|S\.n\.c\.)',
    ).firstMatch(footer);
    return match?.group(1)?.trim();
  }

  // ── POD (Electricity) ──

  String? _extractPod(String text) {
    // POD format: IT + 3 digits + E + 8+ digits
    final match = RegExp(r'IT\d{3}E\d{8,}').firstMatch(text);
    return match?.group(0);
  }

  // ── PDR (Gas) ──

  String? _extractPdr(String text) {
    // PDR must be near a keyword — standalone 14-digit numbers are too
    // ambiguous (could be IBAN fragments, phone numbers, etc.)
    final patterns = [
      RegExp(
        r'(?:PDR|Punto\s+di\s+[Rr]iconsegna)[:\s]*(\d{14})',
        caseSensitive: false,
      ),
      RegExp(
        r'(\d{14})\s*(?:PDR|Punto\s+di\s+[Rr]iconsegna)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) return match.group(1);
    }
    return null;
  }

  // ── Total Amount ──

  double? _extractTotalAmount(String text) {
    final patterns = [
      // Specific "totale bolletta/fattura/da pagare" — highest confidence
      RegExp(
        r'(?:totale\s+(?:bolletta|fattura|da\s+pagare|importo)|importo\s+totale|totale\s+dovuto)[:\s]*(?:EUR|€)?\s*(\d{1,6}[.,]\d{2})',
        caseSensitive: false,
      ),
      // "€ 123,45 totale/da pagare" (reversed order)
      RegExp(
        r'(?:EUR|€)\s*(\d{1,6}[.,]\d{2})\s*(?:totale\s+bolletta|totale\s+fattura|da\s+pagare)',
        caseSensitive: false,
      ),
      // Bare "TOTALE" only if preceded by newline/start (avoid matching subtotals)
      RegExp(
        r'(?:^|\n)\s*TOTALE[:\s]*(?:EUR|€)?\s*(\d{1,6}[.,]\d{2})',
        multiLine: true,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return _parseItalianNumber(match.group(1));
      }
    }
    return null;
  }

  // ── Consumption kWh ──

  double? _extractConsumptionKwh(String text) {
    // Only match kWh values near consumption-related keywords to avoid
    // picking up unrelated numbers (e.g. tariff tables, page headers)
    final patterns = [
      RegExp(
        r'(?:consumo|consumi|energia\s+attiva|totale\s+energia|prelievo)[:\s]*(\d{1,6}[.,]?\d{0,2})\s*kWh',
        caseSensitive: false,
      ),
      RegExp(
        r'(\d{3,6}[.,]?\d{0,2})\s*kWh\s*(?:consumat|fattura|periodo)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return _parseItalianNumber(match.group(1));
      }
    }
    return null;
  }

  // ── Consumption Smc ──

  double? _extractConsumptionSmc(String text) {
    // Only match Smc values near consumption-related keywords
    final patterns = [
      RegExp(
        r'(?:consumo|consumi|totale\s+gas|prelievo)[:\s]*(\d{1,6}[.,]?\d{0,2})\s*[Ss][Mm][Cc]',
        caseSensitive: false,
      ),
      RegExp(
        r'(\d{3,6}[.,]?\d{0,2})\s*[Ss][Mm][Cc]\s*(?:consumat|fattura|periodo)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return _parseItalianNumber(match.group(1));
      }
    }
    return null;
  }

  // ── Cost per Unit ──

  double? _extractCostPerUnit(String text, bool isElectricity) {
    final unit = isElectricity ? 'kWh' : '[Ss][Mm][Cc]';
    final patterns = [
      RegExp(
        '(?:prezzo|costo)\\s*(?:unitario|energia|gas|materia prima)[:\\s]*(?:EUR|€)?\\s*(\\d{1,3}[.,]\\d{2,6})\\s*(?:EUR|€)?/?$unit',
        caseSensitive: false,
      ),
      RegExp(
        '(?:EUR|€)\\s*(\\d{1,3}[.,]\\d{2,6})\\s*/?$unit',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return _parseItalianNumber(match.group(1));
      }
    }
    return null;
  }

  // ── Fixed Charges ──

  double? _extractFixedCharges(String text) {
    final match = RegExp(
      r'(?:quota\s+fissa|oneri\s+fissi|costi\s+fissi|componente\s+fissa)[:\s]*(?:EUR|€)?\s*(\d{1,6}[.,]\d{2})',
      caseSensitive: false,
    ).firstMatch(text);
    return match != null ? _parseItalianNumber(match.group(1)) : null;
  }

  // ── Taxes ──

  double? _extractTaxes(String text) {
    // Try to find a combined taxes figure
    final patterns = [
      RegExp(
        r'(?:totale\s+imposte|imposte\s+e\s+iva|imposte)[:\s]*(?:EUR|€)?\s*(\d{1,6}[.,]\d{2})',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:accise|accisa)[:\s]*(?:EUR|€)?\s*(\d{1,6}[.,]\d{2})',
        caseSensitive: false,
      ),
      RegExp(
        r'IVA[:\s]*(?:\d{1,2}%\s*)?(?:EUR|€)?\s*(\d{1,6}[.,]\d{2})',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return _parseItalianNumber(match.group(1));
      }
    }
    return null;
  }

  // ── Billing Period ──

  String? _extractBillingPeriodStart(String text) {
    final dates = _extractBillingPeriodDates(text);
    return dates?.$1;
  }

  String? _extractBillingPeriodEnd(String text) {
    final dates = _extractBillingPeriodDates(text);
    return dates?.$2;
  }

  (String, String)? _extractBillingPeriodDates(String text) {
    final patterns = [
      RegExp(
        r'(?:periodo|dal)[:\s]*(?:di\s+(?:fatturazione|riferimento))?\s*[:\s]*(\d{1,2}[/.\-]\d{1,2}[/.\-]\d{2,4})\s*(?:al|[-–])\s*(\d{1,2}[/.\-]\d{1,2}[/.\-]\d{2,4})',
        caseSensitive: false,
      ),
      RegExp(
        r'(\d{1,2}[/.\-]\d{1,2}[/.\-]\d{2,4})\s*[-–]\s*(\d{1,2}[/.\-]\d{1,2}[/.\-]\d{2,4})',
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final start = _parseItalianDate(match.group(1));
        final end = _parseItalianDate(match.group(2));
        if (start != null && end != null) {
          return (start, end);
        }
      }
    }
    return null;
  }

  // ── Supply Address ──

  String? _extractSupplyAddress(String text) {
    final patterns = [
      RegExp(
        r'(?:indirizzo\s+di\s+fornitura|indirizzo\s+fornitura|punto\s+di\s+fornitura|indirizzo\s+di\s+consegna)[:\s]*([^\n]{10,80})',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:ubicazione|fornitura\s+presso)[:\s]*([^\n]{10,80})',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1)?.trim();
      }
    }
    return null;
  }

  // ── Codice Fiscale (Tax Code) ──

  String? _extractCodiceFiscale(String text) {
    // Italian Codice Fiscale: 16 alphanumeric chars, specific pattern
    // Format: 6 letters + 2 digits + 1 letter + 2 digits + 1 letter + 3 digits + 1 letter
    final contextMatch = RegExp(
      r'(?:codice\s+fiscale|cod\.?\s*fisc\.?|C\.?F\.?)[:\s]*([A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z])',
      caseSensitive: false,
    ).firstMatch(text);
    if (contextMatch != null) return contextMatch.group(1)?.toUpperCase();

    // Standalone pattern (less reliable, only if near known context)
    final standalone = RegExp(
      r'\b([A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z])\b',
    ).firstMatch(text);
    return standalone?.group(1);
  }

  // ── Partita IVA (VAT Number) ──

  String? _extractPartitaIva(String text) {
    // Partita IVA: 11 digits, often prefixed with IT
    final contextMatch = RegExp(
      r'(?:partita\s+iva|P\.?\s*IVA|P\.?\s*I\.?\s*V\.?\s*A\.?)[:\s]*(?:IT)?(\d{11})\b',
      caseSensitive: false,
    ).firstMatch(text);
    return contextMatch?.group(1);
  }

  // ── Contract Number ──

  String? _extractContractNumber(String text) {
    final patterns = [
      RegExp(
        r'(?:numero\s+contratto|n\.?\s*contratto|codice\s+contratto|contratto\s+n\.?)[:\s]*([A-Z0-9\-/]{4,30})',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:codice\s+cliente|n\.?\s*cliente|numero\s+cliente)[:\s]*([A-Z0-9\-/]{4,30})',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1)?.trim();
      }
    }
    return null;
  }

  // ── Meter Number (Matricola) ──

  String? _extractMeterNumber(String text) {
    final patterns = [
      RegExp(
        r'(?:matricola|matricola\s+contatore|n\.?\s*contatore|contatore\s+n\.?)[:\s]*([A-Z0-9\-]{4,20})',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:meter|contatore)[:\s]*([A-Z0-9\-]{6,20})',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1)?.trim();
      }
    }
    return null;
  }

  // ── Customer Name (Intestatario) ──

  String? _extractCustomerName(String text) {
    final patterns = [
      RegExp(
        r'(?:intestatario|intestato\s+a|titolare|cliente)[:\s]*([A-ZÀ-Ú][a-zà-ú]+(?:\s+[A-ZÀ-Ú][a-zà-ú]+){1,3})',
        caseSensitive: true,
      ),
      RegExp(
        r'(?:Sig\.?|Sig\.?ra|Spett\.?le)[:\s]*([A-ZÀ-Ú][a-zà-ú]+(?:\s+[A-ZÀ-Ú][a-zà-ú]+){1,3})',
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1)?.trim();
      }
    }
    return null;
  }

  // ─── Helpers ────────────────────────────────────────────

  /// Converts Italian number format to double
  /// "1.250,50" → 1250.50, "125,50" → 125.50, "125.50" → 125.50
  double? _parseItalianNumber(String? text) {
    if (text == null || text.isEmpty) return null;
    var cleaned = text.trim();

    // If has both dot and comma: dot is thousands sep, comma is decimal
    if (cleaned.contains('.') && cleaned.contains(',')) {
      cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
    }
    // If only comma: it's the decimal separator
    else if (cleaned.contains(',')) {
      cleaned = cleaned.replaceAll(',', '.');
    }

    return double.tryParse(cleaned);
  }

  /// Converts Italian date (DD/MM/YYYY, DD.MM.YYYY, DD-MM-YYYY) to ISO (YYYY-MM-DD)
  String? _parseItalianDate(String? text) {
    if (text == null || text.isEmpty) return null;

    final match = RegExp(r'(\d{1,2})[/.\-](\d{1,2})[/.\-](\d{2,4})').firstMatch(text);
    if (match == null) return null;

    final day = match.group(1)!.padLeft(2, '0');
    final month = match.group(2)!.padLeft(2, '0');
    var year = match.group(3)!;

    // Handle 2-digit year
    if (year.length == 2) {
      final y = int.parse(year);
      year = (y > 50 ? '19' : '20') + year;
    }

    // Validate
    final d = int.tryParse(day);
    final m = int.tryParse(month);
    if (d == null || m == null || d < 1 || d > 31 || m < 1 || m > 12) return null;

    return '$year-$month-$day';
  }
}
