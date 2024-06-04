import '../../../domain/model/exposure/exposure_model.dart';

abstract class IExposureRepository {
  Future<void> save(Exposure exposure);
  Future<List<Exposure>> getAll();
}
