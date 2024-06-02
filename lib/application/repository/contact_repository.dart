import 'package:ba_app/domain/i_contact_repository.dart';
import 'package:ba_app/domain/contact/contact_model.dart';
import 'package:ba_app/infrastructure/i_storage_service.dart';

class ContactRepository implements IContactRepository {
  final IStorageService _storageService;
  final String _key = 'CONTACTS';

  ContactRepository(this._storageService);

  @override
  Future<List<Contact>> getAll() async {
    return _getAllAsStrings().then((contacts) => contacts.map((s) => Contact.fromJsonString(s)).toList());
  }

  Future<List<String>> _getAllAsStrings() async {
    return await _storageService.getAll(_key) ?? [];
  }

  @override
  Future<void> save(Contact contact) async {
    final contacts = await _getAllAsStrings();
    contacts.add(contact.toJsonString());
    await _storageService.setAll(_key, contacts);
  }
}