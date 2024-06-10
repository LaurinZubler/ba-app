import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qr extends HookConsumerWidget {
  final String _qrData;
  final EdgeInsets _padding;
  final String? _imageUrl;

  const Qr({super.key, required String qrData, required EdgeInsets padding, String? imageUrl}) : _qrData = qrData, _padding = padding, _imageUrl = imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QrImageView(
      data: _qrData,
      version: QrVersions.auto,
      gapless: false,
      padding: _padding,
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: Theme.of(context).colorScheme.primary),
      dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: Theme.of(context).colorScheme.primary),
      embeddedImage: _imageUrl != null ? AssetImage(_imageUrl) : null,
      embeddedImageStyle: _imageUrl != null ? const QrEmbeddedImageStyle(size: Size(50, 50)) : null
    );
  }
}
