import '../../domain/model/contact/contact_model.dart';
import 'package:upsi_core/application/dto/proofOfAttendance/proof_of_attendance_dto.dart';
import 'package:upsi_core/application/dto/qrCode/qr_code_dto.dart';
import '../global.dart';
import 'contact_service.dart';
import 'cryptography_service.dart';

class QRCodeService {
  final ContactService _contactService;
  final CryptographyService _cryptographyService;

  QRCodeService(this._contactService, this._cryptographyService);

  Future<String> createContactQRData() async {
    final contact = await _contactService.createContact();
    return _toQrCodeString(Global.CONTACT_QR_TYPE, contact);
  }

  Future<String> createInfectionEventQRData(ProofOfAttendance poa) async {
    final infectionEvent = await _cryptographyService.createInfectionEvent(poa);
    return _toQrCodeString(Global.INFECTION_EVENT_QR_TYPE, infectionEvent);
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
      case Global.CONTACT_QR_TYPE:
        // todo: tester error
        await _handleContactQr(qrCode.data);
        contactQrCallback();
        break;
      case Global.POA_QR_TYPE:
        // todo: tester error
        final poa = await _handlePoAQr(qrCode.data);
        poaQrCallback(poa);
        break;
      case Global.INFECTION_EVENT_QR_TYPE:
        // todo: user error
        // todo: tester emit infection event
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

    _checkExpired(poa.testTime);
    return poa;
  }

  void _checkExpired(DateTime qrDateTime){
    final qrExpireDateTime = DateTime.now().toUtc().subtract(Global.QR_EXPIRE_DURATION);
    if (qrDateTime.isBefore(qrExpireDateTime)) {
      // todo translation key
      throw const FormatException("QR code expired");
    }
  }
}
