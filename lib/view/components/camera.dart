import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final mobileScannerControllerProvider = Provider.autoDispose<MobileScannerController>((ref) {
    final controller = MobileScannerController();
    ref.onDispose(() async => await controller.dispose());
    return controller;
  }
);

typedef OnQrError = void Function(String msg);
typedef OnQrDetect = void Function(String qr);

class Camera extends ConsumerWidget {
  const Camera({super.key, required this.onQrError, required this.onQrDetect});

  final OnQrError onQrError;
  final OnQrDetect onQrDetect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(mobileScannerControllerProvider);

    handleBarcode(BarcodeCapture capture) async {
      final List<Barcode> barcodes = capture.barcodes;

      if(barcodes.isEmpty) {
        // todo: error handling
        onQrError("");
        return;
      }

      String qr = barcodes.first.rawValue.toString();
      await controller.stop();
      onQrDetect(qr);
    }

    return MobileScanner(
      controller: controller,
      errorBuilder: (context, error, child) {
        onQrError(error.toString());
        return Center(child: Text(AppLocalizations.of(context)!.home_cameraError));
      },
      onDetect: handleBarcode
    );
  }
}
