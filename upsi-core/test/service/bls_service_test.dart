import 'package:upsi_core/application/service/bls_service.dart';
import 'package:upsi_core/domain/model/keyPair/key_pair_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chia_crypto_utils/chia_crypto_utils.dart';

void main() {
  late BLSService blsService;

  setUp(() {
    final container = ProviderContainer();
    blsService = container.read(blsServiceProvider);
  });

  group('createKeyPair()', () {
    test('success', () {
      final keyPair = blsService.createKeyPair();

      expect(keyPair.privateKey, isNotNull);
      expect(keyPair.publicKey, isNotNull);

      final privateKey = PrivateKey.fromHex(keyPair.privateKey);
      final publicKey = JacobianPoint.fromHexG1(keyPair.publicKey);

      expect(publicKey.isValid, isTrue);
      expect(privateKey.toHex(), keyPair.privateKey);
      expect(publicKey.toHexWithPrefix(), keyPair.publicKey);
    });

    test('different every time', () {
      final keyPair1 = blsService.createKeyPair();
      final keyPair2 = blsService.createKeyPair();
      expect(keyPair1.privateKey == keyPair2.privateKey, isFalse);
      expect(keyPair1.publicKey == keyPair2.publicKey, isFalse);
    });
  });

  group('sign()', () {
    test('success', () {
      const message = "Uhhh, yeah! Sign me please!";
      final List<KeyPair> keyPairs = [];

      for (int i = 0; i < 10; i++) {
        keyPairs.add(blsService.createKeyPair());
      }

      final privateKeys = keyPairs.map((key) => key.privateKey).toList();
      final signature = blsService.sign(message, privateKeys);
      expect(signature, isNotNull);
    });
  });

  group('verify()', () {
    test('success', () {
      const message = "Uhhh, yeah! Sign me please!";
      final List<KeyPair> keyPairs = [];

      for (int i = 0; i < 10; i++) {
        keyPairs.add(blsService.createKeyPair());
      }

      final privateKeys = keyPairs.map((key) => key.privateKey).toList();
      final publicKeys = keyPairs.map((key) => key.publicKey).toList();
      final signature = blsService.sign(message, privateKeys);
      expect(signature, isNotNull);

      final isValid = blsService.verify(signature, message, publicKeys);
      expect(isValid, isTrue);
    });

    test('wrong signature', () {
      const message = "Uhhh, yeah! Sign me please!";
      final List<KeyPair> keyPairs = [];

      for (int i = 0; i < 10; i++) {
        keyPairs.add(blsService.createKeyPair());
      }

      final privateKeys = keyPairs.map((key) => key.privateKey).toList();
      final publicKeys = keyPairs.map((key) => key.publicKey).toList();
      final signature = blsService.sign(message, privateKeys);
      expect(signature, isNotNull);

      var isValid = blsService.verify(signature, message, publicKeys);
      expect(isValid, isTrue);

      final List<String> otherPrivateKeys = [];
      for (int i = 0; i < 10; i++) {
        otherPrivateKeys.add(blsService
            .createKeyPair()
            .privateKey);
      }

      var otherSignature = blsService.sign(message, otherPrivateKeys);
      expect(signature == otherSignature, isFalse);

      isValid = blsService.verify(otherSignature, message, publicKeys);
      expect(isValid, isFalse);
    });

    test('wrong message', () {
      const message = "Uhhh, yeah! Sign me please!";
      final List<KeyPair> keyPairs = [];

      for (int i = 0; i < 10; i++) {
        keyPairs.add(blsService.createKeyPair());
      }

      final privateKeys = keyPairs.map((key) => key.privateKey).toList();
      final publicKeys = keyPairs.map((key) => key.publicKey).toList();
      final signature = blsService.sign(message, privateKeys);
      expect(signature, isNotNull);

      var isValid = blsService.verify(signature, message, publicKeys);
      expect(isValid, isTrue);

      var otherMessage = "Ohhh no! I'm the wrong message";
      expect(otherMessage == message, isFalse);

      isValid = blsService.verify(signature, otherMessage, publicKeys);
      expect(isValid, isFalse);
    });

    test('wrong public keys', () {
      const message = "Uhhh, yeah! Sign me please!";
      final List<KeyPair> keyPairs = [];

      for (int i = 0; i < 10; i++) {
        keyPairs.add(blsService.createKeyPair());
      }

      final privateKeys = keyPairs.map((key) => key.privateKey).toList();
      final publicKeys = keyPairs.map((key) => key.publicKey).toList();
      final signature = blsService.sign(message, privateKeys);
      expect(signature, isNotNull);

      var isValid = blsService.verify(signature, message, publicKeys);
      expect(isValid, isTrue);


      final List<String> otherPublicKeys = [];
      for (int i = 0; i < 10; i++) {
        otherPublicKeys.add(blsService
            .createKeyPair()
            .publicKey);
      }

      isValid = blsService.verify(signature, message, otherPublicKeys);
      expect(isValid, isFalse);
    });
  });
}
