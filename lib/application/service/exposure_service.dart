import 'package:ba_app/application/provider/exposure_repository_provider.dart';
import 'package:ba_app/domain/exposure/exposure_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/i_exposure_repository.dart';


final exposureServiceProvider = FutureProvider<ExposureService>((ref) async {
  final exposureRepository = await ref.watch(exposureRepositoryProvider.future);
  return ExposureService(exposureRepository: exposureRepository);
});

class ExposureService {
  List<Exposure>? _exposures;

  final IExposureRepository _exposureRepository;

  ExposureService({required IExposureRepository exposureRepository}) : _exposureRepository = exposureRepository;

  Future<List<Exposure>> getAll() async {
    _exposures ??= await _exposureRepository.getAll();
    return _exposures!;
  }

  Future<void> save(Exposure exposure) async {
    final exposures = await getAll();
    exposures.add(exposure);
    await _exposureRepository.save(exposure);
  }
}
