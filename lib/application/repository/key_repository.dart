import 'package:ba_app/domain/i_key_repository.dart';
import 'package:ba_app/domain/keyPair/key_pair_model.dart';
import 'package:ba_app/infrastructure/storage_service.dart';

class KeyRepository implements IKeyRepository {
  final IStorageService _storageService;
  final String _key = 'KEYS';

  KeyRepository(this._storageService);

  @override
  Future<List<KeyPair>> getAll() async {
    return _getAllAsStrings().then((keyPair) => keyPair.map((s) => KeyPair.fromJsonString(s)).toList());
  }

  Future<List<String>> _getAllAsStrings() async {
    return await _storageService.getAll(_key) ?? [];
  }

  @override
  Future<void> save(KeyPair keyPair) async {
    final keyPairs = await _getAllAsStrings();
    keyPairs.add(keyPair.toJsonString());
    await _storageService.setAll(_key, keyPairs);
  }
}