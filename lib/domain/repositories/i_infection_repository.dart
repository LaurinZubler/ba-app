import 'package:ba_app/domain/model/infection/infection_model.dart';

abstract class IInfectionRepository {
  Future<List<Infection>> getAll();
}
