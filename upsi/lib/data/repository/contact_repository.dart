import 'package:upsi/domain/repositories/i_contact_repository.dart';
import 'package:upsi/domain/model/contact/contact_model.dart';
import 'package:upsi/data/i_storage_service.dart';

class ContactRepository implements IContactRepository {
  List<Contact>? _contacts;
  final IStorageService _storageService;
  static const String _key = 'CONTACTS';

  ContactRepository(this._storageService);

  @override
  Future<List<Contact>> getAll() async {
    _contacts ??= await _getAll();
    return _contacts!;
  }

  @override
  Future<void> save(Contact contact) async {
    final contacts = await getAll();
    contacts.add(contact);
    await _save(contacts.map((contact) => contact.toJsonString()).toList());
  }

  Future<List<Contact>> _getAll() async {
    return await _fetchAllAsString().then((contacts) => contacts.map((s) => Contact.fromJsonString(s)).toList());
  }

  Future<List<String>> _fetchAllAsString() async {
    return await _storageService.getAll(_key) ?? [];
  }

  Future<void> _save(List<String> contacts) async {
    await _storageService.setAll(_key, contacts);
  }
}