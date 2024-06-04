import 'package:ba_app/application/provider/contact_service_provider.dart';
import 'package:ba_app/application/provider/cryptography_service_provider.dart';
import 'package:ba_app/application/provider/push_notification_service_provider.dart';
import 'package:ba_app/application/provider/upsi_contract_service_provider.dart';
import 'package:ba_app/application/service/exposure_service.dart';
import 'package:ba_app/data/provider/infection_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/provider/exposure_repository_provider.dart';

final exposureServiceProvider = Provider<ExposureService>((ref) {
  final exposureRepository = ref.watch(exposureRepositoryProvider);
  final contactService = ref.watch(contactServiceProvider);
  final cryptographyService = ref.watch(cryptographyServiceProvider);
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  final upsiContractService = ref.watch(upsiContractServiceProvider);
  final infectionRepository = ref.watch(infectionRepositoryProvider);
  return ExposureService(exposureRepository, contactService, cryptographyService, pushNotificationService, upsiContractService, infectionRepository);
});
