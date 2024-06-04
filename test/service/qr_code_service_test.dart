import 'package:ba_app/application/dto/proofOfAttendance/proof_of_attendance_dto.dart';
import 'package:ba_app/application/dto/qrCode/qr_code_dto.dart';
import 'package:ba_app/application/global.dart';
import 'package:ba_app/application/service/contact_service.dart';
import 'package:ba_app/application/service/cryptography_service.dart';
import 'package:ba_app/application/service/qr_code_service.dart';
import 'package:ba_app/domain/model/contact/contact_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'qr_code_service_test.mocks.dart';

@GenerateMocks([ContactService, CryptographyService])
void main() {
  late MockContactService mockContactService;
  late MockCryptographyService mockCryptographyService;
  late QRCodeService qrCodeService;

  void call() {
    expect(true, true);
  }

  void noCall() {
    expect("should not be called", true);
  }

  setUp(() {
    mockContactService = MockContactService();
    mockCryptographyService = MockCryptographyService();
    qrCodeService = QRCodeService(mockContactService, mockCryptographyService);
  });

  group('handleQrCode() - contact', () {
    test('success', () async {
      final notExpired = DateTime.now().toUtc().subtract(Global.QR_EXPIRE_DURATION).add(const Duration(seconds: 1));
      final contact = Contact(publicKey: 'public key', dateTime: notExpired);
      final qrCode = QRCode(type: Global.CONTACT_QR_TYPE, data: contact).toJsonString();

      qrCodeService.handleQrCode(qrCode, () => call(), (p0) => noCall());
      verify(mockContactService.save(any)).called(1);
    });

    test('expired', () async {
      final expired = DateTime.now().toUtc().subtract(Global.QR_EXPIRE_DURATION).subtract(const Duration(seconds: 1));
      final contact = Contact(publicKey: 'public key', dateTime: expired);
      final qrCode = QRCode(type: Global.CONTACT_QR_TYPE, data: contact).toJsonString();

      expect(() => qrCodeService.handleQrCode(qrCode, () => noCall(), (p0) => noCall()), throwsA(isA<FormatException>()));
      verifyNever(mockContactService.save(any));
    });
  });

  group('handleQrCode() - poa', () {
    test('success', () async {
      final notExpired = DateTime.now().toUtc().subtract(Global.QR_EXPIRE_DURATION).add(const Duration(seconds: 1));
      final poa = ProofOfAttendance(tester: 'tester', testTime: notExpired);
      final qrCode = QRCode(type: Global.POA_QR_TYPE, data: poa).toJsonString();

      qrCodeService.handleQrCode(qrCode, () => noCall(), (p0) => call());
    });

    test('expired', () async {
      final expired = DateTime.now().toUtc().subtract(Global.QR_EXPIRE_DURATION).subtract(const Duration(seconds: 1));
      final poa = ProofOfAttendance(tester: 'tester', testTime: expired);
      final qrCode = QRCode(type: Global.POA_QR_TYPE, data: poa).toJsonString();

      expect(() => qrCodeService.handleQrCode(qrCode, () => noCall(), (p0) => noCall()), throwsA(isA<FormatException>()));
    });
  });

  group('handleQrCode() - invalid QR', () {
    test('contact', () async {
      const data = {'zero': 0} as Map<String, Object?>;
      final qrCode = const QRCode(type: Global.CONTACT_QR_TYPE, data: data).toJsonString();
      expect(() => qrCodeService.handleQrCode(qrCode, () => noCall(), (p0) => noCall()), throwsA(isA<FormatException>()));
    });

    test('poa', () async {
      const data = {'zero': 0} as Map<String, Object?>;
      final qrCode = const QRCode(type: Global.POA_QR_TYPE, data: data).toJsonString();
      expect(() => qrCodeService.handleQrCode(qrCode, () => noCall(), (p0) => noCall()), throwsA(isA<FormatException>()));
    });

    test('wrong type', () async {
      final notExpired = DateTime.now().toUtc().subtract(Global.QR_EXPIRE_DURATION).add(const Duration(seconds: 1));
      final poa = ProofOfAttendance(tester: 'tester', testTime: notExpired);
      final contact = Contact(publicKey: 'public key', dateTime: notExpired);
      final qrCode1 = QRCode(type: "wrong type", data: poa).toJsonString();
      final qrCode2 = QRCode(type: "wrong type", data: contact).toJsonString();

      expect(() => qrCodeService.handleQrCode(qrCode1, () => noCall(), (p0) => noCall()), throwsA(isA<FormatException>()));
      expect(() => qrCodeService.handleQrCode(qrCode2, () => noCall(), (p0) => noCall()), throwsA(isA<FormatException>()));
    });

    test('no upsi QR', () async {
      const qrCode = "no upsi qr";
      expect(() => qrCodeService.handleQrCode(qrCode, () => noCall(), (p0) => noCall()), throwsA(isA<FormatException>()));
    });
  });
}
