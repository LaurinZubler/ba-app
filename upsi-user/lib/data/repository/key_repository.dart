import 'package:upsi_core/domain/model/keyPair/key_pair_model.dart';
import 'package:upsi_core/data/i_storage_service.dart';

import '../../../domain/repository/i_key_repository.dart';

class KeyRepository implements IKeyRepository {
  List<KeyPair>? _keyPairs;
  final IStorageService _storageService;
  final String _key = 'KEYS';

  KeyRepository(this._storageService);
  
  @override
  Future<List<KeyPair>> getAll() async {
    _keyPairs ??= await _getAll();
    return _keyPairs!;
  }

  @override
  Future<void> save(KeyPair keyPair) async {
    final keyPairs = await getAll();
    keyPairs.add(keyPair);
    await _save(keyPairs.map((keyPair) => keyPair.toJsonString()).toList());
  }

  Future<List<KeyPair>> _getAll() async {
    return await _fetchAllAsString().then((keyPairs) => keyPairs.map((s) => KeyPair.fromJsonString(s)).toList());
  }

  Future<List<String>> _fetchAllAsString() async {
    return await _storageService.getAll(_key) ?? [];
  }

  Future<void> _save(List<String> keyPairs) async {
    await _storageService.setAll(_key, keyPairs);
  }
}