import 'dart:io';

import 'package:vyzi/core/utils/app_colors.dart';
import 'package:vyzi/features/home/email/email_bill_screen.dart';
import 'package:vyzi/features/utility/controller/select_utility_controller.dart';
import 'package:vyzi/features/utility/controller/upload_bill_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class UploadBillScreen extends StatefulWidget {
  final UtilityType utilityType;

  const UploadBillScreen({super.key, required this.utilityType});

  @override
  State<UploadBillScreen> createState() => _UploadBillScreenState();
}

class _UploadBillScreenState extends State<UploadBillScreen> {
  final UploadBillController _controller = UploadBillController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _title =>
      widget.utilityType == UtilityType.luce ? 'elettricità' : 'gas';

  // ─────────────────────────────────────────────
  //  ACTIONS
  // ─────────────────────────────────────────────

  /// Opens phone gallery / file picker
  Future<void> _openFilePicker() async {
    _controller.selectMethod(UploadMethod.uploadFile);
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (file != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selezionato: ${file.name}'),
            backgroundColor: const Color(0xFF9400D3),
          ),
        );
      }
    } catch (e) {
      debugPrint('File picker error: $e');
    }
  }

  /// Opens camera scanner
  void _openScanner() {
    _controller.selectMethod(UploadMethod.scanFile);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _ScannerScreen()),
    );
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Heading ──
            Text(
              'Carica la tua bolletta di $_title',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
                height: 1.28,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "Scegli il metodo più comodo per te",
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF9E9E9E),
                height: 1.22,
              ),
            ),
            SizedBox(height: 20.h),

            // ── Info banner ──
            _buildInfoBanner(),
            SizedBox(height: 20.h),

            // ── Upload / Scan cards ──
            _buildUploadScanRow(),
            SizedBox(height: 14.h),

            // ── OR divider ──
            _buildOrDivider(),
            SizedBox(height: 14.h),

            // ── Send Our Email card ──
            _buildEmailCard(),
            SizedBox(height: 24.h),

            // ── What we are looking for ──
            _buildLookingForCard(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded,
            color: const Color(0xFF1A1A2E), size: 22.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Carica la tua bolletta',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
          height: 1.22,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
            height: 1, thickness: 1, color: Colors.grey.shade200),
      ),
    );
  }

  // ── Info banner ──
  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEFF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.help_outline_rounded,
                  color: const Color(0xFF9400D3), size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Abbiamo bisogno della tua bolletta per analizzare il tuo piano attuale e trovare le migliori offerte.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF555555),
                    height: 1.22,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Perché ne abbiamo bisogno?',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9400D3),
                height: 1.22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Upload File + Scan File row ──
  Widget _buildUploadScanRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMethodCard(
            method: UploadMethod.uploadFile,
            assetIcon: 'assets/icons/upload.png',
            label: 'Carica File',
            sublabel: 'PDF, Foto',
            onTap: _openFilePicker,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: _buildMethodCard(
            method: UploadMethod.scanFile,
            assetIcon: 'assets/icons/scannn.png',
            label: 'Scansiona File',
            sublabel: 'Usa la fotocamera',
            onTap: _openScanner,
          ),
        ),
      ],
    );
  }

  Widget _buildMethodCard({
    required UploadMethod method,
    required String assetIcon,
    required String label,
    required String sublabel,
    required VoidCallback onTap,
  }) {
    final isSelected = _controller.selectedMethod == method;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF9400D3)
                : Colors.grey.shade200,
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetIcon,
              width: 56.w,
              height: 56.w,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 10.h),

            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
                height: 1.22,
              ),
            ),

            SizedBox(height: 3.h),

            Text(
              sublabel,
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF9E9E9E),
                height: 1.22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── OR divider ──
  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
            child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'OPPURE',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF9E9E9E),
              fontWeight: FontWeight.w500,
              height: 1.22,
            ),
          ),
        ),
        Expanded(
            child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }

  // ── Send Our Email card ──
  Widget _buildEmailCard() {
    return GestureDetector(
      onTap: () {
        _controller.selectMethod(UploadMethod.sendEmail);
        Get.to(() => EmailBillScreen());
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color:
            _controller.selectedMethod == UploadMethod.sendEmail
                ? const Color(0xFF9400D3)
                : Colors.grey.shade200,
            width:
            _controller.selectedMethod == UploadMethod.sendEmail
                ? 1.8
                : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8EF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.mail_outline_rounded,
                  color: const Color(0xFF27AE60), size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invia via Email',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                      height: 1.22,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Inoltra a Bills@Example.com',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9E9E9E),
                      height: 1.22,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.grey.shade400, size: 20.sp),
          ],
        ),
      ),
    );
  }

  // ── What we are looking for card ──
  Widget _buildLookingForCard() {
    const bullets = [
      'Fornitore attuale e tariffa',
      'Consumo mensile e costi',
      'Data di fine contratto',
      'Numero del contatore e punto di fornitura',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFEEF0FF),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cosa stiamo cercando:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              height: 1.22,
            ),
          ),
          SizedBox(height: 10.h),
          ...bullets.map(
                (b) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF555555),
                      height: 1.22,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      b,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF555555),
                        height: 1.22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  }

  // ─────────────────────────────────────────────
  //  SCANNER SCREEN  (uses mobile_scanner)
  // ─────────────────────────────────────────────

  class _ScannerScreen extends StatefulWidget {
  const _ScannerScreen();

  @override
  State<_ScannerScreen> createState() => _ScannerScreenState();
  }

  class _ScannerScreenState extends State<_ScannerScreen> {
  final MobileScannerController _scanController = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Scansiona la tua bolletta',
          style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              height: 1.22),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _scanController,
              builder: (_, state, __) => Icon(
                state.torchState == TorchState.on
                    ? Icons.flash_on_rounded
                    : Icons.flash_off_rounded,
                color: Colors.white,
              ),
            ),
            onPressed: () => _scanController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_rounded,
                color: Colors.white),
            onPressed: () => _scanController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Camera preview ──
          MobileScanner(
            controller: _scanController,
            onDetect: (capture) {
              if (_scanned) return;
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                _scanned = true;
                final value = barcodes.first.rawValue ?? '';
                Navigator.pop(context, value);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Scansionato: $value'),
                      backgroundColor: const Color(0xFF9400D3),
                    ),
                  );
                }
              }
            },
          ),

          // ── Overlay: scan frame ──
          Center(
            child: Container(
              width: 240.w,
              height: 240.w,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF9400D3), width: 2.5),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),

          // ── Hint text ──
          Positioned(
            bottom: 60.h,
            left: 0,
            right: 0,
            child: Text(
              'Allinea la tua bolletta nella cornice',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.22,
              ),
            ),
          ),
        ],
      ),
    );
  }
  }

