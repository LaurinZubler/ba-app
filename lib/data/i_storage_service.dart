abstract class IStorageService {
  void init();

  bool get hasInitialized;

  Future<List<String>?> getAll(String key);
  Future<String?> get(String key);

  Future<bool> setAll(String key, List<String> data);
  Future<bool> set(String key, String data);
}
