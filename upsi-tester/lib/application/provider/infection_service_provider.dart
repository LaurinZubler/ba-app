import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_core/data/provider/infection_repository_provider.dart';
import 'package:upsi_tester/application/service/infection_service.dart';

import '../../data/provider/internez_provider.dart';

final infectionServiceProvider = Provider<InfectionService>((ref) {
  final internez = ref.watch(internezProvider);
  final infectionRepository = ref.watch(infectionRepositoryProvider);
  return InfectionService(internez, infectionRepository);
});
