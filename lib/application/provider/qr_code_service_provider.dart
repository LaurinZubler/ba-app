import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ba_app/application/service/qr_code_service.dart';
import 'contact_service_provider.dart';
import 'cryptography_service_provider.dart';

final qrCodeServiceProvider = Provider<QRCodeService>((ref) {
  final contactService = ref.watch(contactServiceProvider);
  final cryptographyService = ref.watch(cryptographyServiceProvider);
  return QRCodeService(contactService, cryptographyService);
});
