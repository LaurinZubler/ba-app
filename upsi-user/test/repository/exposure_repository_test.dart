import 'package:upsi_core/data/i_storage_service.dart';
import 'package:upsi_user/data/repository/exposure_repository.dart';
import 'package:upsi_user/domain/model/exposure/exposure_model.dart';
import 'package:upsi_user/domain/model/infection/infection_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exposure_repository_test.mocks.dart';

@GenerateMocks([IStorageService])
void main() {
  late MockIStorageService mockStorageService;
  late ExposureRepository exposureRepository;

  setUp(() {
    mockStorageService = MockIStorageService();
    exposureRepository = ExposureRepository(mockStorageService);
  });

  group('save()', () {
    test('success', () async {
      final exposure1 = Exposure(infection: const Infection(key: 'infection1', notificationPeriodDays: 1), testTime: DateTime.now().toUtc());
      final exposure2 = Exposure(infection: const Infection(key: 'infection2', notificationPeriodDays: 2), testTime: DateTime.now().toUtc());

      when(mockStorageService.getAll(any)).thenAnswer((_) async => [exposure1.toJsonString()]);
      when(mockStorageService.setAll(any, any)).thenAnswer((_) async => true);

      await exposureRepository.save(exposure2);
      verify(mockStorageService.getAll(any)).called(1);
      verify(mockStorageService.setAll(any, any)).called(1);

      expect(await exposureRepository.getAll(), [exposure1, exposure2]);
      verifyNever(mockStorageService.getAll(any));
    });

    test('storage empty', () async {
      final exposure = Exposure(infection: const Infection(key: 'infection', notificationPeriodDays: 1), testTime: DateTime.now().toUtc());

      when(mockStorageService.getAll(any)).thenAnswer((_) async => []);
      when(mockStorageService.setAll(any, any)).thenAnswer((_) async => true);

      await exposureRepository.save(exposure);
      verify(mockStorageService.getAll(any)).called(1);
      verify(mockStorageService.setAll(any, any)).called(1);

      expect(await exposureRepository.getAll(), [exposure]);
      verifyNever(mockStorageService.getAll(any));
    });
  });

  group('getAll()', () {
    test('success', () async {
      final exposure = Exposure(infection: const Infection(key: 'infection', notificationPeriodDays: 1), testTime: DateTime.now().toUtc());

      when(mockStorageService.getAll(any)).thenAnswer((_) async => [exposure.toJsonString()]);

      var exposures = await exposureRepository.getAll();
      verify(mockStorageService.getAll(any)).called(1);
      expect(exposures, [exposure]);

      exposures = await exposureRepository.getAll();
      verifyNever(mockStorageService.getAll(any));
      expect(exposures, [exposure]);
    });

    test('empty', () async {
      when(mockStorageService.getAll(any)).thenAnswer((_) async => []);

      var exposures = await exposureRepository.getAll();
      verify(mockStorageService.getAll(any)).called(1);
      expect(exposures, []);

      exposures = await exposureRepository.getAll();
      verifyNever(mockStorageService.getAll(any));
      expect(exposures, []);
    });
  });
}
