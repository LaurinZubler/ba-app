import 'dart:convert' show utf8, base64;

import 'package:ba_app/domain/proofOfAttendance/proof_of_attendance_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/contact/contact_model.dart';
import '../../domain/qrCode/qr_code_model.dart';
import 'contact_service.dart';
import 'cryptography_service.dart';

const CONTACT_QR_TYPE = "contact";
const POA_QR_TYPE = "poa";

final qrCodeServiceProvider = FutureProvider<QRCodeService>((ref) async {
  final contactService = await ref.watch(contactServiceProvider.future);
  final cryptographyService = await ref.watch(cryptographyServiceProvider.future);
  return QRCodeService(
    contactService: contactService,
    cryptographyService: cryptographyService,
  );
});

class QRCodeService {
  final ContactService _contactService;
  final CryptographyService _cryptographyService;

  QRCodeService({
    required ContactService contactService,
    required CryptographyService cryptographyService
  }) : _contactService = contactService, _cryptographyService = cryptographyService;

  Future<String> createContactQr() async {
    final contact = await _contactService.createContact();
    return _toQrCodeString(CONTACT_QR_TYPE, contact);
  }

  Future<String> signPoA(ProofOfAttendance poa) async {
    ProofOfAttendance signedPoA = await _cryptographyService.signPoA(poa);
    return _toQrCodeString(POA_QR_TYPE, signedPoA);
  }

  String _toQrCodeString(String type, Object data) {
    final qrCode = QRCode(type: type, data: data);
    return _encodeBase64(qrCode.toJsonString());
  }

  Future<void> handleQrCode(String qrBase64, void Function() contactQrCallback, void Function(ProofOfAttendance) poaQrCallback) async {
    final qrString = _decodeBase64(qrBase64);
    final qrCode = QRCode.fromJsonString(qrString);

    //todo check expired here.
    //todo test
    switch (qrCode.type) {
      case CONTACT_QR_TYPE:
        final contact = Contact.fromJson(qrCode.data as Map<String, Object?>);
        await _contactService.save(contact);
        contactQrCallback();
        break;
      case POA_QR_TYPE:
        final poa = ProofOfAttendance.fromJson(qrCode.data as Map<String, Object?>);
        poaQrCallback(poa);
        break;
      default:
        throw const FormatException();
    }
  }

  String _encodeBase64(String str) {
    return base64.encode(utf8.encode(str));
  }

  String _decodeBase64(String str) {
    return utf8.decode(base64.decode(str));
  }
}
