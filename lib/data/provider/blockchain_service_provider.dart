import 'package:ba_app/data/i_blockchain_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../ethereum_rpc_service.dart';

final blockchainServiceProvider = Provider<IBlockchainService>((ref) {
  return EthereumRPCService();
});