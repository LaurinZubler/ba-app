import "package:ba_app/data/i_blockchain_service.dart";
import "package:http/http.dart";
import "package:web3dart/web3dart.dart";

class EthereumRPCService extends IBlockchainService {

  @override
  Future<List<FilterEvent>> getLogs(String address, String topic, int fromBlockNumber, int? toBlockNumber) async {
    const url = "";

    final client = Web3Client(url, Client());
    final topics = [[topic]];
    final fromBlock = BlockNum.exact(fromBlockNumber);
    final toBlock = toBlockNumber != null ? BlockNum.exact(fromBlockNumber) : const BlockNum.current();
    final options = FilterOptions(address: EthereumAddress.fromHex(address), fromBlock: fromBlock, toBlock: toBlock, topics: topics);
    return await client.getLogs(options);
  }

  @override
  Future<int> getLatestBlockNumber() async {
    final client = Web3Client("", Client());
    return await client.getBlockNumber();
  }
}