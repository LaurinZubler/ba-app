import 'package:ba_app/application/service/cryptography_service.dart';
import 'package:ba_app/domain/model/contact/contact_model.dart';

import '../../domain/repositories/i_contact_repository.dart';

class ContactService {
  final CryptographyService _cryptographyService;
  final IContactRepository _contactRepository;

  ContactService(this._cryptographyService, this._contactRepository);

  Future<Contact> createContact() async {
    final publicKey = await _cryptographyService.getPublicKey();
    final dateTime = DateTime.now().toUtc();
    return Contact(publicKey: publicKey, dateTime: dateTime);
  }

  Future<void> save(Contact contact) async {
    await _contactRepository.save(contact);
  }

  Future<bool> hasAnyByPublicKeyAndDateTimeAfter(String publicKey, DateTime cutOffDate) async {
    return _contactRepository.getAll().then((contacts) => contacts.any((c) => c.publicKey == publicKey && c.dateTime.isAfter(cutOffDate)));
  }
}
