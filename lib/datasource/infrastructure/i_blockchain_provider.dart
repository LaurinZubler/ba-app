import 'package:web3dart/web3dart.dart';

abstract class IBlockchainProvider {
  Future<List<FilterEvent>> getLogs(String address, String topic, int fromBlockNumber, int? toBlockNumber);
}