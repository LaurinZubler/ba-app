import 'package:upsi_core/global.dart';
import '../dto/qrCode/qr_code_dto.dart';

abstract class QRCodeService {

  String toQrCodeString(String type, Object data) {
    final qrCode = QRCode(type: type, data: data);
    return qrCode.toJsonString();
  }

  void checkExpired(DateTime qrDateTime) {
    final qrExpireDateTime = DateTime.now().toUtc().subtract(Global.QR_EXPIRE_DURATION);
    if (qrDateTime.isBefore(qrExpireDateTime)) {
      // todo translation key
      throw const FormatException("QR code expired");
    }
  }
}