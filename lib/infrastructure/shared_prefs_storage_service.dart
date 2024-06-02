import 'dart:async';

import 'package:ba_app/infrastructure/i_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService implements IStorageService {
  SharedPreferences? sharedPreferences;

  final Completer<SharedPreferences> initCompleter = Completer<SharedPreferences>();

  @override
  void init() {
    initCompleter.complete(SharedPreferences.getInstance());
  }

  @override
  bool get hasInitialized => sharedPreferences != null;

  @override
  Future<List<String>?> getAll(String key) async {
    sharedPreferences = await initCompleter.future;
    return sharedPreferences!.getStringList(key);
  }

  @override
  Future<bool> setAll(String key, List<String> data) async {
    sharedPreferences = await initCompleter.future;
    return await sharedPreferences!.setStringList(key, data);
  }
}
