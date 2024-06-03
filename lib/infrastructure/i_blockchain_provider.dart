import 'package:web3dart/web3dart.dart';

abstract class IBlockchainProvider {
  Future<List<FilterEvent>> getLogs(String address, String topic, BlockNum fromBlock, BlockNum toBlock);
}