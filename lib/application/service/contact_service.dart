import 'package:ba_app/application/service/cryptography_service.dart';
import 'package:ba_app/domain/contact/contact_model.dart';

import '../../domain/i_contact_repository.dart';


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
    return _contactRepository.save(contact);
  }
}
