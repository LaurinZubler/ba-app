import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi/application/service/cryptography_service.dart';
import 'package:upsi/application/service/bls_service.dart';
import '../../data/provider/key_repository_provider.dart';

final cryptographyServiceProvider = Provider<CryptographyService>((ref) {
  final keyRepository = ref.watch(keyRepositoryProvider);
  final blsService = ref.watch(blsServiceProvider);
  return CryptographyService(blsService, keyRepository);
});