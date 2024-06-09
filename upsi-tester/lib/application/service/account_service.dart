import '../../domain/repository/i_account_repository.dart';
import 'cryptography_service.dart';

class AccountService {
  final IAccountRepository _accountRepository;
  final CryptographyService _cryptographyService;

  AccountService(this._accountRepository, this._cryptographyService);

  Future<String> getMailHash() async {
    final account = await _accountRepository.get();
    return _cryptographyService.hash(account.mail);
  }
}
