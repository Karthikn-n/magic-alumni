import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/model/notifications_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/service/onesignal_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class NotificationViewmodel extends BaseViewModel{
  final OnesignalService _onesignalService = locator<OnesignalService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  
  final List<NotificationsModel> _notifications = [];
  List<NotificationsModel> get notifications => _notifications;

  
  final ApiService apiService = locator<ApiService>();

  Future<void> init() async {
    debugPrint("Initialized");
    _onesignalService.notificationStream.listen((event) {
    debugPrint("Listening..");
      _notifications.add(NotificationsModel.fromJson(event.additionalData ?? <String, dynamic>{}));
      notifyListeners();
    },);
   debugPrint("Still listenting..");
  }

  void navigateToEventDetail(String eventId) async {
    await apiService.events().then((value) {
      EventsModel event = apiService.eventsList.firstWhere((element) => element.id == eventId,);
      _navigationService.navigateToEventsDetailView(event: event, status: "");
    },);

    // TODO : Parse the event from the event ID and Navigate to event detail View
  }

  /// Navigate to the Notifications Screen
  void navigateToNotificationView()
    => notifications.isEmpty
      ? _snackbarService.showSnackbar(message: "No notfications for you", duration: Duration(seconds: 2))
      : _navigationService.navigateToNotificationsView();

  /// Dispose the Notification listener
  void onDispose() {
    _onesignalService.onDispose();
  }
}