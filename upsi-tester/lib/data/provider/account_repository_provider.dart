import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_tester/domain/repository/i_account_repository.dart';

import '../repository/account_repository.dart';

final accountRepositoryProvider = Provider<IAccountRepository>((ref) {
  return AccountRepository();
});