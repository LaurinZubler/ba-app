import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/contact/i_contact_repository.dart';
import '../../infrastructure/contact_repository.dart';

final contactRepositoryProvider = FutureProvider<IContactRepository>((ref) async {
  final preferences = SharedPreferences.getInstance() as SharedPreferences;
  return ContactRepository(preferences);
});
