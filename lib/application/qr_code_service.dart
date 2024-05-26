import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/contact/contact_model.dart';
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

  createContactQrData() async {
    final contact = await contactService.createContact();
    return contactService.toJsonString(contact);
  }

  handleQrData(String qrData) async {
    final contact = await contactService.fromJsonString(qrData) as Contact;

    final tenMinutesAgo = DateTime.now().toUtc().subtract(const Duration(minutes: 10));

    if (contact.dateTime.isBefore(tenMinutesAgo)) {
      // todo translation key
      throw const FormatException("QR code expired");
    }
    //todo: save in storage :)
  }

}