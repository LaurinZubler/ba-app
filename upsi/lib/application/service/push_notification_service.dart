import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final Completer<FlutterLocalNotificationsPlugin> _initCompleter = Completer<FlutterLocalNotificationsPlugin>();

  void init() {
    // Initialize native Android notification
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native iOS Notifications
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings).then((_) {
      _initCompleter.complete(_flutterLocalNotificationsPlugin);
    }).catchError((error) {
      _initCompleter.completeError(error);
    });
  }

  Future<void> show(String title, String body) async {
    _flutterLocalNotificationsPlugin = await _initCompleter.future;

    const androidNotificationDetail = AndroidNotificationDetails(
      '0', // channel Id
      'general', // channel Name
    );
    const iosNotificationDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificationDetail,
      android: androidNotificationDetail,
    );

    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}
