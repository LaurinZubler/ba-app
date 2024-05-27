import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

import '../service/contact_service.dart';

const QR_REFRESH_DURATION = Duration(seconds: 3);

final qrCodeDataProvider = StateNotifierProvider<QRCodeDataNotifier, AsyncValue<String>>((ref) {
  final contactService = ref.watch(contactServiceProvider.future);
  return QRCodeDataNotifier(contactService);
});

class QRCodeDataNotifier extends StateNotifier<AsyncValue<String>> {
  QRCodeDataNotifier(this.contactService) : super(const AsyncValue.loading()) {
    _startTimer();
  }

  final Future<ContactService> contactService;
  Timer? _timer;

  Future<void> _fetchQrData() async {
    try {
      final service = await contactService;
      final qrData = await service.createContact();
      state = AsyncValue.data(qrData.toJsonString());
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
