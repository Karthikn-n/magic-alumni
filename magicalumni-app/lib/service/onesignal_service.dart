// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:magic_alumni/ui/views/notifications/notification_viewmodel.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:flutter/material.dart';
class OnesignalService {
  static final OnesignalService _oneSignalService = OnesignalService._internal();
  
  static final NotificationViewmodel _notificationViewmodel = NotificationViewmodel();

  // Stream controller that handle the new notification that comes from the oneSignal and API
  static final StreamController<OSNotification> _notificationStreamController = StreamController<OSNotification>.broadcast();
  
  Stream<OSNotification> get notificationStream => _notificationStreamController.stream;

  static Future<void> init() async {
    // Load the dot env file for the APP ID
    await dotenv.load(fileName: ".env");
    // Set the debug logging system to print all the Errors
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    // Check it before initialize the Onesignal there is APP ID 
    if (dotenv.env["ONE_SIGNAL_APP_ID"] != null) {
     // Initialize the one signal using the APP Id from the dot env
      OneSignal.initialize(dotenv.get("ONE_SIGNAL_APP_ID", fallback: ""), );
    }
    // Request the Notification permission for the notifications
    OneSignal.Notifications.requestPermission(true);
    subscribeNotification();
    debugPrint("One Signal ID: ${await OneSignal.User.getExternalId()}");
  }


  // Login the user to the one signal by setting external ID
  Future<void> oneSignalLogin(String userId) async {
    /// Set the external User ID for the one signal using login
    await OneSignal.login(userId);
    await OneSignal.User.addAlias(userId, userId);
  }


  /// Check the permission every time that app is closed and reopen it
  static Stream subscribeNotification() async* {
    /// Check the permissions all the way if the user is manually denied from setting
   await _notificationViewmodel.init();
    /// listen to the Notification when the app is in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint("Notification received: ${event.notification.jsonRepresentation()}");
      _notificationStreamController.add(event.notification);
    },);
   
  }

  //
  Future<void> removeUserandSubscription(String userId) async {
    /// This will remove the external user id in the one signal that we don't want
    // await OneSignal.logout();
    // await OneSignal.User.removeAlias(userId);
  }

  factory OnesignalService() => _oneSignalService;
  

  OnesignalService._internal();

  void onDispose() async {
    await _notificationStreamController.close();
  }
}
