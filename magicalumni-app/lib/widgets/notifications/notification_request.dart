import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/notifications/notification_viewmodel.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationRequest extends StatelessWidget {
  final OSNotification notification;
  final NotificationViewmodel model;
  const NotificationRequest({super.key, required this.notification, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notification.title ?? ""),
      subtitle:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body ?? ""),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async => await model.apiService.updateMobileRequest("allowed", notification.additionalData!["request_id"] ?? "")  , 
                  child: Text("Accept")
                ),
                TextButton(
                  onPressed: () async => await model.apiService.updateMobileRequest("denied", notification.additionalData!["request_id"] ?? "")  ,  
                  child: Text("Deny")
                ),
              ],
            )
          ],
        ),
      isThreeLine: true,
    );
  }
}