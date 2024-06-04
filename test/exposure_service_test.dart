
import 'package:ba_app/application/service/contact_service.dart';
import 'package:ba_app/application/service/cryptography_service.dart';
import 'package:ba_app/application/service/exposure_service.dart';
import 'package:ba_app/application/service/push_notification_service.dart';
import 'package:ba_app/application/service/upsi_contract_service.dart';
import 'package:ba_app/data/repository/exposure_repository.dart';
import 'package:ba_app/domain/model/exposure/exposure_model.dart';
import 'package:ba_app/domain/model/infection/infection_model.dart';
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

  group('getAll()', () {
    test('success', () async {
      final exposure = Exposure(infection: const Infection(key: 'infection1', exposureDays: 10), testTime: DateTime.now().toUtc());

      when(mockExposureRepository.getAll()).thenAnswer((_) async => [exposure]);

      var exposures = await exposureService.getAll();
      expect(exposures, [exposure]);
      verify(mockExposureRepository.getAll()).called(1);

      exposures = await exposureService.getAll();
      expect(exposures, [exposure]);
      verify(mockExposureRepository.getAll()).called(1);
    });

    test('empty store', () async {
      when(mockExposureRepository.getAll()).thenAnswer((_) async => []);

      var exposures = await exposureService.getAll();
      expect(exposures, []);
      verify(mockExposureRepository.getAll()).called(1);

      exposures = await exposureService.getAll();
      expect(exposures, []);
      verify(mockExposureRepository.getAll()).called(1);
    });
  });

  group('save()', () {
    test('success', () async {
      final exposure = Exposure(infection: const Infection(key: 'infection', exposureDays: 10), testTime: DateTime.now().toUtc());
      await exposureService.save(exposure);
      verify(mockExposureRepository.save(any)).called(1);
      verifyNever(mockExposureRepository.getAll());
    });
  });

// todo: test this
  group('handleInfectionEvent()', () {
    test('success', () async {
    });
  });

}
