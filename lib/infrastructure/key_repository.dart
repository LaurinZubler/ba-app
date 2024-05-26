import 'package:ba_app/domain/i_key_repository.dart';
import 'package:ba_app/domain/keyPair/key_pair_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyRepository implements IKeyRepository {
  final SharedPreferences _preferences;
  final String _key = 'CONTACTS';

  KeyRepository(this._preferences);

  @override
  Future<List<KeyPair>> getAll() async {
    return getAllAsStrings().then((keyPair) => keyPair.map((s) => KeyPair.fromJsonString(s)).toList());
  }

  Future<List<String>> getAllAsStrings() async {
    return _preferences.getStringList(_key) ?? [];
  }

  @override
  Future<void> save(KeyPair keyPair) async {
    final keyPairs = await getAllAsStrings();
    keyPairs.add(keyPair.toJsonString());
    await _preferences.setStringList(_key, keyPairs);
  }
}