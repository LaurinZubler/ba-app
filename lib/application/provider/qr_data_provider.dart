import 'package:ba_app/application/service/qr_code_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

import '../service/contact_service.dart';

const QR_REFRESH_DURATION = Duration(seconds: 3);

final qrCodeDataProvider = StateNotifierProvider<QRCodeDataNotifier, AsyncValue<String>>((ref) {
  final qrCodeService = ref.watch(qrCodeServiceProvider.future);
  return QRCodeDataNotifier(qrCodeService);
});

class QRCodeDataNotifier extends StateNotifier<AsyncValue<String>> {
  final Future<QRCodeService> qrCodeService;
  Timer? _timer;

  QRCodeDataNotifier(this.qrCodeService) : super(const AsyncValue.loading()) {
    _startTimer();
  }

  Future<void> _fetchQrData() async {
    try {
      final service = await qrCodeService;
      final qrData = await service.createContactQr();
      state = AsyncValue.data(qrData);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void _startTimer() {
    _fetchQrData();
    _timer = Timer.periodic(QR_REFRESH_DURATION, (timer) {
      _fetchQrData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
