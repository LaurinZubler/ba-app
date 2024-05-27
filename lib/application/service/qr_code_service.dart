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
    final qrCode = QRCode(type: CONTACT_QR_TYPE, message: contact.toJsonString());
    return qrCode.toJsonString();
  }

  Future<void> handleQrCode(String qrString) async {
    final qrCode = QRCode.fromJsonString(qrString);
    switch (qrCode.type) {
      case CONTACT_QR_TYPE:
        _handleContactQr(qrCode.message);
      case POA_QR_TYPE:
        _handlePoaQr(qrCode.message);
      default:
        // TODO: error handling
        throw const FormatException();
    }
  }

  Future<void> _handleContactQr(String contactString) async {
    final contact = Contact.fromJsonString(contactString);
    return await _contactService.save(contact);
  }

  Future<ProofOfAttendance> _handlePoaQr(String poaString) async {
    final poa = ProofOfAttendance.fromJsonString(poaString);
    return _cryptographyService.signProofOfAttendance(poa);
  }
}