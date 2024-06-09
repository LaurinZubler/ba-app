import 'package:upsi_core/data/provider/storage_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/repository/i_key_repository.dart';
import '../repository/key_repository.dart';

final keyRepositoryProvider = Provider<IKeyRepository>((ref) {
final storageService = ref.watch(storageServiceProvider);
return KeyRepository(storageService);
});