import 'package:upsi_core/data/i_storage_service.dart';
import 'package:upsi_user/data/repository/key_repository.dart';
import 'package:upsi_core/domain/model/keyPair/key_pair_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'key_repository_test.mocks.dart';

@GenerateMocks([IStorageService])
void main() {
  late MockIStorageService mockStorageService;
  late KeyRepository keyRepository;

  setUp(() {
    mockStorageService = MockIStorageService();
    keyRepository = KeyRepository(mockStorageService);
  });

  group('save()', () {
    test('success', () async {
      final keyPair1 = KeyPair(publicKey: "publicKey1", privateKey: 'privateKey1', creationDate: DateTime.now().toUtc());
      final keyPair2 = KeyPair(publicKey: "publicKey2", privateKey: 'privateKey2', creationDate: DateTime.now().toUtc());

      when(mockStorageService.getAll(any)).thenAnswer((_) async => [keyPair1.toJsonString()]);
      when(mockStorageService.setAll(any, any)).thenAnswer((_) async => true);

      await keyRepository.save(keyPair2);
      verify(mockStorageService.getAll(any)).called(1);
      verify(mockStorageService.setAll(any, any)).called(1);

      expect(await keyRepository.getAll(), [keyPair1, keyPair2]);
      verifyNever(mockStorageService.getAll(any));
    });

    test('storage empty', () async {
      final keyPair = KeyPair(publicKey: "publicKey", privateKey: 'privateKey', creationDate: DateTime.now().toUtc());

      when(mockStorageService.getAll(any)).thenAnswer((_) async => []);
      when(mockStorageService.setAll(any, any)).thenAnswer((_) async => true);

      await keyRepository.save(keyPair);
      verify(mockStorageService.getAll(any)).called(1);
      verify(mockStorageService.setAll(any, any)).called(1);

      expect(await keyRepository.getAll(), [keyPair]);
      verifyNever(mockStorageService.getAll(any));
    });
  });

  group('getAll()', () {
    test('success', () async {
      final keyPair = KeyPair(publicKey: "publicKey", privateKey: 'privateKey', creationDate: DateTime.now().toUtc());

      when(mockStorageService.getAll(any)).thenAnswer((_) async => [keyPair.toJsonString()]);

      var keyPairs = await keyRepository.getAll();
      verify(mockStorageService.getAll(any)).called(1);
      expect(keyPairs, [keyPair]);

      keyPairs = await keyRepository.getAll();
      verifyNever(mockStorageService.getAll(any));
      expect(keyPairs, [keyPair]);
    });

    test('empty', () async {
      when(mockStorageService.getAll(any)).thenAnswer((_) async => []);

      var keyPairs = await keyRepository.getAll();
      verify(mockStorageService.getAll(any)).called(1);
      expect(keyPairs, []);

      keyPairs = await keyRepository.getAll();
      verifyNever(mockStorageService.getAll(any));
      expect(keyPairs, []);
    });
  });
}
