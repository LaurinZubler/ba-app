import 'dart:convert';

import 'package:ba_app/application/key_service.dart';
import 'package:ba_app/domain/contactExchange/contact_exchange_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final contactExchangeServiceProvider = Provider<ContractExchangeService>((ref) {
  return ContractExchangeService(
      keyService: ref.watch(keyServiceProvider)
  );
});

class ContractExchangeService {

  final KeyService keyService;

  ContractExchangeService({
    required this.keyService
  });

  createContactExchange() {
    final publicKey = keyService.getCurrentPublicKey();
    final dateTime = DateTime.now().toUtc();
    return ContactExchange(publicKey: publicKey, dateTime: dateTime);
  }

  toJsonString(ContactExchange contactExchange) {
    return contactExchange.toJson().toString();
  }

  fromJsonString(String contactExchangeJsonString) {
    final contactExchangeMap = jsonDecode(contactExchangeJsonString) as Map<String, dynamic>;
    return ContactExchange.fromJson(contactExchangeMap);
  }

}