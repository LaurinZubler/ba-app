import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qr extends HookConsumerWidget {
  final String qrData;

  const Qr({super.key, required this.qrData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      gapless: false,
      padding: const EdgeInsets.all(24),
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: Theme.of(context).colorScheme.primary),
      dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: Theme.of(context).colorScheme.primary),
      // todo: add app logo, if present
      // embeddedImage: const AssetImage('resources/images/upsi.png'),
      // embeddedImageStyle: const QrEmbeddedImageStyle(
      //   size: Size(60, 60),
      // ),
    );
  }
}
