import 'package:upsi_core/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:upsi_core/data/repository/infection_repository.dart';
import 'package:upsi_core/domain/model/infection/infection_model.dart';
import 'package:upsi_user/application/service/contact_service.dart';
import 'package:upsi_user/application/service/cryptography_service.dart';
import 'package:upsi_user/application/service/exposure_service.dart';
import 'package:upsi_user/application/service/push_notification_service.dart';
import 'package:upsi_user/application/service/upsi_contract_service.dart';
import 'package:upsi_user/data/repository/exposure_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exposure_service_test.mocks.dart';

@GenerateMocks([ExposureRepository, ContactService, CryptographyService, PushNotificationService, UpsiContractService, InfectionRepository])
void main() {
  late MockExposureRepository mockExposureRepository;
  late MockContactService mockContactService;
  late MockCryptographyService mockCryptographyService;
  late MockPushNotificationService mockPushNotificationService;
  late MockUpsiContractService mockUpsiContractService;
  late MockInfectionRepository mockInfectionRepository;
  late ExposureService exposureService;

  setUp(() {
    mockExposureRepository = MockExposureRepository();
    mockContactService = MockContactService();
    mockCryptographyService = MockCryptographyService();
    mockPushNotificationService = MockPushNotificationService();
    mockUpsiContractService = MockUpsiContractService();
    mockInfectionRepository = MockInfectionRepository();
    exposureService = ExposureService(mockExposureRepository, mockContactService, mockCryptographyService, mockPushNotificationService, mockUpsiContractService, mockInfectionRepository);
  });

  group('checkNewInfectionEvents()', () {
    test('success', () async {
      const smilingSyndrome = Infection(key: "SMILING_SYNDROME", notificationPeriodDays: 10);
      final infectionEvent = InfectionEvent(infection: smilingSyndrome.key, infectee: ["infectee"], tester: "tester", testTime: DateTime.now().toUtc(), signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) => true);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});
      when(mockInfectionRepository.getAll()).thenAnswer((_) async => [smilingSyndrome]);

      await exposureService.checkNewInfectionForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(1);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(1);
      verify(mockPushNotificationService.show(any, any)).called(1);
    });

    test('two exposures', () async {
      const smilingSyndrome = Infection(key: "SMILING_SYNDROME", notificationPeriodDays: 10);
      final infectionEvent1 = InfectionEvent(infection: smilingSyndrome.key, infectee: ["infectee"], tester: "tester", testTime: DateTime.now().toUtc(), signature: "signature");
      final infectionEvent2 = InfectionEvent(infection: smilingSyndrome.key, infectee: ["infectee"], tester: "tester", testTime: DateTime.now().toUtc(), signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent1, infectionEvent2]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) => true);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});
      when(mockInfectionRepository.getAll()).thenAnswer((_) async => [smilingSyndrome]);

      await exposureService.checkNewInfectionForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(2);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(2);
      verify(mockPushNotificationService.show(any, any)).called(1);
    });

    test('signature invalid', () async {
      const smilingSyndrome = Infection(key: "SMILING_SYNDROME", notificationPeriodDays: 10);
      final infectionEvent = InfectionEvent(infection: smilingSyndrome.key, infectee: ["infectee"], tester: "tester", testTime: DateTime.now().toUtc(), signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) => false);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});
      when(mockInfectionRepository.getAll()).thenAnswer((_) async => [smilingSyndrome]);

      await exposureService.checkNewInfectionForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(1);
      verifyNever(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any));
      verifyNever(mockPushNotificationService.show(any, any));
    });

    test('first signature invalid', () async {
      const smilingSyndrome = Infection(key: "SMILING_SYNDROME", notificationPeriodDays: 10);
      final infectionEvent1 = InfectionEvent(infection: smilingSyndrome.key, infectee: ["infectee"], tester: "tester1", testTime: DateTime.now().toUtc(), signature: "signature");
      final infectionEvent2 = InfectionEvent(infection: smilingSyndrome.key, infectee: ["infectee"], tester: "tester2", testTime: DateTime.now().toUtc(), signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent1, infectionEvent2]);
      when(mockCryptographyService.verifyInfectionEvent(infectionEvent1)).thenAnswer((_) => true);
      when(mockCryptographyService.verifyInfectionEvent(infectionEvent2)).thenAnswer((_) => false);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});
      when(mockInfectionRepository.getAll()).thenAnswer((_) async => [smilingSyndrome]);

      await exposureService.checkNewInfectionForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(2);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(1);
      verify(mockPushNotificationService.show(any, any)).called(1);
    });

    test('multiple public keys - had contact with', () async {
      const smilingSyndrome = Infection(key: "SMILING_SYNDROME", notificationPeriodDays: 10);
      final infectionEvent = InfectionEvent(infection: smilingSyndrome.key, infectee: ["infectee1", "infectee2"], tester: "tester", testTime: DateTime.now().toUtc(), signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) => true);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => true);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});
      when(mockInfectionRepository.getAll()).thenAnswer((_) async => [smilingSyndrome]);

      await exposureService.checkNewInfectionForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(1);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(1);
      verify(mockPushNotificationService.show(any, any)).called(1);
    });

    test('multiple public keys 2 - no contact', () async {
      const smilingSyndrome = Infection(key: "SMILING_SYNDROME", notificationPeriodDays: 10);
      final infectionEvent = InfectionEvent(infection: smilingSyndrome.key, infectee: ["infectee1", "infectee2"], tester: "tester", testTime: DateTime.now().toUtc(), signature: "signature");

      when(mockUpsiContractService.getNewInfectionEvents()).thenAnswer((_) async => [infectionEvent]);
      when(mockCryptographyService.verifyInfectionEvent(any)).thenAnswer((_) => true);
      when(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).thenAnswer((_) async => false);
      when(mockPushNotificationService.show(any, any)).thenAnswer((_) async => {});
      when(mockInfectionRepository.getAll()).thenAnswer((_) async => [smilingSyndrome]);

      await exposureService.checkNewInfectionForPossibleExposure();

      verify(mockUpsiContractService.getNewInfectionEvents()).called(1);
      verify(mockCryptographyService.verifyInfectionEvent(any)).called(1);
      verify(mockContactService.hasAnyByPublicKeyAndDateTimeAfter(any, any)).called(2);
      verifyNever(mockPushNotificationService.show(any, any));
    });
  });
}
