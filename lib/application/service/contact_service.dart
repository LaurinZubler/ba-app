import 'package:ba_app/application/service/cryptography_service.dart';
import 'package:ba_app/domain/contact/contact_model.dart';

import '../../domain/i_contact_repository.dart';


class ContactService {
  List<Contact>? _contacts;
  final CryptographyService _cryptographyService;
  final IContactRepository _contactRepository;

  ContactService(this._cryptographyService, this._contactRepository);

  Future<Contact> createContact() async {
    final publicKey = await _cryptographyService.getPublicKey();
    final dateTime = DateTime.now().toUtc();
    return Contact(publicKey: publicKey, dateTime: dateTime);
  }

  Future<void> save(Contact contact) async {
    final contacts = await getAll();
    contacts.add(contact);
    await _contactRepository.save(contact);
  }

  Future<List<Contact>> getAll() async {
    _contacts ??= await _contactRepository.getAll();
    return _contacts!;
  }

  Future<bool> hasAnyByPublicKeyAndDateTimeAfter(String publicKey, DateTime cutOffDate) async {
    return getAll().then((contacts) => contacts.any((c) => c.publicKey == publicKey && c.dateTime.isAfter(cutOffDate)));
  }
}
