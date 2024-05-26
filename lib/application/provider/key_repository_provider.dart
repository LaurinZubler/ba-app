import 'package:ba_app/domain/i_key_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/key_repository.dart';

final keyRepositoryProvider = FutureProvider<IKeyRepository>((ref) async {
  final preferences = await SharedPreferences.getInstance();
  return KeyRepository(preferences);
});
