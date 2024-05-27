import 'package:chia_crypto_utils/chia_crypto_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/keyPair/key_pair_model.dart';

final blsServiceProvider = Provider<BLSService>((ref) {
  return BLSService();
});

class BLSService {
  createKeyPair() {
    final privateKey = PrivateKey.generate();
    final publicKey = privateKey.getG1();
    return KeyPair(privateKey: privateKey.toHex(), publicKey: publicKey.toHexWithPrefix(), creationDate: DateTime.now().toUtc());
  }
  sign(String message, List<String> privateKeysHex) {
    final messageCodeUnits = message.codeUnits;
    final privateKeys = privateKeysHex.map((key) => PrivateKey.fromHex(key));
    final signatures = privateKeys.map((key) => PopSchemeMPL.sign(key, messageCodeUnits)).toList();
    final signature = PopSchemeMPL.aggregate(signatures);
    return signature.toHexWithPrefix();
  }

  verify(String signature, String message, List<String> publicKeysHex) {
    final messageCodeUnits = message.codeUnits;
    final signatureJacobianPoint = JacobianPoint.fromHexG2(signature);
    final publicKeys = publicKeysHex.map((key) => JacobianPoint.fromHexG1(key)).toList();
    return PopSchemeMPL.fastAggregateVerify(publicKeys, messageCodeUnits, signatureJacobianPoint);
  }
}