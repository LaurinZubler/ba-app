import 'dart:async';
import 'package:upsi_core/global.dart';
import 'package:upsi_user/application/provider/qr_code_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_user/application/service/user_qr_code_service.dart';

final contactQRDataProvider = StateNotifierProvider<ContactQRDataNotifier, String>((ref) {
  final qrCodeService = ref.watch(qrCodeServiceProvider);
  return ContactQRDataNotifier(qrCodeService);
});

class ContactQRDataNotifier extends StateNotifier<String> {
  final UserQRCodeService _qrCodeService;

  ContactQRDataNotifier(this._qrCodeService) : super('') {
    _startUpdatingQr();
  }

  void _startUpdatingQr() {
    _updateQr();
    Timer.periodic(Global.QR_UPDATE_DURATION, (timer) {
      _updateQr();
    });
  }

  Future<void> _updateQr() async {
    final data = await _qrCodeService.createContactQRData();
    state = data;
  }
}
