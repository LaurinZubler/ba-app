import 'package:ba_app/application/service/key_service.dart';
import 'package:ba_app/application/provider/contact_repository_provider.dart';
import 'package:ba_app/domain/contact/contact_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/i_contact_repository.dart';

final contactServiceProvider = Provider<ContractService>((ref) {
  return ContractService(
    keyService: ref.watch(keyServiceProvider),
    contactRepository: ref.watch(contactRepositoryProvider).requireValue,
  );
});

class ContractService {
  final KeyService keyService;
  final IContactRepository contactRepository;

  ContractService({
    required this.keyService,
    required this.contactRepository,
  });

  Future<Contact> createContact() async {
    final publicKey = await keyService.getPublicKey();
    final dateTime = DateTime.now().toUtc();
    return Contact(publicKey: publicKey, dateTime: dateTime);
  }

  Future<void> save(Contact contact) async {
    await contactRepository.save(contact);
  }
}
