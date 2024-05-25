import 'dart:typed_data';

import 'package:bls_signatures_ffi/bls_signatures_ffi.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/keyPair/key_pair_model.dart';

final blsServiceProvider = Provider<BLSService>((ref) {
  return BLSService();
});

class BLSService {
  createKeyPair() {
    // Example seed, used to generate private key. Always use
    // a secure RNG with sufficient entropy to generate a seed (at least 32 bytes).
    // todo: seed, where save?
    final seed = Uint8List.fromList(<int>[
      0, 50, 6, 244, 24, 199,1, 25, 52, 88, 192, 19,
      18, 12, 89, 6, 220, 18, 102, 58, 209, 82, 12,
      62, 89, 110, 182, 9, 44, 20, 254, 22
    ]);

    final scheme = PopSchemeMPL();
    final privateKey = scheme.keyGen(seed);
    final publicKey = privateKey.g1Element();
    final keyPair = KeyPair(privateKey: privateKey.serialize(), publicKey: publicKey.serialize());

    scheme.free();
    privateKey.free();
    publicKey.free();

    return keyPair;
  }

  sign(String messageString, List<Uint8List> privateKeysUint8List) {
    final scheme = PopSchemeMPL();
    final message = Uint8List.fromList(messageString.codeUnits);

    final privateKeys = privateKeysUint8List.map((key) => PrivateKey.fromBytes(data: key)).toList();
    final signatures = privateKeys.map((key) => scheme.sign(key, message)).toList();

    final signature = scheme.aggregateSigs(signatures);
    final signatureUint8List = signature.serialize();

    scheme.free();
    privateKeys.forEach((key) => key.free());
    signatures.forEach((signature) => signature.free());

    return signatureUint8List;
  }

  verify(Uint8List signatureUint8List, String messageString, List<Uint8List> publicKeysUint8List) {
    final scheme = PopSchemeMPL();
    final signature = G2Element.fromBytes(data: signatureUint8List);
    final message = Uint8List.fromList(messageString.codeUnits);
    final publicKeys = publicKeysUint8List.map((key) => G1Element.fromBytes(data: key)).toList();

    final isValid = scheme.fastAggregateVerify(publicKeys, message, signature);

    scheme.free();
    publicKeys.forEach((key) => key.free());
    signature.free();

    return isValid;
  }
}