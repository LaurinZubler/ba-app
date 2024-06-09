import 'package:upsi_core/data/provider/storage_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/repositories/i_exposure_repository.dart';
import '../repository/exposure_repository.dart';

final exposureRepositoryProvider = Provider<IExposureRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ExposureRepository(storageService);
});