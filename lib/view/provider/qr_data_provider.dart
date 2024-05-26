import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/qr_code_service.dart';

final qrDataProvider = StateNotifierProvider<QrDataNotifier, String>((ref) {
  return QrDataNotifier(
    qrCodeService: ref.watch(qrCodeServiceProvider)
  );
});

class QrDataNotifier extends StateNotifier<String> {

  final QRCodeService qrCodeService;

  QrDataNotifier({
    required this.qrCodeService
  }) : super('') {
    _startUpdatingQr();
  }

  void _startUpdatingQr() {
    _updateQr();
    Timer.periodic(const Duration(minutes: 5), (timer) {
      _updateQr();
    });
  }

  Future<void> _updateQr() async {
    final qrData = await qrCodeService.createContactQrData();
    state = qrData;
  }
}
