import 'package:ba_app/application/global.dart';
import 'package:ba_app/application/service/upsi_contract_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final upsiContractServiceProvider = Provider<UpsiContractService>((ref) {
  return UpsiContractService(Global.UPSI_CONTRACT_ABI);
});
