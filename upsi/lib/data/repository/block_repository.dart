import 'package:upsi_user/application/global.dart';
import 'package:upsi_user/domain/repositories/i_block_repository.dart';
import 'package:upsi_core/data/i_storage_service.dart';

class BlockRepository implements IBlockRepository {
  int? _block;
  final IStorageService _storageService;
  static const String _key = 'BLOCK';

  BlockRepository(this._storageService);

  @override
  Future<int> get() async {
    _block ??= int.parse(await _fetchAsString());
    return _block!;
  }

  @override
  Future<void> save(int block) async {
    _block = block;
    await _storageService.set(_key, block.toString());
  }

  Future<String> _fetchAsString() async {
    final block = await _storageService.get(_key);
    return block != null && block.isNotEmpty ? block : Global.NO_BLOCKS_CHECKED_BLOCKNUMBER.toString();
  }
}