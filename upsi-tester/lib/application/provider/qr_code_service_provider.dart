import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_tester/application/provider/poa_service_provider.dart';
import '../service/tester_qr_code_service.dart';
import 'infection_service_provider.dart';

final qrCodeServiceProvider = Provider<TesterQRCodeService>((ref) {
  final poaService = ref.watch(poaServiceProvider);
  final infectionService = ref.watch(infectionServiceProvider);
  return TesterQRCodeService(poaService, infectionService);
});
