import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_user/application/service/contact_service.dart';
import '../../data/provider/contact_repository_provider.dart';
import 'cryptography_service_provider.dart';

final contactServiceProvider = Provider<ContactService>((ref) {
  final cryptographyService = ref.watch(cryptographyServiceProvider);
  final contactRepository = ref.watch(contactRepositoryProvider);
  return ContactService(cryptographyService, contactRepository);
});
