import 'package:ba_app/domain/exposure/exposure_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/i_exposure_repository.dart';

class ExposureRepository implements IExposureRepository {
  final SharedPreferences _preferences;
  final String _key = 'EXPOSURES';

  ExposureRepository(this._preferences);

  @override
  Future<List<Exposure>> getAll() async {
    return _getAllAsStrings().then((exposures) => exposures.map((s) => Exposure.fromJsonString(s)).toList());
  }

  Future<List<String>> _getAllAsStrings() async {
    return _preferences.getStringList(_key) ?? [];
  }

  @override
  Future<void> save(Exposure exposure) async {
    final exposures = await _getAllAsStrings();
    exposures.add(exposure.toJsonString());
    await _preferences.setStringList(_key, exposures);
  }
}