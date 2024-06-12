import 'package:upsi_core/application/service/qr_code_service.dart';

import '../../domain/model/contact/contact_model.dart';
import 'package:upsi_core/application/dto/proofOfAttendance/proof_of_attendance_dto.dart';
import 'package:upsi_core/application/dto/qrCode/qr_code_dto.dart';
import 'package:upsi_core/global.dart';
import 'contact_service.dart';
import 'cryptography_service.dart';

class UserQRCodeService extends QRCodeService {
  final ContactService _contactService;
  final CryptographyService _cryptographyService;

  UserQRCodeService(this._contactService, this._cryptographyService);

  Future<String> createContactQRData() async {
    final contact = await _contactService.createContact();
    return toQrCodeString(Global.CONTACT_QR_TYPE, contact);
  }

  Future<String> createInfectionEventQRData(ProofOfAttendance poa) async {
    final infectionEvent = await _cryptographyService.createInfectionEvent(poa);
    return toQrCodeString(Global.INFECTION_QR_TYPE, infectionEvent);
  }

    //todo: errorhandling does not work!!!!
  Future<void> handleQrCode(String qrString, void Function() contactQrCallback, void Function(ProofOfAttendance) poaQrCallback) async {
    QRCode qrCode;
    try {
      qrCode = QRCode.fromJsonString(qrString);
    } catch (e) {
      throw const FormatException();
    }

    switch (qrCode.type) {
      case Global.CONTACT_QR_TYPE:
        await _handleContactQr(qrCode.data);
        contactQrCallback();
        break;
      case Global.POA_QR_TYPE:
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
    checkExpired(contact.dateTime);
    await _contactService.save(contact);
  }

  Future<ProofOfAttendance> _handlePoAQr(Object poaQr) async {
    ProofOfAttendance poa;
    try {
      poa = ProofOfAttendance.fromJson(poaQr as Map<String, Object?>);
    } catch (e) {
      throw const FormatException();
    }

    checkExpired(poa.testTime);
    return poa;
  }
}
