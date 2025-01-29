// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/ui/views/app-view/app_viewmodel.dart';
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
  static final AppViewModel _appViewModel = locator<AppViewModel>();

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
      debugPrint("Notification received from one signal: ${event.notification.additionalData}");
      _notificationStreamController.sink.add(event.notification);
    },);
    OneSignal.Notifications.addClickListener((event) async {
        var data = event.notification.additionalData;
        debugPrint("Notification data: ${event.notification.additionalData}");
         if (data != null) {
          String? type = data['type'];
          debugPrint("Type of the button: $type");
          String? requestId = data['request_id'];
          debugPrint("Request ID: $requestId");

          /// Handle the notification action for the mobile request types
          if (type != null && type =="request") {
            // Check which button was clicked, if any
            String actionId = event.result.actionId ?? "";
            
            debugPrint("${event.result.actionId}");
            // Handle the button actions from background and forground of the app
            if (actionId == 'accept') {
              // Handle accept request button action
              debugPrint("Requested accept clicked");
              await _apiService.updateMobileRequest("allowed", requestId ?? "");
              debugPrint("Request accepted");
            } else if(actionId == 'reject') {
              // Handle reject request by reject id
              debugPrint("Reject button clicked");
              await _apiService.updateMobileRequest("denied", requestId ?? "");
              debugPrint("Request rejected");
            }
            
            //  if (actionId.isEmpty) {
            //   debugPrint("Moved to notification screen");
            //   _navigationService.navigateToNotificationsView();
            // }
          } else if(type == "event") {
            /// If the notification has the
            String? eventId = data["event_id"] ?? "";
            if(event.result.actionId != null && event.result.actionId == "view"){
              await _apiService.events().then((value) {
                EventsModel event = _apiService.eventsList.firstWhere((element) => element.id == eventId,);
                _navigationService.navigateToEventsDetailView(event: event, status: "");
              },);
            }
          } else if (type == "job") {
            /// If the ntofication comes for the Job then open the Jobs view before that call the Jobs APi to update the list
            _apiService.jobs().then((value) {
              _appViewModel.onTapped(3);
              _navigationService.navigateToAppView();
            },);
          
          } else {
            /// If the notification has no types than above cases it will go to the App home screen
            _navigationService.navigateToAppView();
          }
        }
    },);

  }


  factory OnesignalService() => _oneSignalService;
  

  OnesignalService._internal();

  void onDispose() async {
    await _notificationStreamController.close();
  }
}
