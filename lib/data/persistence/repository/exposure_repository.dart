import 'package:ba_app/domain/model/exposure/exposure_model.dart';
import 'package:ba_app/data/persistence/i_storage_service.dart';

import '../../../domain/repositories/i_exposure_repository.dart';


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