import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/model/notifications_model.dart';
import 'package:magic_alumni/ui/views/notifications/notification_viewmodel.dart';

class NotificationRequest extends StatelessWidget {
  final NotificationsModel notification;
  final NotificationViewmodel model;
  const NotificationRequest({super.key, required this.notification, required this.model});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Dismissible(
        key: Key("${notification.id}"),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade400
          ),
        ),
        dragStartBehavior: DragStartBehavior.down,
        onDismissed: (direction) {
        },
        child: ListTile(
          tileColor: Colors.grey.shade300,
          leading: Icon(CupertinoIcons.bell),
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(
            notification.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87
            ),
          ),
          visualDensity: VisualDensity(vertical: 2.0),
          trailing: Column(
            children: [
              Text(model.formatTimeDifference(notification.createdAt ?? notification.date)),
              PopupMenuButton(
                iconSize: 20,
                borderRadius: BorderRadius.zero,
                splashRadius: 10,
                itemBuilder: (context) {
                  return <PopupMenuItem>[
                    PopupMenuItem(
                      onTap: () async 
                        => await model.apiService.updateMobileRequest("allowed", notification.requestId ?? "",),
                      child: Text("Accept"), 
                    ),
                    PopupMenuItem(
                      onTap: () async
                         => await model.apiService.updateMobileRequest("denied", notification.requestId ?? "",),
                      child: Text("Reject"), 
                    ),
                  ];
                },
              ),
              
            ],
          ),
          subtitle: Text(
            notification.content.isEmpty ? notification.message : notification.content, 
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black45
            ),
          ),
        ),
      ),
    );
  }
}