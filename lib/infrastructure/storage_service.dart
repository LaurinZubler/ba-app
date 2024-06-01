abstract class IStorageService {
  void init();

  bool get hasInitialized;

  Future<List<String>?> getAll(String key);

  Future<bool> setAll(String key, List<String> data);

}
