import 'package:upsi_tester/domain/model/account_model.dart';

abstract class IAccountRepository {
  Future<void> save(Account block);
  Future<Account> get();
}
