import 'package:ba_app/domain/i_exposure_repository.dart';
import 'package:ba_app/domain/exposure/exposure_model.dart';
import 'package:ba_app/infrastructure/storage_service.dart';

class ExposureRepository implements IExposureRepository {
  final IStorageService _storageService;
  final String _key = 'EXPOSURES';

  ExposureRepository(this._storageService);

  @override
  Future<List<Exposure>> getAll() async {
    return _getAllAsStrings().then((exposures) => exposures.map((s) => Exposure.fromJsonString(s)).toList());
  }

  Future<List<String>> _getAllAsStrings() async {
    return await _storageService.getAll(_key) ?? [];
  }

  @override
  Future<void> save(Exposure exposure) async {
    final exposures = await _getAllAsStrings();
    exposures.add(exposure.toJsonString());
    await _storageService.setAll(_key, exposures);
  }
}