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

  Future<String> createContactQrData() async {
    final contact = await contactService.createContact();
    return contact.toJsonString();
  }

  Future<void> handleQrData(String qrData) async {
    final contact = Contact.fromJsonString(qrData);

    final tenMinutesAgo = DateTime.now().toUtc().subtract(const Duration(minutes: 10));

    if (contact.dateTime.isBefore(tenMinutesAgo)) {
      // todo translation key
      throw const FormatException("QR code expired");
    }

    return contactService.save(contact);
  }
}