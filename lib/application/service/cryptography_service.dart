import 'package:ba_app/application/service/bls_service.dart';
import 'package:ba_app/application/provider/key_repository_provider.dart';
import 'package:ba_app/domain/i_key_repository.dart';
import 'package:ba_app/domain/proofOfAttendance/proof_of_attendance_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/keyPair/key_pair_model.dart';

const KEY_EXPIRE_DURATION = Duration(days: 30);
const NUMBER_KEYS_IN_POA = 12;

final cryptographyServiceProvider = FutureProvider<CryptographyService>((ref) async {
  final keyRepository = await ref.watch(keyRepositoryProvider.future);
  final blsService = ref.watch(blsServiceProvider);
  return CryptographyService(
    blsService: blsService,
    keyRepository: keyRepository,
  );
});

//todo: test!
class CryptographyService {
  KeyPair? _key;

  final BLSService _blsService;
  final IKeyRepository _keyRepository;

  CryptographyService({
    required BLSService blsService,
    required IKeyRepository keyRepository,
  }) : _keyRepository = keyRepository, _blsService = blsService;

  Future<String> getPublicKey() async {
    _key ??= await _fetchLatestKey();
    if(_isExpired(_key!)) {
      _key = await _createNewKey();
    }
    return _key!.publicKey;
  }

  Future<KeyPair> _fetchLatestKey() async {
    final keys = await _keyRepository.getAll();
    KeyPair? key = keys.lastOrNull;
    key ??= await _createNewKey();
    return key;
  }

  bool _isExpired(KeyPair key) {
    final cutOffDate = DateTime.now().toUtc().subtract(KEY_EXPIRE_DURATION);
    return key.creationDate.isBefore(cutOffDate);
  }

  Future<KeyPair> _createNewKey() async {
    final key = await _blsService.createKeyPair();
    await _keyRepository.save(key);
    return key;
  }

  Future<ProofOfAttendance> signProofOfAttendance(ProofOfAttendance poa) async {
    final keys = await _getKeys();
    final privateKeys = keys.map((key) => key.privateKey).toList();
    final publicKeys = keys.map((key) => key.publicKey).toList();
    final signature = await _blsService.sign(poa.message, privateKeys);
    return poa.copyWith(publicKeys: publicKeys, signature: signature);
  }

  Future<List<KeyPair>> _getKeys() async {
    final keys = await _keyRepository.getAll();

    for (int i = keys.length; i < NUMBER_KEYS_IN_POA; i++) {
      final key = await _createNewKey();
      keys.add(key);
    }

    if (keys.length > NUMBER_KEYS_IN_POA) {
      keys.removeRange(0, keys.length - NUMBER_KEYS_IN_POA); //TODO: untested :/
    }

    return keys;
  }

  Future<bool> verifyProofOfAttendance(ProofOfAttendance poa) async {
    return _blsService.verify(poa.signature, poa.message, poa.publicKeys);
  }
}
