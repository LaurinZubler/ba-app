import 'dart:typed_data';

import 'package:ba_app/application/bls_service.dart';
import 'package:ba_app/domain/keyPair/key_pair_model.dart';
import 'package:bls_signatures_ffi/bls_signatures_ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  late BLSService blsService;

  setUp(() {
    final container = ProviderContainer();
    blsService = container.read(blsServiceProvider);
  });

  test('createKeyPair() - success', () {
    final keyPair = blsService.createKeyPair();

    expect(keyPair.privateKey, isNotNull);
    expect(keyPair.publicKey, isNotNull);

    final privateKey = PrivateKey.fromBytes(data: keyPair.privateKey);
    final publicKey = G1Element.fromBytes(data: keyPair.publicKey);

    expect(publicKey.isValid(), isTrue);
    expect(privateKey.serialize(), keyPair.privateKey);
    expect(publicKey.serialize(), keyPair.publicKey);
  });

  test('createKeyPair() - different every time', () {
    final keyPair = blsService.createKeyPair();

    expect(keyPair.privateKey, isNotNull);
    expect(keyPair.publicKey, isNotNull);

    final privateKey1 = PrivateKey.fromBytes(data: keyPair.privateKey);
    final publicKey1 = G1Element.fromBytes(data: keyPair.publicKey);

    expect(publicKey1.isValid(), isTrue);
    expect(privateKey1.serialize(), keyPair.privateKey);
    expect(publicKey1.serialize(), keyPair.publicKey);

    final privateKey2 = PrivateKey.fromBytes(data: keyPair.privateKey);
    final publicKey2 = G1Element.fromBytes(data: keyPair.publicKey);

    expect(publicKey2.isValid(), isTrue);
    expect(privateKey2.serialize(), keyPair.privateKey);
    expect(publicKey2.serialize(), keyPair.publicKey);

    expect(privateKey1 == privateKey2, isFalse);
    expect(publicKey1 == publicKey2, isFalse);
  });

  test('sign() - success', () {
    const message = "Uhhh, yeah! Sign me please!";
    final List<KeyPair> keyPairs = [];
    
    for(int i = 0; i < 10; i++) {
      keyPairs.add(blsService.createKeyPair());
    }
    
    final privateKeys = keyPairs.map((key) => key.privateKey).toList();
    final signature = blsService.sign(message, privateKeys);
    
    expect(signature, isNotNull);
  });

  test('verify() - success', () {
    const message = "Uhhh, yeah! Sign me please!";
    final List<KeyPair> keyPairs = [];

    for(int i = 0; i < 10; i++) {
      keyPairs.add(blsService.createKeyPair());
    }

    final privateKeys = keyPairs.map((key) => key.privateKey).toList();
    final publicKeys = keyPairs.map((key) => key.publicKey).toList();
    final signature = blsService.sign(message, privateKeys);
    expect(signature, isNotNull);

    final isValid = blsService.verify(signature, message, publicKeys);
    expect(isValid, isTrue);
  });

  test('verify() - wrong signature', () {
    const message = "Uhhh, yeah! Sign me please!";
    final List<KeyPair> keyPairs = [];

    for(int i = 0; i < 10; i++) {
      keyPairs.add(blsService.createKeyPair());
    }

    final privateKeys = keyPairs.map((key) => key.privateKey).toList();
    final publicKeys = keyPairs.map((key) => key.publicKey).toList();
    final signature = blsService.sign(message, privateKeys);

    expect(signature, isNotNull);

    var isValid = blsService.verify(signature, message, publicKeys);
    expect(isValid, isTrue);

    signature[0] = signature[0] + 1;

    isValid = blsService.verify(signature, message, publicKeys);
    expect(isValid, isFalse);
  });

  test('verify() - wrong message', () {
    var message = "Uhhh, yeah! Sign me please!";
    final List<KeyPair> keyPairs = [];

    for(int i = 0; i < 10; i++) {
      keyPairs.add(blsService.createKeyPair());
    }

    final privateKeys = keyPairs.map((key) => key.privateKey).toList();
    final publicKeys = keyPairs.map((key) => key.publicKey).toList();
    final signature = blsService.sign(message, privateKeys);

    expect(signature, isNotNull);

    var isValid = blsService.verify(signature, message, publicKeys);
    expect(isValid, isTrue);

    message = "Ohhh no! I am the wrong message!";

    isValid = blsService.verify(signature, message, publicKeys);
    expect(isValid, isFalse);
  });

  test('verify() - wrong public keys', () {
    const message = "Uhhh, yeah! Sign me please!";
    final List<KeyPair> keyPairs = [];

    for(int i = 0; i < 10; i++) {
      keyPairs.add(blsService.createKeyPair());
    }

    final privateKeys = keyPairs.map((key) => key.privateKey).toList();
    final publicKeys = keyPairs.map((key) => key.publicKey).toList();
    final signature = blsService.sign(message, privateKeys);

    expect(signature, isNotNull);

    var isValid = blsService.verify(signature, message, publicKeys);
    expect(isValid, isTrue);

    publicKeys[0] = (publicKeys[0][0] + 1) as Uint8List;

    isValid = blsService.verify(signature, message, publicKeys);
    expect(isValid, isFalse);
  });
}
