import 'package:ba_app/domain/proofOfAttendance/proof_of_attendance_model.dart';

import '../../domain/contact/contact_model.dart';
import '../../domain/qrCode/qr_code_model.dart';
import 'contact_service.dart';
import 'cryptography_service.dart';

const CONTACT_QR_TYPE = "contact";
const POA_QR_TYPE = "poa";

const QR_EXPIRE_DURATION = Duration(minutes: 1);

class QRCodeService {
  final ContactService _contactService;
  final CryptographyService _cryptographyService;

  QRCodeService(this._contactService, this._cryptographyService);

  Future<String> createContactQRData() async {
    final contact = await _contactService.createContact();
    return _toQrCodeString(CONTACT_QR_TYPE, contact);
  }

  Future<String> signPoA(ProofOfAttendance poa) async {
    ProofOfAttendance signedPoA = await _cryptographyService.signPoA(poa);
    return _toQrCodeString(POA_QR_TYPE, signedPoA);
  }

  String _toQrCodeString(String type, Object data) {
    final qrCode = QRCode(type: type, data: data);
    return qrCode.toJsonString();
  }

    //todo: errorhandling
  Future<void> handleQrCode(String qrString, void Function() contactQrCallback, void Function(ProofOfAttendance) poaQrCallback) async {
    QRCode qrCode;
    try {
      qrCode = QRCode.fromJsonString(qrString);
    } catch (e) {
      throw const FormatException();
    }

    switch (qrCode.type) {
      case CONTACT_QR_TYPE:
        await _handleContactQr(qrCode.data);
        contactQrCallback();
        break;
      case POA_QR_TYPE:
        final poa = await _handlePoAQr(qrCode.data);
        poaQrCallback(poa);
        break;
      default:
        throw const FormatException();
    }
  }

  Future<void> _handleContactQr(Object contactQr) async {
    Contact contact;
    try {
      contact = Contact.fromJson(contactQr as Map<String, Object?>);
    } catch (e) {
      throw const FormatException();
    }
    _checkExpired(contact.dateTime);
    await _contactService.save(contact);
  }

  Future<ProofOfAttendance> _handlePoAQr(Object poaQr) async {
    ProofOfAttendance poa;
    try {
      poa = ProofOfAttendance.fromJson(poaQr as Map<String, Object?>);
    } catch (e) {
      throw const FormatException();
    }

    _checkExpired(poa.creationDate);
    return poa;
  }

  void _checkExpired(DateTime qrDateTime){
    final qrExpireDateTime = DateTime.now().toUtc().subtract(QR_EXPIRE_DURATION);
    if (qrDateTime.isBefore(qrExpireDateTime)) {
      // todo translation key
      throw const FormatException("QR code expired");
    }
  }
}
