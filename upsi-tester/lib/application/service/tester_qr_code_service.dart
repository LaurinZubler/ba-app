import 'package:upsi_core/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:upsi_core/application/service/qr_code_service.dart';
import 'package:upsi_core/application/dto/qrCode/qr_code_dto.dart';
import 'package:upsi_core/global.dart';
import 'package:upsi_tester/application/service/poa_service.dart';

import 'infection_service.dart';

class TesterQRCodeService extends QRCodeService {
  final PoAService _poaService;
  final InfectionService _infectionService;

  TesterQRCodeService(this._poaService, this._infectionService);

  Future<String> createPoAQRData() async {
    final poa = await _poaService.create();
    return toQrCodeString(Global.POA_QR_TYPE, poa);
  }

    //todo: errorhandling does not work!!!!
  Future<void> handleQrCode(String qrString, void Function() infectionEventQrCallback) async {
    QRCode qrCode;
    try {
      qrCode = QRCode.fromJsonString(qrString);
    } catch (e) {
      throw const FormatException();
    }

    switch (qrCode.type) {
      case Global.INFECTION_EVENT_QR_TYPE:
        await _handleInfectionEventQr(qrCode.data);
        break;
      default:
        throw const FormatException();
    }
  }

  Future<void> _handleInfectionEventQr(Object infectionEventQr) async {
    InfectionEvent infectionEvent;
    try {
      infectionEvent = InfectionEvent.fromJson(infectionEventQr as Map<String, Object?>);
    } catch (e) {
      throw const FormatException();
    }
    await _infectionService.publishInfection(infectionEvent);
  }
}