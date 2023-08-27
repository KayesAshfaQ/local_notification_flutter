import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

class NotificationApi {
  // create local notification instance
  static final _notifications = FlutterLocalNotificationsPlugin();

  // a stream to handle the notification events such as when notification is created, when it is clicked, etc.
  static final _notificationStreamController =
      StreamController<String>.broadcast();

  // a getter to get the stream
  static Stream<String> get notificationStream =>
      _notificationStreamController.stream;

  // dispose the stream
  static void dispose() => _notificationStreamController.close();

  // initialize the notification
  static Future init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );
  }

  // handle event when we receive notification in background
  static void _onDidReceiveBackgroundNotificationResponse(
      NotificationResponse response) {
    Logger().d('background notification(${response.id}) action tapped: '
        '${response.actionId} with'
        ' payload: ${response.payload}');
    if (response.input?.isNotEmpty ?? false) {
      Logger().d('notification action tapped with input: ${response.input}');
    }

    // add payload to stream
    _notificationStreamController.add(response.payload ?? '');
  }

  // handle event when we receive notification in foreground
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    Logger().d('notification(${response.id}) action tapped: '
        '${response.actionId} with'
        ' payload: ${response.payload}');
    if (response.input?.isNotEmpty ?? false) {
      Logger().d('notification action tapped with input: ${response.input}');
    }

    // add payload to stream
    _notificationStreamController.add(response.payload ?? '');
  }

  // show notification
  static Future<void> showNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
  }) async {
    return _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  // notification details for android and ios
  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel name',
        channelDescription: 'channel description',
        icon: "ic_notification",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        //sound: "sound.aiff",
        badgeNumber: 1,
      ),
    );
  }
}
