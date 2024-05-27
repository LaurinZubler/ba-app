import 'package:ba_app/application/service/key_service.dart';
import 'package:ba_app/application/provider/contact_repository_provider.dart';
import 'package:ba_app/domain/contact/contact_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/i_contact_repository.dart';

final contactServiceProvider = FutureProvider<ContactService>((ref) async {
  final keyService = await ref.watch(keyServiceProvider.future);
  final contactRepository = await ref.watch(contactRepositoryProvider.future);
  return ContactService(
    keyService: keyService,
    contactRepository: contactRepository,
  );
});

class ContactService {
  final KeyService _keyService;
  final IContactRepository _contactRepository;

  ContactService({
    required KeyService keyService,
    required IContactRepository contactRepository,
  }) : _contactRepository = contactRepository, _keyService = keyService;

  Future<Contact> createContact() async {
    final publicKey = await _keyService.getPublicKey();
    final dateTime = DateTime.now().toUtc();
    return Contact(publicKey: publicKey, dateTime: dateTime);
  }

  Future<void> save(Contact contact) async {
    await _contactRepository.save(contact);
  }
}
