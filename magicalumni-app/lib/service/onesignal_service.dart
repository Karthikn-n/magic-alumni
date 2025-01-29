// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/ui/views/events/event_detail.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
class OnesignalService {
  static final OnesignalService _oneSignalService = OnesignalService._internal();
  

  // Stream controller that handle the new notification that comes from the oneSignal and API
  static final StreamController<OSNotification> _notificationStreamController = StreamController<OSNotification>.broadcast();
  static final NavigationService _navigationService = locator<NavigationService>();
  Stream<OSNotification> get notificationStream => _notificationStreamController.stream;

  static final ApiService _apiService = locator<ApiService>();

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
  static Future<void> subscribeNotification() async {
    /// listen to the Notification when the app is in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint("Notification received from one signal: ${event.notification.jsonRepresentation()}");
      _notificationStreamController.sink.add(event.notification);
    },);
    OneSignal.Notifications.addClickListener((event) async {
        var data = event.notification.additionalData;
        debugPrint("Notification data: ${event.notification.jsonRepresentation()}");
         if (data != null) {
          String? type = data['type'];
          debugPrint("Type of the button: $type");
          String? requestId = data['request_id'];
          debugPrint("Request ID: $requestId");
          /// Handle the notification action for the mobile request types
          if (type != null && type =="request") {
            // Check which button was clicked, if any
            List<OSActionButton> actionId = event.notification.buttons ?? [];
            debugPrint("${actionId.map((e) => e.text,)}");
            debugPrint("Button ID: ${actionId.map((e) => e.id,)}");
            // Handle the button actions from background and forground of the app
            for (var button in actionId) {
              if (button.id == 'accept') {
                // Handle accept request button action
                debugPrint("Requested accept clicked");
                await _apiService.updateMobileRequest("allowed", requestId ?? "");
                debugPrint("Request accepted");
              } else if(button.id == 'reject') {
                // Handle reject request by reject id
                debugPrint("Reject button clicked");
                await _apiService.updateMobileRequest("deny", requestId ?? "");
                debugPrint("Request rejected");
              }
            }
            //  if (actionId.isEmpty) {
            //   debugPrint("Moved to notification screen");
            //   _navigationService.navigateToNotificationsView();
            // }
          }
          /// TODO: Handle other type of requests
        }
    },);
    /// Handle the click events by listening to the notification types
    // OneSignal.Notifications.addClickListener((event) {
    //   final data = event.notification.additionalData;

    //   if (data == null) {
    //     debugPrint("Notification additional data is null.");
    //     return;
    //   }

    //   final String? type = data["type"] as String?;
    //   if (type == null) {
    //     debugPrint("Notification type is missing in additional data.");
    //     return;
    //   }

    //   switch (type) {
    //     case "event":
    //     case "invitation":
    //       _navigationService.navigateWithTransition(
    //             EventsDetailView(
    //               event: EventsModel.fromMap(event.notification.additionalData!["event"]), 
    //               status: event.notification.additionalData!["status"]
    //             )
    //           );
    //           break;
    //     case "request":
    //        _navigationService.navigateToNotificationsView();
    //        break;
    //     case "job":
    //        _navigationService.navigateToJobsView();
    //        break;
    //     default: _navigationService.navigateToNotificationsView();
    //   }

  
    // },);

  }


  factory OnesignalService() => _oneSignalService;
  

  OnesignalService._internal();

  void onDispose() async {
    await _notificationStreamController.close();
  }
}
