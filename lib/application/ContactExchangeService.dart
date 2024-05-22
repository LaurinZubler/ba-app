import 'package:hooks_riverpod/hooks_riverpod.dart';

final contractExchangeServiceProvider = Provider<ContractExchangeService>((ref) {
  return ContractExchangeService();
});

class ContractExchangeService {
  createContactExchange() {
    return DateTime.timestamp().toString();
  }

}