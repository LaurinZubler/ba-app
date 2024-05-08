import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final mobileScannerControllerProvider = Provider.autoDispose<MobileScannerController>((ref) {
    final controller = MobileScannerController();
    ref.onDispose(() async => await controller.dispose());
    return controller;
  }
);

typedef OnQrError = void Function(BuildContext context, Object error);
typedef OnQrDetect = void Function(String qr);

class Camera extends ConsumerWidget {
  const Camera({super.key, required this.onQrError, required this.onQrDetect});

  final OnQrError onQrError;
  final OnQrDetect onQrDetect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(mobileScannerControllerProvider);

    final handleBarcode = (BarcodeCapture capture) async {
      final List<Barcode> barcodes = capture.barcodes;
      var qr;
      for (final barcode in barcodes) {
        await controller.stop();
        qr = barcode.rawValue.toString();
      }
      onQrDetect(qr);
    };

    return MobileScanner(
      controller: controller,
      errorBuilder: (context, error, child) {
        onQrError(context, error);
      // todo: why child?? remove?
      // todo: i18n: permission denied
        return child ?? Center(child: Text('Unable to access camera'));
      },
      onDetect: handleBarcode
    );
  }
}
