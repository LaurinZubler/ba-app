import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_tester/application/provider/account_service_provider.dart';

import '../service/poa_service.dart';

final poaServiceProvider = Provider<PoAService>((ref) {
  final accountService = ref.watch(accountServiceProvider);
  return PoAService(accountService);
});
