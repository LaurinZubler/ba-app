import 'package:ba_app/domain/contactExchange/contact_exchange_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'contact_service.dart';

final qrCodeServiceProvider = Provider<QRCodeService>((ref) {
  return QRCodeService(
      contactService: ref.watch(contactServiceProvider)
  );
});


class QRCodeService {

  final ContractService contactService;

  QRCodeService({
    required this.contactService
  });

  createContactExchangeQrData() async {
    final contactExchange = await contactService.createContactExchange();
    return contactService.toJsonString(contactExchange);
  }

  handleQrData(String qrData) async {
    final contactExchange = await contactService.fromJsonString(qrData) as ContactExchange;

    final tenMinutesAgo = DateTime.now().toUtc().subtract(const Duration(minutes: 10));

    if (contactExchange.dateTime.isBefore(tenMinutesAgo)) {
      // todo translation key
      throw const FormatException("QR code expired");
    }
    //todo: save in storage :)
  }

}