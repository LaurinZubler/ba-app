import 'package:upsi_tester/domain/repository/i_account_repository.dart';

import '../../domain/model/account_model.dart';

class AccountRepository implements IAccountRepository {
  Account? _account;


  @override
  Future<Account> get() async {
    _account ??= const Account(mail: "laurin.zubler@ost.ch");
    return _account!;
  }

  @override
  Future<void> save(Account account) async {
    _account = account;
  }
}