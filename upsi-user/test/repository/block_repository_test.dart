import 'package:upsi_user/application/global.dart';
import 'package:upsi_core/data/i_storage_service.dart';
import 'package:upsi_user/data/repository/block_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contact_repository_test.mocks.dart';

@GenerateMocks([IStorageService])
void main() {
  late MockIStorageService mockStorageService;
  late BlockRepository blockRepository;

  setUp(() {
    mockStorageService = MockIStorageService();
    blockRepository = BlockRepository(mockStorageService);
  });

  group('save()', () {
    test('success', () async {
      const block1 = 1;
      const block2 = 2;

      when(mockStorageService.get(any)).thenAnswer((_) async => block1.toString());
      when(mockStorageService.set(any, any)).thenAnswer((_) async => true);

      await blockRepository.save(block2);
      verify(mockStorageService.set(any, any)).called(1);
      verifyNever(mockStorageService.get(any));

      expect(await blockRepository.get(), block2);
      verifyNever(mockStorageService.get(any));
    });

    test('storage empty', () async {
      const block = 1;

      when(mockStorageService.get(any)).thenAnswer((_) async => "");
      when(mockStorageService.set(any, any)).thenAnswer((_) async => true);

      await blockRepository.save(block);
      verify(mockStorageService.set(any, any)).called(1);
      verifyNever(mockStorageService.get(any));

      expect(await blockRepository.get(), block);
      verifyNever(mockStorageService.get(any));
    });
  });

  group('get()', () {
    test('success', () async {
      const block = 1;
      when(mockStorageService.get(any)).thenAnswer((_) async => block.toString());
      when(mockStorageService.set(any, any)).thenAnswer((_) async => true);

      var resultBlock = await blockRepository.get();
      expect(resultBlock, block);
      verify(mockStorageService.get(any)).called(1);

      resultBlock = await blockRepository.get();
      expect(resultBlock, block);
      verifyNever(mockStorageService.get(any));
    });

    test('storage empty', () async {
      when(mockStorageService.get(any)).thenAnswer((_) async => "");
      when(mockStorageService.set(any, any)).thenAnswer((_) async => true);

      final block = await blockRepository.get();
      expect(block, Global.NO_BLOCKS_CHECKED_BLOCKNUMBER);
    });
  });
}
