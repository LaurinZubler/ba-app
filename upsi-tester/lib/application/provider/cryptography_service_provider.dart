import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_core/application/service/bls_service.dart';

import '../service/cryptography_service.dart';

final cryptographyServiceProvider = Provider<CryptographyService>((ref) {
  final blsService = ref.watch(blsServiceProvider);
  return CryptographyService(blsService);
});