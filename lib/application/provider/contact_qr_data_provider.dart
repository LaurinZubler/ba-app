import 'dart:async';
import 'package:ba_app/application/provider/qr_code_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ba_app/application/service/qr_code_service.dart';

final contactQRDataProvider = StateNotifierProvider<ContactQRData, String>((ref) {
  final qrCodeService = ref.watch(qrCodeServiceProvider);
  return ContactQRData(qrCodeService);
});

class ContactQRData extends StateNotifier<String> {
  final QRCodeService _qrCodeService;

  ContactQRData(this._qrCodeService) : super('') {
    _startUpdatingQr();
  }

  void _startUpdatingQr() {
    _updateQr();
    Timer.periodic(const Duration(minutes: 5), (timer) {
      _updateQr();
    });
  }

  Future<void> _updateQr() async {
    final data = await _qrCodeService.createContactQRData();
    state = data;
  }
}
