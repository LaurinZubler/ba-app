import 'package:ba_app/application/bls_service.dart';
import 'package:ba_app/application/provider/key_repository_provider.dart';
import 'package:ba_app/domain/i_key_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/keyPair/key_pair_model.dart';

final keyServiceProvider = Provider<KeyService>((ref) {
  return KeyService(
    blsService: ref.watch(blsServiceProvider),
    keyRepository: ref.watch(keyRepositoryProvider).requireValue
  );
});


class KeyService {
  final BLSService blsService;
  final IKeyRepository keyRepository;

  Duration KEY_EXPIRE_DURATION = const Duration(days: 30);

  KeyService({
    required this.blsService,
    required this.keyRepository
  });

  Future<String> getPublicKey() async{
    final keys = await keyRepository.getAll();
    KeyPair? key = keys.lastOrNull;

    if (key == null || _isExpired(key)) {
      key = await _createNewKey();
    }

    return key.publicKey;
  }

  bool _isExpired(KeyPair key){
    final cutOffDate = DateTime.now().toUtc().subtract(KEY_EXPIRE_DURATION);
    return key.creationDate.isBefore(cutOffDate);
  }

  Future<KeyPair> _createNewKey() async {
    final key = await blsService.createKeyPair();
    await keyRepository.save(key);
    return key;
  }

}