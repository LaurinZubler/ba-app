import 'package:ba_app/application/service/exposure_service.dart';
import 'package:ba_app/domain/exposure/exposure_model.dart';
import 'package:ba_app/infrastructure/exposure_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exposure_service_test.mocks.dart';

@GenerateMocks([ExposureRepository])
void main() {
  late MockExposureRepository mockExposureRepository;
  late ExposureService exposureService;

  setUp(() {
    mockExposureRepository = MockExposureRepository();
    exposureService = ExposureService(
      exposureRepository: mockExposureRepository,
    );
  });

  group('getAll()', () {
    test('success', () async {
      const exposure = Exposure(infection: 'sti');

      when(mockExposureRepository.getAll()).thenAnswer((_) async => [exposure]);

      var exposures = await exposureService.getAll();
      expect(exposures, [exposure]);
      verify(mockExposureRepository.getAll()).called(1);

      exposures = await exposureService.getAll();
      expect(exposures, [exposure]);
      verifyNever(mockExposureRepository.getAll());
    });

    test('empty store', () async {

      when(mockExposureRepository.getAll()).thenAnswer((_) async => []);

      var exposures = await exposureService.getAll();
      expect(exposures, []);
      verify(mockExposureRepository.getAll()).called(1);

      exposures = await exposureService.getAll();
      expect(exposures, []);
      verifyNever(mockExposureRepository.getAll());
    });
  });

  group('save()', () {
    test('success', () async {
      const exposure1 = Exposure(infection: 'sti1');
      const exposure2 = Exposure(infection: 'sti2');
      const exposure3 = Exposure(infection: 'sti3');

      when(mockExposureRepository.getAll()).thenAnswer((_) async => [exposure1]);

      await exposureService.save(exposure2);
      verify(mockExposureRepository.save(any)).called(1);
      verify(mockExposureRepository.getAll()).called(1);

      var exposures = await exposureService.getAll();
      expect(exposures, [exposure1, exposure2]);
      verifyNever(mockExposureRepository.getAll());

      await exposureService.save(exposure3);
      verify(mockExposureRepository.save(any)).called(1);
      verifyNever(mockExposureRepository.getAll());

      exposures = await exposureService.getAll();
      expect(exposures, [exposure1, exposure2, exposure3]);
      verifyNever(mockExposureRepository.getAll());
    });

    test('empty store', () async {
      const exposure1 = Exposure(infection: 'sti1');
      const exposure2 = Exposure(infection: 'sti2');

      when(mockExposureRepository.getAll()).thenAnswer((_) async => []);

      await exposureService.save(exposure1);
      verify(mockExposureRepository.getAll()).called(1);
      verify(mockExposureRepository.save(any)).called(1);

      var exposures = await exposureService.getAll();
      expect(exposures, [exposure1]);
      verifyNever(mockExposureRepository.getAll());


      await exposureService.save(exposure2);
      verify(mockExposureRepository.save(any)).called(1);
      verifyNever(mockExposureRepository.getAll());

      exposures = await exposureService.getAll();
      expect(exposures, [exposure1, exposure2]);
      verifyNever(mockExposureRepository.getAll());
    });
  });

}
