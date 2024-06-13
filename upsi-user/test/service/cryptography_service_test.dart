import 'package:upsi_core/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:upsi_core/application/dto/proofOfAttendance/proof_of_attendance_dto.dart';
import 'package:upsi_core/global.dart';
import 'package:upsi_core/application/service/bls_service.dart';
import 'package:upsi_user/application/service/cryptography_service.dart';
import 'package:upsi_user/data/repository/key_repository.dart';
import 'package:upsi_core/domain/model/keyPair/key_pair_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cryptography_service_test.mocks.dart';

@GenerateMocks([BLSService, KeyRepository])
void main() {
  late MockBLSService mockBLSService;
  late MockKeyRepository mockKeyRepository;
  late CryptographyService cryptographyService;

  setUp(() {
    mockBLSService = MockBLSService();
    mockKeyRepository = MockKeyRepository();
    cryptographyService = CryptographyService(mockBLSService, mockKeyRepository);
  });

  group('getPublicKey()', () {
    test('get from store - save', () async {
      final keyPair = KeyPair(publicKey: 'publicKey', privateKey: 'privateKey', creationDate: DateTime.now().toUtc());

      when(mockKeyRepository.getAll()).thenAnswer((_) async => [keyPair]);

      var publicKey = await cryptographyService.getPublicKey();
      expect(publicKey, keyPair.publicKey);
      verify(mockKeyRepository.getAll()).called(1);

      publicKey = await cryptographyService.getPublicKey();
      expect(publicKey, keyPair.publicKey);
      verify(mockKeyRepository.getAll()).called(1);
      verifyNever(mockKeyRepository.save(any));
      verifyNever(mockBLSService.createKeyPair());
    });

    test('get from store - not expired', () async {
      final notExpired = DateTime.now().toUtc().subtract(Global.KEY_EXPIRE_DURATION).add(const Duration(seconds: 1));
      final keyPair = KeyPair(publicKey: 'publicKey', privateKey: 'privateKey', creationDate: notExpired);

      when(mockKeyRepository.getAll()).thenAnswer((_) async => [keyPair]);

      final publicKey = await cryptographyService.getPublicKey();
      expect(publicKey, keyPair.publicKey);
      verify(mockKeyRepository.getAll()).called(1);
      verifyNever(mockKeyRepository.save(any));
      verifyNever(mockBLSService.createKeyPair());
    });

    test('get from store - multiple', () async {
      final keyPair1 = KeyPair(publicKey: 'publicKey1', privateKey: 'privateKey1', creationDate: DateTime.now().toUtc());
      final keyPair2 = KeyPair(publicKey: 'publicKey2', privateKey: 'privateKey2', creationDate: DateTime.now().toUtc());

      when(mockKeyRepository.getAll()).thenAnswer((_) async => [keyPair1, keyPair2]);

      final publicKey = await cryptographyService.getPublicKey();
      expect(publicKey, keyPair2.publicKey);
      verify(mockKeyRepository.getAll()).called(1);
      verifyNever(mockKeyRepository.save(any));
      verifyNever(mockBLSService.createKeyPair());
    });

    test('crete new - empty store', () async {
      final keyPair = KeyPair(publicKey: 'publicKey', privateKey: 'privateKey', creationDate: DateTime.now().toUtc());

      when(mockKeyRepository.getAll()).thenAnswer((_) async => []);
      when(mockBLSService.createKeyPair()).thenReturn(keyPair);

      final publicKey = await cryptographyService.getPublicKey();
      expect(publicKey, keyPair.publicKey);
      verify(mockKeyRepository.getAll()).called(1);
      verify(mockKeyRepository.save(any)).called(1);
      verify(mockBLSService.createKeyPair()).called(1);
    });

    test('create new - expired', () async {
      final expired = DateTime.now().toUtc().subtract(Global.KEY_EXPIRE_DURATION).subtract(const Duration(seconds: 1));
      final keyPair1 = KeyPair(publicKey: 'publicKey1', privateKey: 'privateKey1', creationDate: expired);
      final keyPair2 = KeyPair(publicKey: 'publicKey2', privateKey: 'privateKey2', creationDate: expired);
      final keyPair3 = KeyPair(publicKey: 'publicKey3', privateKey: 'privateKey3', creationDate: DateTime.now().toUtc());

      when(mockKeyRepository.getAll()).thenAnswer((_) async => [keyPair1, keyPair2]);
      when(mockBLSService.createKeyPair()).thenReturn(keyPair3);

      final publicKey = await cryptographyService.getPublicKey();
      expect(publicKey, keyPair3.publicKey);
      verify(mockKeyRepository.getAll()).called(1);
      verify(mockKeyRepository.save(any)).called(1);
      verify(mockBLSService.createKeyPair()).called(1);
    });
  });

  group('createInfectionEvent()', () {
    test('success', () async {
      List<KeyPair> keys = [];

      for(int i = 0; i < Global.NUMBER_KEYS_IN_INFECTION_QR; i++) {
        keys.add(KeyPair(publicKey: 'publicKey$i', privateKey: 'privateKey$i', creationDate: DateTime.now().toUtc()));
      }

      final poa = ProofOfAttendance(tester: "tester", testTime: DateTime.now().toUtc());
      final expectedInfectionEvent = InfectionEvent(infectee: keys.map((k) => k.publicKey).toList(), signature: "signature", infection: '', tester: poa.tester, testTime: poa.testTime);

      when(mockBLSService.sign(any, any)).thenReturn("signature");
      when(mockKeyRepository.getAll()).thenAnswer((_) async => keys);

      final signedPoA = await cryptographyService.createInfectionEvent(poa);
      expect(signedPoA, expectedInfectionEvent);
      verify(mockKeyRepository.getAll()).called(1);
      verify(mockBLSService.sign(any, any)).called(1);
      verifyNever(mockBLSService.createKeyPair());
      verifyNever(mockKeyRepository.save(any));
    });

    test('add 1 key', () async {
      final newKeyPair = KeyPair(privateKey: "newPrivateKey", publicKey: "newPublicKey", creationDate: DateTime.now().toUtc());

      List<KeyPair> keys = [];
      for(int i = 0; i < Global.NUMBER_KEYS_IN_INFECTION_QR - 1; i++) {
        keys.add(KeyPair(publicKey: 'publicKey$i', privateKey: 'privateKey$i', creationDate: DateTime.now().toUtc()));
      }

      final poa = ProofOfAttendance(tester: "tester", testTime: DateTime.now().toUtc());
      final expectedPublicKeys = keys.map((k) => k.publicKey).toList();
      expectedPublicKeys.add(newKeyPair.publicKey);
      final expectedInfectionEvent = InfectionEvent(infectee: expectedPublicKeys, signature: "signature", infection: '', tester: poa.tester, testTime: poa.testTime);

      when(mockBLSService.sign(any, any)).thenReturn("signature");
      when(mockBLSService.createKeyPair()).thenReturn(newKeyPair);
      when(mockKeyRepository.getAll()).thenAnswer((_) async => keys);

      final signedPoA = await cryptographyService.createInfectionEvent(poa);
      expect(signedPoA.infectee, expectedInfectionEvent.infectee);
      expect(signedPoA.infectee.where((key) => key == newKeyPair.publicKey).length, 1);

      verify(mockKeyRepository.getAll()).called(1);
      verify(mockBLSService.sign(any, any)).called(1);
      verify(mockKeyRepository.save(any)).called(1);
      verify(mockBLSService.createKeyPair()).called(1);
    });

    test('add 2 keys', () async {

      if(Global.NUMBER_KEYS_IN_INFECTION_QR < 2) {
        return;
      }

      List<KeyPair> keys = [];
      final newKeyPair = KeyPair(privateKey: "newPrivateKey", publicKey: "newPublicKey", creationDate: DateTime.now().toUtc());

      for(int i = 0; i < Global.NUMBER_KEYS_IN_INFECTION_QR - 2; i++) {
        keys.add(KeyPair(publicKey: 'publicKey$i', privateKey: 'privateKey$i', creationDate: DateTime.now().toUtc()));
      }

      final poa = ProofOfAttendance(tester: "tester", testTime: DateTime.now().toUtc());
      final expectedPublicKeys = keys.map((k) => k.publicKey).toList();
      expectedPublicKeys.addAll([newKeyPair.publicKey, newKeyPair.publicKey]);
      final expectedInfectionEvent = InfectionEvent(infectee: expectedPublicKeys, signature: "signature", infection: '', tester: poa.tester, testTime: poa.testTime);

      when(mockBLSService.sign(any, any)).thenReturn("signature");
      when(mockBLSService.createKeyPair()).thenReturn(newKeyPair);
      when(mockKeyRepository.getAll()).thenAnswer((_) async => keys);

      final signedPoA = await cryptographyService.createInfectionEvent(poa);
      expect(signedPoA.infectee, expectedInfectionEvent.infectee);
      expect(signedPoA.infectee.where((key) => key == newKeyPair.publicKey).length, 2);

      verify(mockKeyRepository.getAll()).called(1);
      verify(mockBLSService.sign(any, any)).called(1);
      verify(mockKeyRepository.save(any)).called(2);
      verify(mockBLSService.createKeyPair()).called(2);
    });

    test('remove key', () async {
      List<KeyPair> keys = [];

      for(int i = 0; i < Global.NUMBER_KEYS_IN_INFECTION_QR + 1; i++) {
        keys.add(KeyPair(publicKey: 'publicKey$i', privateKey: 'privateKey$i', creationDate: DateTime.now().toUtc()));
      }

      final poa = ProofOfAttendance(tester: "tester", testTime: DateTime.now().toUtc());
      final expectedPublicKeys = keys.map((k) => k.publicKey).toList();
      expectedPublicKeys.removeWhere((k) => k == keys.first.publicKey);
      final expectedInfectionEvent = InfectionEvent(infectee: expectedPublicKeys, signature: "signature", infection: '', tester: poa.tester, testTime: poa.testTime);

      when(mockBLSService.sign(any, any)).thenReturn("signature");
      when(mockKeyRepository.getAll()).thenAnswer((_) async => keys);

      final signedPoA = await cryptographyService.createInfectionEvent(poa);

      expect(signedPoA.infectee, expectedInfectionEvent.infectee);
      expect(signedPoA.infectee.where((key) => key == "publicKey0").length, 0);

      verify(mockKeyRepository.getAll()).called(1);
      verify(mockBLSService.sign(any, any)).called(1);
      verifyNever(mockBLSService.createKeyPair());
      verifyNever(mockKeyRepository.save(any));
    });
  });
}
