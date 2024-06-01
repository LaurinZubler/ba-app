import 'package:ba_app/application/service/exposure_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'exposure_repository_provider.dart';

final exposureServiceProvider = Provider<ExposureService>((ref) {
  final exposureRepository = ref.watch(exposureRepositoryProvider);
  return ExposureService(exposureRepository);
});
