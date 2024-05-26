import 'dart:convert';

import 'package:ba_app/application/key_service.dart';
import 'package:ba_app/domain/contact/contact_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final contactServiceProvider = Provider<ContractService>((ref) {
  return ContractService(
      keyService: ref.watch(keyServiceProvider)
  );
});

class ContractService {

  final KeyService keyService;

  ContractService({
    required this.keyService
  });

  createContact() {
    final publicKey = keyService.getCurrentPublicKey();
    final dateTime = DateTime.now().toUtc();
    return Contact(publicKey: publicKey, dateTime: dateTime);
  }

  toJsonString(Contact contact) {
    return contact.toJson().toString();
  }

  fromJsonString(String contact) {
    final json = jsonDecode(contact) as Map<String, dynamic>;
    return Contact.fromJson(json);
  }

}