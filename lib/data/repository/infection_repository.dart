import 'package:ba_app/domain/model/infection/infection_model.dart';
import '../../../domain/repositories/i_infection_repository.dart';

class InfectionRepository implements IInfectionRepository {
  static const List<Infection> _infections = [
    Infection(key: 'SMILING_SYNDROME', exposureDays:  356),
    Infection(key: "ORGY_FEVER",  exposureDays:  7 * 2),
    Infection(key: "DESIRES_FLU",  exposureDays:  7),
    Infection(key: "INTRIGUE_INFECTION",  exposureDays:  7 * 4),
  ];

  @override
  Future<List<Infection>> getAll() async {
    return _infections;
  }

}