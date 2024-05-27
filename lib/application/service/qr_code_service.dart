import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/contact/contact_model.dart';
import 'contact_service.dart';

const QR_EXPIRE_DURATION = Duration(seconds: 10);

final qrCodeServiceProvider = FutureProvider<QRCodeService>((ref) async {
  final contactService = await ref.watch(contactServiceProvider.future);
  return QRCodeService(
    contactService: contactService,
  );
});

class QRCodeService {
  final ContactService _contactService;

  QRCodeService({
    required ContactService contactService
  }) : _contactService = contactService;

  Future<String> createContactQrData() async {
    final contact = await _contactService.createContact();
    return contact.toJsonString();
  }

  Future<void> handleQrData(String qrData) async {
    final contact = Contact.fromJsonString(qrData);

    final qrExpireDateTime = DateTime.now().toUtc().subtract(QR_EXPIRE_DURATION);

    if (contact.dateTime.isBefore(qrExpireDateTime)) {
      // todo translation key
      throw const FormatException("QR code expired");
    }

    return _contactService.save(contact);
  }
}