import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';

import 'time.dart';

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

  // show notification
  static Future<void> showScheduledNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
    //required DateTime scheduledDate,
  }) async {
    tz.initializeTimeZones();
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleWeeklyAtTime(
        const Time(hour: 18, minute: 45, second: 0),
        days: [
          DateTime.saturday,
          DateTime.sunday,
          DateTime.monday,
          DateTime.wednesday,
          DateTime.friday,
        ],
      ),
      //_scheduleDailyAtTime(const Time(hour: 10)),
      //tz.TZDateTime.from(scheduledDate, tz.local),
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 6)),
      await _notificationDetails(),
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // show notification
  static Future<void> showPeriodicNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
    //required DateTime scheduledDate,
  }) async {
    return _notifications.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.weekly,
      await _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static tz.TZDateTime _scheduleDailyAtTime(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      time.minute,
      time.second,
    );

    print('current date: $now');
    print('scheduled date: $scheduledDate');
    print('current hour: ${now.hour}  scheduled hour: ${scheduledDate.hour}');

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static tz.TZDateTime _scheduleWeeklyAtTime(Time time,
      {required List<int> days}) {
    final scheduledDate = _scheduleDailyAtTime(time);

    // move to next day if scheduled date is not in the list
    while (!days.contains(scheduledDate.weekday)) {
      scheduledDate.add(const Duration(days: 1));
      print('weekday: ${scheduledDate.weekday}');
    }
    return scheduledDate;
  }
}
