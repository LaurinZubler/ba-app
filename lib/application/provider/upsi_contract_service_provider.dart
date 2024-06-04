import 'package:ba_app/application/service/upsi_contract_service.dart';
import 'package:ba_app/data/provider/blockchain_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final upsiContractServiceProvider = Provider<UpsiContractService>((ref) {
  final blockchainService = ref.watch(blockchainServiceProvider);
  return UpsiContractService(blockchainService);
});
