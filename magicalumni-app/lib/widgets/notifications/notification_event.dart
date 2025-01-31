import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/model/notifications_model.dart';
import 'package:magic_alumni/ui/views/notifications/notification_viewmodel.dart';

class NotificationEvent extends StatelessWidget {
  final NotificationsModel notification;
  final NotificationViewmodel model;
  const NotificationEvent({super.key, required this.notification, required this.model});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListTile(
        tileColor: Colors.grey.shade300,
        leading: Icon(CupertinoIcons.bell),
        title: Text(
          notification.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87
          ),
        ),
        trailing: Column(
          children: [
            Text(model.formatTimeDifference(notification.createdAt ?? notification.date)),
            IconButton(
              tooltip: "View Event",
              onPressed: () async {
                model.navigateToEventDetail(notification.eventId ?? "");
              }, 
              icon: Icon(CupertinoIcons.chevron_right, size: 20,)
            ),
          ],
        ),
        subtitle:  Text(
          notification.content, 
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black45
          ),
        ),
      ),
    );
  }

}