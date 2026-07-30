import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
  String? _localPath;
  bool _isLoading = true;
  String _error = '';
  double _progress = 0;
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _downloadDocument();
  }

  String get _fullUrl {
    if (widget.url.startsWith('http')) return widget.url;
    return '${ApiConstants.baseUrl}/${widget.url.replaceAll(RegExp(r'^/'), '')}';
  }

  Future<void> _downloadDocument() async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName = widget.url.split('/').last;
      final filePath = '${dir.path}/$fileName';

      final file = File(filePath);
      if (await file.exists()) {
        if (mounted) {
          setState(() {
            _localPath = filePath;
            _isLoading = false;
          });
        }
        return;
      }

      await ApiService().dio.download(
        _fullUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() => _progress = received / total);
          }
        },
      );

      if (mounted) {
        setState(() {
          _localPath = filePath;
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message ?? 'document_viewer.error'.tr;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveDocument() async {
    if (_localPath == null || _isSaving) return;
    setState(() => _isSaving = true);

    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(_localPath!)], title: widget.title),
      );
    } catch (_) {
      if (mounted) {
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
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
          if (_localPath != null)
            GestureDetector(
              onTap: _isSaving ? null : _saveDocument,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                child: _isSaving
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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                value: _progress > 0 ? _progress : null,
                color: AppColors.purple,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'document_viewer.loading'.tr,
              style: const TextStyle(
                color: AppColors.textMid,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (_progress > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${(_progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    if (_error.isNotEmpty) {
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
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _error = '';
                      _progress = 0;
                    });
                    _downloadDocument();
                  },
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

    if (_localPath != null) {
      return Column(
        children: [
          Expanded(
            child: PDFView(
              filePath: _localPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              fitPolicy: FitPolicy.BOTH,
              onRender: (pages) {
                if (mounted) {
                  setState(() => _totalPages = pages ?? 0);
                }
              },
              onPageChanged: (page, total) {
                if (mounted) {
                  setState(() => _currentPage = page ?? 0);
                }
              },
              onError: (error) {
                if (mounted) {
                  setState(() => _error = error.toString());
                }
              },
            ),
          ),
          if (_totalPages > 1)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.divider, width: 1),
                ),
              ),
              child: Text(
                '${_currentPage + 1} / $_totalPages',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMid,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
