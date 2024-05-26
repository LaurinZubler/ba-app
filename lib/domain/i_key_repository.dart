import 'keyPair/key_pair_model.dart';

abstract class IKeyRepository {
  Future<void> save(KeyPair keyPair);
  Future<List<KeyPair>> getAll();
}
