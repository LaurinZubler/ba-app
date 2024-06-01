
import 'package:ba_app/application/service/bls_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final blsServiceProvider = Provider<BLSService>((ref) {
  return BLSService();
});