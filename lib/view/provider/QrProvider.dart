import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/ContactExchangeService.dart';

final qrProvider = StateNotifierProvider<QrNotifier, String>((ref) {
  return QrNotifier(
    contactExchangeService: ref.watch(contractExchangeServiceProvider)
  );
});

class QrNotifier extends StateNotifier<String> {

  final ContractExchangeService contactExchangeService;

  QrNotifier({
    required this.contactExchangeService
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
    final qr = await contactExchangeService.createContactExchange();
    state = qr;
  }
}
