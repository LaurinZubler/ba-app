import 'package:upsi_user/domain/model/exposure/exposure_model.dart';
import 'package:upsi_core/data/i_storage_service.dart';

import '../../../domain/repository/i_exposure_repository.dart';

class ExposureRepository implements IExposureRepository {
  List<Exposure>? _exposures;
  final IStorageService _storageService;
  final String _key = 'EXPOSURES';

  ExposureRepository(this._storageService);

  @override
  Future<List<Exposure>> getAll() async {
    _exposures ??= await _getAll();
    return _exposures!;
  }

  @override
  Future<void> save(Exposure exposure) async {
    final exposures = await getAll();
    exposures.add(exposure);
    await _save(exposures.map((exposure) => exposure.toJsonString()).toList());
  }

  Future<List<Exposure>> _getAll() async {
    return await _fetchAllAsString().then((exposures) => exposures.map((s) => Exposure.fromJsonString(s)).toList());
  }

  Future<List<String>> _fetchAllAsString() async {
    return await _storageService.getAll(_key) ?? [];
  }

  Future<void> _save(List<String> exposures) async {
    await _storageService.setAll(_key, exposures);
  }
}