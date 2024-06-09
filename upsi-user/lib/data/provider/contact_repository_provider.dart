import 'package:upsi_core/data/provider/storage_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_user/domain/repositories/i_contact_repository.dart';

import '../repository/contact_repository.dart';

final contactRepositoryProvider = Provider<IContactRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ContactRepository(storageService);
});