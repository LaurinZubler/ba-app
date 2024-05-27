import 'package:ba_app/application/service/cryptography_service.dart';
import 'package:ba_app/application/provider/contact_repository_provider.dart';
import 'package:ba_app/domain/contact/contact_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/i_contact_repository.dart';

const CONTACT_EXPIRE_DURATION = Duration(seconds: 10);

final contactServiceProvider = FutureProvider<ContactService>((ref) async {
  final cryptographyService = await ref.watch(cryptographyServiceProvider.future);
  final contactRepository = await ref.watch(contactRepositoryProvider.future);
  return ContactService(
    cryptographyService: cryptographyService,
    contactRepository: contactRepository,
  );
});

class ContactService {
  final CryptographyService _cryptographyService;
  final IContactRepository _contactRepository;

  ContactService({
    required CryptographyService cryptographyService,
    required IContactRepository contactRepository,
  }) : _contactRepository = contactRepository, _cryptographyService = cryptographyService;

  Future<Contact> createContact() async {
    final publicKey = await _cryptographyService.getPublicKey();
    final dateTime = DateTime.now().toUtc();
    return Contact(publicKey: publicKey, dateTime: dateTime);
  }

  Future<void> save(Contact contact) async {
    final qrExpireDateTime = DateTime.now().toUtc().subtract(CONTACT_EXPIRE_DURATION);

    if (contact.dateTime.isBefore(qrExpireDateTime)) {
      // todo translation key
      throw const FormatException("QR code expired");
    }

    await _contactRepository.save(contact);
  }
}
