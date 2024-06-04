import 'package:ba_app/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:ba_app/application/service/contact_service.dart';
import 'package:ba_app/application/service/cryptography_service.dart';
import 'package:ba_app/application/service/exposure_service.dart';
import 'package:ba_app/application/service/push_notification_service.dart';
import 'package:ba_app/application/service/upsi_contract_service.dart';
import 'package:ba_app/data/repository/exposure_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exposure_service_test.mocks.dart';

@GenerateMocks([ExposureRepository, ContactService, CryptographyService, PushNotificationService, UpsiContractService])
void main() {
  late MockExposureRepository mockExposureRepository;
  late MockContactService mockContactService;
  late MockCryptographyService mockCryptographyService;
  late MockPushNotificationService mockPushNotificationService;
  late MockUpsiContractService mockUpsiContractService;
  late ExposureService exposureService;

  setUp(() {
    mockExposureRepository = MockExposureRepository();
    mockContactService = MockContactService();
    mockCryptographyService = MockCryptographyService();
    mockPushNotificationService = MockPushNotificationService();
    mockUpsiContractService = MockUpsiContractService();
    exposureService = ExposureService(mockExposureRepository, mockContactService, mockCryptographyService, mockPushNotificationService, mockUpsiContractService);
  });

  group('checkNewInfectionEvents()', () {
    test('success', () async {
      final notExpired = DateTime.now().toUtc();
      final infectionEvent = InfectionEvent(infection: "smilingSyndrome", infectee: ["infectee"], tester: "tester", testTime: notExpired, signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) async => true);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});

      await exposureService.checkNewInfectionEventsForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(1);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(1);
      verify(mockPushNotificationService.show(any, any)).called(1);
    });

    test('two exposures', () async {
      final notExpired = DateTime.now().toUtc();
      final infectionEvent1 = InfectionEvent(infection: "smilingSyndrome", infectee: ["infectee"], tester: "tester", testTime: notExpired, signature: "signature");
      final infectionEvent2 = InfectionEvent(infection: "smilingSyndrome", infectee: ["infectee"], tester: "tester", testTime: notExpired, signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent1, infectionEvent2]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) async => true);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});

      await exposureService.checkNewInfectionEventsForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(2);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(2);
      verify(mockPushNotificationService.show(any, any)).called(1);
    });

    test('signature invalid', () async {
      final notExpired = DateTime.now().toUtc();
      final infectionEvent = InfectionEvent(infection: "smilingSyndrome", infectee: ["infectee"], tester: "tester", testTime: notExpired, signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) async => false);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});

      await exposureService.checkNewInfectionEventsForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(1);
      verifyNever(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any));
      verifyNever(mockPushNotificationService.show(any, any));
    });

    test('first signature invalid', () async {
      final notExpired = DateTime.now().toUtc();
      final infectionEvent1 = InfectionEvent(infection: "smilingSyndrome", infectee: ["infectee"], tester: "tester1", testTime: notExpired, signature: "signature");
      final infectionEvent2 = InfectionEvent(infection: "smilingSyndrome", infectee: ["infectee"], tester: "tester2", testTime: notExpired, signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent1, infectionEvent2]);
      when(mockCryptographyService.verifyInfectionEvent(infectionEvent1)).thenAnswer((_) async => true);
      when(mockCryptographyService.verifyInfectionEvent(infectionEvent2)).thenAnswer((_) async => false);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});

      await exposureService.checkNewInfectionEventsForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(2);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(1);
      verify(mockPushNotificationService.show(any, any)).called(1);
    });

    test('multiple public keys - had contact with', () async {
      final notExpired = DateTime.now().toUtc();
      final infectionEvent = InfectionEvent(infection: "smilingSyndrome", infectee: ["infectee1", "infectee2"], tester: "tester", testTime: notExpired, signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) async => true);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});

      await exposureService.checkNewInfectionEventsForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(1);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(1);
      verify(mockPushNotificationService.show(any, any)).called(1);
    });

    test('multiple public keys 2 - no contact', () async {
      final notExpired = DateTime.now().toUtc();
      final infectionEvent = InfectionEvent(infection: "smilingSyndrome", infectee: ["infectee1", "infectee2"], tester: "tester", testTime: notExpired, signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) async => true);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => false);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});

      await exposureService.checkNewInfectionEventsForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(1);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(2);
      verifyNever(mockPushNotificationService.show(any, any));
    });

  });

}
