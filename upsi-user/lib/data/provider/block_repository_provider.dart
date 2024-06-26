import 'package:upsi_core/data/provider/storage_service_provider.dart';
import 'package:upsi_user/data/repository/block_repository.dart';
import 'package:upsi_user/domain/repository/i_block_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final blockRepositoryProvider = Provider<IBlockRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return BlockRepository(storageService);
});