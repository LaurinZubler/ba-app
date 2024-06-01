import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qr extends HookConsumerWidget {
  final String _qrData;
  final EdgeInsets _padding;

  const Qr({super.key, required String qrData, required EdgeInsets padding}) : _qrData = qrData, _padding = padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // todo: return if data empty or null
    print(_qrData);
    return QrImageView(
      data: _qrData,
      version: QrVersions.auto,
      gapless: false,
      padding: _padding,
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
