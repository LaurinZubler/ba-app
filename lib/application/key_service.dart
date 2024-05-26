import 'package:ba_app/application/bls_service.dart';
import 'package:ba_app/application/provider/key_repository_provider.dart';
import 'package:ba_app/domain/i_key_repository.dart';
import 'package:ba_app/domain/proofOfAttendance/proof_of_attendance_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/keyPair/key_pair_model.dart';

final keyServiceProvider = Provider<KeyService>((ref) {
  return KeyService(
    blsService: ref.watch(blsServiceProvider),
    keyRepository: ref.watch(keyRepositoryProvider).requireValue
  );
});

//todo: test!
class KeyService {
  final BLSService blsService;
  final IKeyRepository keyRepository;

  Duration KEY_EXPIRE_DURATION = const Duration(days: 30);
  int NUMBER_KEYS_IN_POA = 12;

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

  Future<ProofOfAttendance> signProofOfAttendance(ProofOfAttendance poa) async {
    final keys = await _getKeys();
    final privateKeys = keys.map((key) => key.privateKey).toList();
    final publicKeys = keys.map((key) => key.publicKey).toList();
    final signature = await blsService.sign(poa.message, privateKeys);
    return poa.copyWith(publicKeys: publicKeys, signature: signature);
  }

  Future<List<KeyPair>> _getKeys() async {
    final keys = await keyRepository.getAll();

    for(int i = keys.length; i < NUMBER_KEYS_IN_POA; i++) {
      final key = await _createNewKey();
      keys.add(key);
    }

    if (keys.length > NUMBER_KEYS_IN_POA) {
      keys.removeRange(0, keys.length - NUMBER_KEYS_IN_POA); //TODO: untested :/
    }

    return keys;
  }

  Future<bool> verifyProofOfAttendance(ProofOfAttendance poa) async {
    return blsService.verify(poa.signature, poa.message, poa.publicKeys);
  }
}