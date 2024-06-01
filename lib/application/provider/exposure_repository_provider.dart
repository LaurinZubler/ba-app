import 'package:ba_app/application/provider/storage_service_provider.dart';
import 'package:ba_app/application/repository/exposure_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ba_app/domain/i_exposure_repository.dart';

final exposureRepositoryProvider = Provider<IExposureRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ExposureRepository(storageService);
});