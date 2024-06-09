import 'package:upsi_user/application/service/upsi_contract_service.dart';
import 'package:upsi_user/data/provider/block_repository_provider.dart';
import 'package:upsi_user/data/provider/blockchain_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final upsiContractServiceProvider = Provider<UpsiContractService>((ref) {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final blockRepository = ref.watch(blockRepositoryProvider);
  return UpsiContractService(blockchainService, blockRepository);
});
