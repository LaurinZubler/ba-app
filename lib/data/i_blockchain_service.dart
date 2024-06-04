import 'package:web3dart/web3dart.dart';

abstract class IBlockchainService {
  Future<List<FilterEvent>> getLogs(String address, String topic, int fromBlockNumber, int? toBlockNumber);
}