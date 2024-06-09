import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_tester/application/service/infection_service.dart';

final infectionServiceProvider = Provider<InfectionService>((ref) {
  // final poaService = ref.watch(poaServiceProvider);
  return InfectionService();
});
