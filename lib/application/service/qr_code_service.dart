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
    cryptographyService: cryptographyService
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
    final qrCode = QRCode(type: CONTACT_QR_TYPE, data: contact);
    return _encodeBase64(qrCode.
    toJsonString());
  }

  Future<void> handleQrCode(String qrBase64) async {
    final qrString = _decodeBase64(qrBase64);
    final qrCode = QRCode.fromJsonString(qrString);

    switch (qrCode.type) {
      case CONTACT_QR_TYPE:
        await _contactService.save(qrCode.data as Contact);
      case POA_QR_TYPE:
        await _handlePoaQr(qrCode.data as ProofOfAttendance);
      default:
        // TODO: error handling
        throw const FormatException();
    }
  }

  Future<void> _handlePoaQr(ProofOfAttendance poa) async {
    // todo: switch to poa sign screen
    // final signedPoa = _cryptographyService.signProofOfAttendance(poa);
  }

  String _encodeBase64(String str) {
    return base64.encode(utf8.encode(str));
  }

  String _decodeBase64(String str) {
    return base64.encode(utf8.encode(str));
  }
}