import 'package:ba_app/domain/contact/contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/i_contact_repository.dart';

class ContactRepository implements IContactRepository {
  final SharedPreferences _preferences;
  final String _key = 'CONTACTS';

  ContactRepository(this._preferences);

  @override
  Future<List<Contact>> getAll() async {
    return getAllAsStrings().then((contacts) => contacts.map((s) => Contact.fromJsonString(s)).toList());
  }

  Future<List<String>> getAllAsStrings() async {
    return _preferences.getStringList(_key) ?? [];
  }

  @override
  Future<void> save(Contact contact) async {
    final contacts = await getAllAsStrings();
    contacts.add(contact.toJsonString());
    await _preferences.setStringList(_key, contacts);
  }
}