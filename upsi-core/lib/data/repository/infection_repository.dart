import '../../domain/model/infection/infection_model.dart';
import '../../domain/repository/i_infection_repository.dart';

class InfectionRepository implements IInfectionRepository {
  static const List<Infection> _infections = [
    Infection(key: 'SMILING_SYNDROME', notificationPeriodDays:  356),
    Infection(key: "ORGY_FEVER",  notificationPeriodDays:  7 * 2),
    Infection(key: "DESIRES_FLU",  notificationPeriodDays:  7),
    Infection(key: "INTRIGUE_INFECTION",  notificationPeriodDays:  7 * 4),
  ];

  @override
  Future<List<Infection>> getAll() async {
    return _infections;
  }

}