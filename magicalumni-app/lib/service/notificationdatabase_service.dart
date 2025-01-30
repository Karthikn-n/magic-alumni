import 'dart:developer';

import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/model/notifications_model.dart';
import 'package:sqflite/sqflite.dart';

const String notificationTableName =  "notifications";
class NotificationDatabaseService {

  late Database _db;

  Future<void> initalise() async {
    _db = await openDatabase("notification.db", version: 1);
    log(_db.path);

    // Create Notification table
    _db.execute('''
      create table notifications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT,
      date TEXT,
      type TEXT,
      request_id TEXT,
      event_id TEXT
      )
      '''
    );
  }

  // Insert the notification whenever it received
  Future<void> insertNotification(NotificationsModel notification) async 
    => await _db.insert(notificationTableName, notification.toJson());

  // Delete the notifications
  Future<void> deleteNotification(int id) async
    => await _db.delete(notificationTableName, whereArgs: [id]);

  // Get all the notifications
  Future<List<NotificationsModel>> getNotifications() async {
    final result = await _db.query(notificationTableName, orderBy: "id DESC");
    return result.map((notification) => NotificationsModel.fromJson(notification) ,).toList();
  }
}