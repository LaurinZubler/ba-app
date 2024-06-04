import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ba_app/application/service/cryptography_service.dart';
import 'package:ba_app/application/service/bls_service.dart';
import '../../data/persistence/provider/key_repository_provider.dart';

final cryptographyServiceProvider = Provider<CryptographyService>((ref) {
  final keyRepository = ref.watch(keyRepositoryProvider);
  final blsService = ref.watch(blsServiceProvider);
  return CryptographyService(blsService, keyRepository);
});