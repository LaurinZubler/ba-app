import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/i_exposure_repository.dart';
import '../../infrastructure/exposure_repository.dart';

final exposureRepositoryProvider = FutureProvider<IExposureRepository>((ref) async {
  final preferences = await SharedPreferences.getInstance();
  return ExposureRepository(preferences);
});
