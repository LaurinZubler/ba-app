import 'package:ba_app/data/provider/storage_service_provider.dart';
import 'package:ba_app/data/repository/block_repository.dart';
import 'package:ba_app/domain/repositories/i_block_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final blockRepositoryProvider = Provider<IBlockRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return BlockRepository(storageService);
});