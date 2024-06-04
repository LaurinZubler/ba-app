abstract class IBlockchainProvider {
  Future<List<Objet>> getLogs(String address, String topic, int fromBlockNumber, int? toBlockNumber);
}