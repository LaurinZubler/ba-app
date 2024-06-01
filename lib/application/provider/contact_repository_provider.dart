import 'package:ba_app/application/provider/storage_service_provider.dart';
import 'package:ba_app/application/repository/contact_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ba_app/domain/i_contact_repository.dart';

final contactRepositoryProvider = Provider<IContactRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ContactRepository(storageService);
});