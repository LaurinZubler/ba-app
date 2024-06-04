import 'package:ba_app/data/i_storage_service.dart';
import 'package:ba_app/data/repository/contact_repository.dart';
import 'package:ba_app/domain/model/contact/contact_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contact_repository_test.mocks.dart';

@GenerateMocks([IStorageService])
void main() {
  late MockIStorageService mockStorageService;
  late ContactRepository contactRepository;

  setUp(() {
    mockStorageService = MockIStorageService();
    contactRepository = ContactRepository(mockStorageService);
  });

  group('save()', () {
    test('success', () async {
      final contact1 = Contact(publicKey: "publicKey1", dateTime: DateTime.now().toUtc());
      final contact2 = Contact(publicKey: "publicKey2", dateTime: DateTime.now().toUtc());

      when(mockStorageService.getAll(any)).thenAnswer((_) async => [contact1.toJsonString()]);
      when(mockStorageService.setAll(any, any)).thenAnswer((_) async => true);

      await contactRepository.save(contact2);
      verify(mockStorageService.getAll(any)).called(1);
      verify(mockStorageService.setAll(any, any)).called(1);

      expect(await contactRepository.getAll(), [contact1, contact2]);
      verifyNever(mockStorageService.getAll(any));
    });

    test('storage empty', () async {
      final contact = Contact(publicKey: "publicKey", dateTime: DateTime.now().toUtc());

      when(mockStorageService.getAll(any)).thenAnswer((_) async => []);
      when(mockStorageService.setAll(any, any)).thenAnswer((_) async => true);

      await contactRepository.save(contact);
      verify(mockStorageService.getAll(any)).called(1);
      verify(mockStorageService.setAll(any, any)).called(1);

      expect(await contactRepository.getAll(), [contact]);
      verifyNever(mockStorageService.getAll(any));
    });
  });

  group('getAll()', () {
    test('success', () async {
      final contact = Contact(publicKey: "publicKey", dateTime: DateTime.now().toUtc());

      when(mockStorageService.getAll(any)).thenAnswer((_) async => [contact.toJsonString()]);

      var contacts = await contactRepository.getAll();
      verify(mockStorageService.getAll(any)).called(1);
      expect(contacts, [contact]);

      contacts = await contactRepository.getAll();
      verifyNever(mockStorageService.getAll(any));
      expect(contacts, [contact]);
    });

    test('empty', () async {
      when(mockStorageService.getAll(any)).thenAnswer((_) async => []);

      var contacts = await contactRepository.getAll();
      verify(mockStorageService.getAll(any)).called(1);
      expect(contacts, []);

      contacts = await contactRepository.getAll();
      verifyNever(mockStorageService.getAll(any));
      expect(contacts, []);
    });
  });
}
