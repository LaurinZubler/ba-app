import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_user/application/service/user_qr_code_service.dart';
import 'contact_service_provider.dart';
import 'cryptography_service_provider.dart';

final qrCodeServiceProvider = Provider<UserQRCodeService>((ref) {
  final contactService = ref.watch(contactServiceProvider);
  final cryptographyService = ref.watch(cryptographyServiceProvider);
  return UserQRCodeService(contactService, cryptographyService);
});
