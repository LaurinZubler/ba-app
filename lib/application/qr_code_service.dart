import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'contact_exchange_service.dart';

final qrCodeServiceProvider = Provider<QRCodeService>((ref) {
  return QRCodeService(
      contactExchangeService: ref.watch(contactExchangeServiceProvider)
  );
});


class QRCodeService {

  final ContractExchangeService contactExchangeService;

  QRCodeService({
    required this.contactExchangeService
  });

  createContactExchangeQrData() async {
    final contactExchange = await contactExchangeService.createContactExchange();
    return contactExchangeService.toJsonString(contactExchange);
  }

  handleQrData(String qrData) async {
    final contactExchange = await contactExchangeService.fromJsonString(qrData);
    //todo: save in storage :)
  }

}