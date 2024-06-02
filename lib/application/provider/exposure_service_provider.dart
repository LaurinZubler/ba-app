import 'package:ba_app/application/provider/contact_service_provider.dart';
import 'package:ba_app/application/provider/cryptography_service_provider.dart';
import 'package:ba_app/application/provider/push_notification_service_provider.dart';
import 'package:ba_app/application/service/exposure_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'exposure_repository_provider.dart';

final exposureServiceProvider = Provider<ExposureService>((ref) {
  final exposureRepository = ref.watch(exposureRepositoryProvider);
  final contactService = ref.watch(contactServiceProvider);
  final cryptographyService = ref.watch(cryptographyServiceProvider);
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  return ExposureService(exposureRepository, contactService, cryptographyService, pushNotificationService);
});
