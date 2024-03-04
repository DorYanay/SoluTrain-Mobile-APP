import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mobile/schemas.dart';
import 'package:mobile/api.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationSchema> notifications = [];

  @override
  void initState() {
    super.initState();

    API.post(context, '/notifications/get').then((Response res) {
      if (res.hasError) {
        return;
      }

      setState(() {
        notifications = NotificationsSchema.fromJson(res.data).notifications;
      });
    });
  }

  void deleteNotificationOnPres(NotificationSchema notification) {
    API.post(context, '/notifications/delete', params: {
      'notification_id': notification.notificationId,
    }).then((Response res) {
      if (res.hasError) {
        return;
      }

      setState(() {
        notifications.remove(notification);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: const Text('You dont have any notifications'),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: ListTile(
                  title: Text(
                    DateFormat('dd-MM-yyyy HH:mm').format(notification.date),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.message),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteNotificationOnPres(notification);
                    },
                  ),
                ),
              ),
            );
          },
        ));
  }
}
