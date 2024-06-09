abstract class IBlockRepository {
  Future<void> save(int block);
  Future<int> get();
}
