import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vyzi/core/constants/api_constants.dart';
import 'package:vyzi/core/services/api_service.dart';
import 'package:vyzi/core/utils/app_colors.dart';

class DocumentViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const DocumentViewerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  Uint8List? _pdfBytes;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isDownloading = false;

  String get _fullUrl {
    if (widget.url.startsWith('http')) return widget.url;
    return '${ApiConstants.baseUrl}/${widget.url.replaceAll(RegExp(r'^/'), '')}';
  }

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await ApiService().dio.get<List<int>>(
        _fullUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (mounted) {
        setState(() {
          _pdfBytes = Uint8List.fromList(response.data!);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _downloadDocument() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    try {
      final dir = await getTemporaryDirectory();
      final fileName = widget.url.split('/').last;
      final filePath = '${dir.path}/$fileName';

      if (_pdfBytes != null) {
        await File(filePath).writeAsBytes(_pdfBytes!);
      } else {
        await ApiService().dio.download(_fullUrl, filePath);
      }

      if (mounted) {
        setState(() => _isDownloading = false);
        await SharePlus.instance.share(
          ShareParams(files: [XFile(filePath)], title: widget.title),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isDownloading = false);
        Get.snackbar(
          'document_viewer.save_error_title'.tr,
          'document_viewer.save_error_message'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 40,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 12),
            child:
                Icon(Icons.chevron_left, color: AppColors.textDark, size: 28),
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (_pdfBytes != null)
            GestureDetector(
              onTap: _isDownloading ? null : _downloadDocument,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                child: _isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_rounded,
                        color: AppColors.textDark, size: 22),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? _buildLoading()
            : _hasError
                ? _buildError()
                : _buildViewer(),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.purple, strokeWidth: 3),
    );
  }

  Widget _buildViewer() {
    return SfPdfViewer.memory(
      _pdfBytes!,
      canShowScrollHead: true,
      canShowPaginationDialog: false,
      canShowScrollStatus: true,
      pageSpacing: 4,
      onDocumentLoadFailed: (details) {
        if (mounted) setState(() => _hasError = true);
      },
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              'document_viewer.error'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: _loadPdf,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'common.retry'.tr,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
