import "package:http/http.dart";
import "package:web3dart/web3dart.dart";

import "i_blockchain_provider.dart";

class EthereumRPCProvider extends IBlockchainProvider {

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
}