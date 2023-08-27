import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/notification_api.dart';
import '../widgets/button_widget.dart';
import 'second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final logger = Logger();

  @override
  void initState() {
    super.initState();

    // listen to the stream
    NotificationApi.notificationStream.listen((event) {
      logger.i('notification stream payload: $event');

      // navigate to second screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(payload: event),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notification Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                size: Size(width, 48),
                title: 'Notify Me',
                onPressed: () {
                  debugPrint('Notify Me');
                  NotificationApi.showNotification(
                    title: 'Notification',
                    body: 'This is a notification from Local Notification Demo',
                    payload: 'notification payload',
                  );
                },
                icon: Icons.notifications,
              ),
              const SizedBox(height: 8),
              ButtonWidget(
                size: Size(width, 48),
                title: 'Schedule Notification',
                onPressed: () {
                  debugPrint('Schedule Notification');
                  NotificationApi.showScheduledNotification(
                    title: 'Scheduled Notification',
                    body:
                        'This is a scheduled notification from Local Notification Demo',
                    payload: 'scheduled notification payload',
                    // scheduledDate: DateTime.now().add(const Duration(seconds: 6)),
                  );
                },
                icon: Icons.notifications_active,
              ),
              const SizedBox(height: 8),
              ButtonWidget(
                size: Size(width, 48),
                title: 'Remove Notification',
                onPressed: () {},
                icon: Icons.delete_forever,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
