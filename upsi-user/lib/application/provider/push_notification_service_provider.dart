import 'package:upsi_user/application/service/push_notification_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pushNotificationServiceProvider = Provider((ref) {
  final PushNotificationService pushNotificationService = PushNotificationService();
  pushNotificationService.init();
  return pushNotificationService;
});