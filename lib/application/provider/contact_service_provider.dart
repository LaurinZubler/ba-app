import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ba_app/application/service/contact_service.dart';
import 'contact_repository_provider.dart';
import 'cryptography_service_provider.dart';

final contactServiceProvider = Provider<ContactService>((ref) {
  final cryptographyService = ref.watch(cryptographyServiceProvider);
  final contactRepository = ref.watch(contactRepositoryProvider);
  return ContactService(cryptographyService, contactRepository);
});
