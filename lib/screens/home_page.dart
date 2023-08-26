import 'package:flutter/material.dart';

import '../api/notification_api.dart';
import '../widgets/button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    payload: 'kayes',
                  );
                },
                icon: Icons.notifications,
              ),
              const SizedBox(height: 8),
              ButtonWidget(
                size: Size(width, 48),
                title: 'Schedule Notification',
                onPressed: () {},
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
