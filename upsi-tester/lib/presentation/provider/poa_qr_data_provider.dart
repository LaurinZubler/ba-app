import 'dart:async';
import 'package:upsi_core/global.dart';
import 'package:upsi_tester/application/provider/qr_code_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/service/tester_qr_code_service.dart';

final poaQRDataProvider = StateNotifierProvider<PoAQRDataNotifier, String>((ref) {
  final qrCodeService = ref.watch(qrCodeServiceProvider);
  return PoAQRDataNotifier(qrCodeService);
});

class PoAQRDataNotifier extends StateNotifier<String> {
  final TesterQRCodeService _qrCodeService;

  PoAQRDataNotifier(this._qrCodeService) : super('') {
    _startUpdatingQr();
  }

  void _startUpdatingQr() {
    _updateQr();
    Timer.periodic(Global.QR_UPDATE_DURATION, (timer) {
      _updateQr();
    });
  }

  Future<void> _updateQr() async {
    final data = await _qrCodeService.createPoAQRData();
    state = data;
  }
}
