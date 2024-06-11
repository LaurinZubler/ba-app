import 'package:upsi_core/domain/model/keyPair/key_pair_model.dart';
import 'package:upsi_core/global.dart';
import 'package:upsi_core/application/service/bls_service.dart';
import 'package:upsi_user/domain/repository/i_key_repository.dart';
import 'package:upsi_core/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:upsi_core/application/dto/proofOfAttendance/proof_of_attendance_dto.dart';

class CryptographyService {
  final BLSService _blsService;
  final IKeyRepository _keyRepository;

  CryptographyService(this._blsService, this._keyRepository);

  Future<String> getPublicKey() async {
    var latestKey = await _fetchLatestKey();
    if(_isExpired(latestKey)) {
      latestKey = await _createNewKey();
    }
    return latestKey.publicKey;
  }

  Future<InfectionEvent> createInfectionEvent(ProofOfAttendance poa) async {
    final keys = await _getKeys();
    final privateKeys = keys.map((key) => key.privateKey).toList();
    final publicKeys = keys.map((key) => key.publicKey).toList();
    final signature = _blsService.sign(poa.message, privateKeys);
    return InfectionEvent(infectee: publicKeys, signature: signature, infection: '', tester: poa.tester, testTime: poa.testTime);
  }

  bool verifyInfectionEvent(InfectionEvent event) {
    return _blsService.verify(event.signature, event.poa, event.infectee);
  }

  Future<KeyPair> _fetchLatestKey() async {
    final keys = await _keyRepository.getAll();
    KeyPair? key = keys.lastOrNull;
    key ??= await _createNewKey();
    return key;
  }

  bool _isExpired(KeyPair key) {
    final cutOffDate = DateTime.now().toUtc().subtract(Global.KEY_EXPIRE_DURATION);
    return key.creationDate.isBefore(cutOffDate);
  }

  Future<KeyPair> _createNewKey() async {
    final key = _blsService.createKeyPair();
    await _keyRepository.save(key);
    return key;
  }

  Future<List<KeyPair>> _getKeys() async {
    final keys = await _keyRepository.getAll();

    for (int i = keys.length; i < Global.NUMBER_KEYS_IN_INFECTION_EVENT; i++) {
      final key = await _createNewKey();
      keys.add(key);
    }

    if (keys.length > Global.NUMBER_KEYS_IN_INFECTION_EVENT) {
      keys.removeRange(0, keys.length - Global.NUMBER_KEYS_IN_INFECTION_EVENT);
    }

    return keys;
  }
}
