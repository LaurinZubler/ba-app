import 'package:upsi_user/domain/repositories/i_infection_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repository/infection_repository.dart';

final infectionRepositoryProvider = Provider<IInfectionRepository>((ref) {
  return InfectionRepository();
});