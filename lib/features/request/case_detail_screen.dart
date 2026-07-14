import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/request/models/case_model.dart';

class CaseDetailScreen extends StatefulWidget {
  const CaseDetailScreen({super.key});

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  final ApiService _api = ApiService();
  CaseModel? _caseData;
  bool _isLoading = true;
  bool _isUploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCase();
  }

  Future<void> _fetchCase() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final caseId = Get.arguments as String?;
      if (caseId == null) {
        setState(() {
          _error = 'ID pratica non trovato';
          _isLoading = false;
        });
        return;
      }

      final response = await _api.get(ApiConstants.getCaseDetails(caseId));
      final body = response.data as Map<String, dynamic>;

      if (body['success'] == true) {
        setState(() {
          _caseData = CaseModel.fromJson(body['data'] as Map<String, dynamic>);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Impossibile caricare i dati';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Errore di connessione';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _caseData?.caseNumber ?? 'Dettagli Pratica',
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(fontSize: 15, color: AppColors.textMid)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchCase,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              child: const Text('Riprova', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final caseData = _caseData!;
    return RefreshIndicator(
      onRefresh: _fetchCase,
      color: AppColors.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusStepper(caseData),
            const SizedBox(height: 20),
            _buildOfferCard(caseData),
            const SizedBox(height: 16),
            _buildContractCard(caseData),
            const SizedBox(height: 20),
            _buildTimeline(caseData),
          ],
        ),
      ),
    );
  }

  // ── Status Stepper ──
  Widget _buildStatusStepper(CaseModel caseData) {
    final steps = [
      'Inviata',
      'In Lavorazione',
      'Contratto Inviato',
      'Contratto Firmato',
      'Attivata',
    ];
    final currentStep = caseData.statusStep;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  caseData.statusLabel,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                final stepIdx = index ~/ 2;
                final isDone = stepIdx < currentStep;
                return Expanded(
                  child: Container(
                    height: 3,
                    color: isDone ? AppColors.green200 : const Color(0xFFE8E8E8),
                  ),
                );
              }
              final stepIdx = index ~/ 2;
              final isDone = stepIdx < currentStep;
              final isCurrent = stepIdx == currentStep;
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? AppColors.green200
                      : isCurrent
                          ? AppColors.primaryColor
                          : const Color(0xFFE8E8E8),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          '${stepIdx + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isCurrent ? Colors.white : const Color(0xFF999999),
                          ),
                        ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.map((label) {
              return SizedBox(
                width: 56,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textMid),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Offer Card ──
  Widget _buildOfferCard(CaseModel caseData) {
    final offer = caseData.selectedOffer;
    if (offer == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bolt, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.name ?? 'Offerta selezionata',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textDark),
                ),
                const SizedBox(height: 2),
                Text(
                  offer.supplier?.name ?? '',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Contract Card ──
  Widget _buildContractCard(CaseModel caseData) {
    final contract = caseData.contract;

    // No contract yet
    if (contract == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFFE082)),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_bottom, color: Color(0xFFF9A825), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contratto in preparazione',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFFF57F17)),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Il contratto ti verrà inviato a breve.',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF9A825)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Contract exists
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined, color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Contratto',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _contractStatusColor(contract.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  contract.statusLabel,
                  style: TextStyle(
                    color: _contractStatusColor(contract.status),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Delivery method info
          if (contract.deliveryMethod != null) ...[
            _infoRow(Icons.send, 'Inviato: ${contract.deliveryMethodLabel}'),
            const SizedBox(height: 8),
          ],

          // Download contract (if sent via app)
          if (contract.deliveryMethod == 'app' &&
              contract.documentUrl != null &&
              contract.status == 'sent') ...[
            _actionButton(
              icon: Icons.download,
              label: 'Scarica Contratto',
              color: AppColors.primaryColor,
              onTap: () => _openUrl(contract.documentUrl!),
            ),
            const SizedBox(height: 10),
          ],

          // Upload signed contract (if status is sent)
          if (contract.status == 'sent') ...[
            _actionButton(
              icon: Icons.upload_file,
              label: 'Carica Contratto Firmato',
              color: AppColors.green200,
              isLoading: _isUploading,
              onTap: () => _uploadSignedContract(contract.id),
            ),
          ],

          // Waiting for confirmation (if signed)
          if (contract.status == 'signed')
            _infoRow(Icons.hourglass_top, 'In attesa di conferma dall\'operatore'),

          // Active
          if (contract.status == 'active') ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.green200.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.green200, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Utenza attivata!',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1B8A4A)),
                    ),
                  ),
                ],
              ),
            ),
            if (contract.activationDate != null) ...[
              const SizedBox(height: 8),
              _infoRow(Icons.calendar_today, 'Attivata il: ${_formatDate(contract.activationDate!)}'),
            ],
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMid),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMid),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onTap,
        icon: isLoading
            ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }

  Color _contractStatusColor(String status) {
    switch (status) {
      case 'draft':
        return Colors.grey;
      case 'sent':
        return Colors.blue;
      case 'signed':
        return Colors.orange;
      case 'active':
        return AppColors.green200;
      default:
        return Colors.grey;
    }
  }

  // ── Timeline ──
  Widget _buildTimeline(CaseModel caseData) {
    final events = caseData.events.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (events.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cronologia',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark),
        ),
        const SizedBox(height: 12),
        ...events.map((event) => _buildEventItem(event)),
      ],
    );
  }

  Widget _buildEventItem(CaseEventModel event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _eventColor(event.eventType).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_eventIcon(event.eventType), size: 16, color: _eventColor(event.eventType)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark),
                ),
                if (event.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      event.description!,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textMid),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatDateTime(event.createdAt),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _eventIcon(String type) {
    switch (type) {
      case 'status_change':
        return Icons.swap_horiz;
      case 'document_uploaded':
        return Icons.upload_file;
      case 'document_verified':
        return Icons.verified;
      case 'contract_generated':
        return Icons.description;
      case 'contract_signed':
        return Icons.draw;
      case 'admin_assigned':
        return Icons.person_add;
      default:
        return Icons.info_outline;
    }
  }

  Color _eventColor(String type) {
    switch (type) {
      case 'status_change':
        return Colors.orange;
      case 'document_uploaded':
        return Colors.blue;
      case 'document_verified':
        return AppColors.green200;
      case 'contract_generated':
        return Colors.amber.shade700;
      case 'contract_signed':
        return AppColors.green200;
      case 'admin_assigned':
        return AppColors.primaryColor;
      default:
        return Colors.grey;
    }
  }

  // ── Upload signed contract ──
  Future<void> _uploadSignedContract(String contractId) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _isUploading = true);

    try {
      // Step 1: Upload file
      final fileName = picked.path.split('/').last;
      final multipartFile = await MultipartFile.fromFile(picked.path, filename: fileName);
      final uploadResponse = await _api.uploadFile(ApiConstants.fileUpload, file: multipartFile);
      final uploadBody = uploadResponse.data as Map<String, dynamic>;

      if (uploadBody['success'] != true) {
        throw Exception('Upload failed');
      }

      final fileUrl = (uploadBody['data'] as Map<String, dynamic>)['url'] as String;

      // Step 2: Attach to contract
      await _api.patch(
        ApiConstants.uploadSignedContract(contractId),
        data: {'signedDocumentUrl': fileUrl},
      );

      Get.snackbar(
        'Successo',
        'Contratto firmato caricato con successo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.green200,
        colorText: Colors.white,
      );

      // Refresh data
      await _fetchCase();
    } catch (e) {
      Get.snackbar(
        'Errore',
        'Impossibile caricare il contratto firmato',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  String _formatDateTime(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
