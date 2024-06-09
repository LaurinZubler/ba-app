import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/provider/account_repository_provider.dart';
import '../service/account_service.dart';
import 'cryptography_service_provider.dart';

final accountServiceProvider = Provider<AccountService>((ref) {
  final accountRepository = ref.watch(accountRepositoryProvider);
  final cryptographyService = ref.watch(cryptographyServiceProvider);
  return AccountService(accountRepository, cryptographyService);
});