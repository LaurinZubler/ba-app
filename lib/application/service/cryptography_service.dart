import 'package:ba_app/application/service/bls_service.dart';
import 'package:ba_app/datasource/persistance/repository/i_key_repository.dart';
import 'package:ba_app/domain/model/proofOfAttendance/proof_of_attendance_model.dart';

import '../../domain/model/infectionEvent/infection_event_model.dart';
import '../../domain/model/keyPair/key_pair_model.dart';

const KEY_EXPIRE_DURATION = Duration(days: 365*100);
const NUMBER_KEYS_IN_POA = 1;

class CryptographyService {
  KeyPair? _key;

  final BLSService _blsService;
  final IKeyRepository _keyRepository;

  CryptographyService(this._blsService, this._keyRepository);

  Future<String> getPublicKey() async {
    _key ??= await _fetchLatestKey();
    if(_isExpired(_key!)) {
      _key = await _createNewKey();
    }
    return _key!.publicKey;
  }

  Future<InfectionEvent> createInfectionEvent(ProofOfAttendance poa) async {
    final keys = await _getKeys();
    final privateKeys = keys.map((key) => key.privateKey).toList();
    final publicKeys = keys.map((key) => key.publicKey).toList();
    final signature = _blsService.sign(poa.message, privateKeys);
    return InfectionEvent(infectee: publicKeys, signature: signature, infection: '', tester: poa.tester, testTime: poa.testTime);
  }

  Future<bool> verifyInfectionEvent(InfectionEvent event) async {
    return _blsService.verify(event.signature, event.poa, event.infectee);
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
    final key = _blsService.createKeyPair();
    await _keyRepository.save(key);
    return key;
  }

  Future<List<KeyPair>> _getKeys() async {
    final keys = await _keyRepository.getAll();

    for (int i = keys.length; i < NUMBER_KEYS_IN_POA; i++) {
      final key = await _createNewKey();
      keys.add(key);
    }

    if (keys.length > NUMBER_KEYS_IN_POA) {
      keys.removeRange(0, keys.length - NUMBER_KEYS_IN_POA);
    }

    return keys;
  }
}
