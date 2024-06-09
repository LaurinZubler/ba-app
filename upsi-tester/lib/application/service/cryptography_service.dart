import 'dart:convert';
import 'package:upsi_core/application/service/bls_service.dart';
import 'package:upsi_core/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:crypto/crypto.dart';

class CryptographyService {
  final BLSService _blsService;

  CryptographyService(this._blsService);

  bool verifyInfectionEvent(InfectionEvent event) {
    return _blsService.verify(event.signature, event.poa, event.infectee);
  }

  String hash(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }
}
