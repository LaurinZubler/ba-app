import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../datasource/persistance/shared_prefs_storage_service.dart';

final storageServiceProvider = Provider((ref) {
  final SharedPrefsService prefsService = SharedPrefsService();
  prefsService.init();
  return prefsService;
});