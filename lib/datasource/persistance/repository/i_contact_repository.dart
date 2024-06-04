import '../../../domain/model/contact/contact_model.dart';

abstract class IContactRepository {
  Future<void> save(Contact contact);
  Future<List<Contact>> getAll();
}
