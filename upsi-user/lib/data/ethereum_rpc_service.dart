import "package:upsi_core/global.dart";
import "package:upsi_user/data/i_blockchain_service.dart";
import "package:http/http.dart";
import "package:web3dart/web3dart.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';


class EthereumRPCService extends IBlockchainService {

  @override
  Future<List<FilterEvent>> getLogs(String address, String topic, int fromBlockNumber, int? toBlockNumber) async {
    final client = Web3Client(getUrl(), Client());
    final topics = [[topic]];
    final fromBlock = BlockNum.exact(fromBlockNumber);
    final toBlock = toBlockNumber != null ? BlockNum.exact(fromBlockNumber) : const BlockNum.current();
    final options = FilterOptions(address: EthereumAddress.fromHex(address), fromBlock: fromBlock, toBlock: toBlock, topics: topics);
    return await client.getLogs(options);
  }

  @override
  Future<int> getLatestBlockNumber() async {
    final client = Web3Client(getUrl(), Client());
    return await client.getBlockNumber();
  }

  String getUrl() {
    final infuraApiKey = dotenv.env[Global.INFURA_API_KEY];
    return Global.INFURA_URL + infuraApiKey!;
  }
}