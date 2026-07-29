import 'dart:typed_data';

import '../../../core/services/bill_ocr_service.dart';

enum FileUploadStatus {
  pending,
  extracting,
  extracted,
  uploading,
  uploaded,
  failed,
}

class SelectedFile {
  final String id;
  final String path;
  final String name;
  final int sizeBytes;
  final String extension;
  final Uint8List? thumbnail;
  final FileUploadStatus status;
  final double progress;
  final String? errorMessage;
  final String? uploadedBillId;
  final String? fileUrl;
  final BillOcrResult? ocrResult;

  const SelectedFile({
    required this.id,
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.extension,
    this.thumbnail,
    this.status = FileUploadStatus.pending,
    this.progress = 0.0,
    this.errorMessage,
    this.uploadedBillId,
    this.fileUrl,
    this.ocrResult,
  });

  bool get isImage {
    const imageExts = ['jpg', 'jpeg', 'png', 'heic', 'webp'];
    return imageExts.contains(extension.toLowerCase());
  }

  bool get isPdf => extension.toLowerCase() == 'pdf';

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  SelectedFile copyWith({
    String? id,
    String? path,
    String? name,
    int? sizeBytes,
    String? extension,
    Uint8List? thumbnail,
    FileUploadStatus? status,
    double? progress,
    String? errorMessage,
    String? uploadedBillId,
    String? fileUrl,
    BillOcrResult? ocrResult,
  }) {
    return SelectedFile(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      extension: extension ?? this.extension,
      thumbnail: thumbnail ?? this.thumbnail,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadedBillId: uploadedBillId ?? this.uploadedBillId,
      fileUrl: fileUrl ?? this.fileUrl,
      ocrResult: ocrResult ?? this.ocrResult,
    );
  }
}
