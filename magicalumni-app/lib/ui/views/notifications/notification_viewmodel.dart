import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/model/mobrequest_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/service/onesignal_service.dart';
import 'package:magic_alumni/ui/views/events/event_detail.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationViewmodel extends BaseViewModel{
  final OnesignalService _onesignalService = locator<OnesignalService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final ApiService _apiService = locator<ApiService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  
  final List<OSNotification> _notifications = [];
  List<OSNotification> get notifications => _notifications;

  
  List<MobileRequestModel> mobRequests = [];

  Future<void> init() async {
    _onesignalService.notificationStream.listen((event) {
      _notifications.add(event);
      notifyListeners();
    },);
     /// Handle the click events by listening to the notification types
    OneSignal.Notifications.addClickListener((event) {
      if(event.notification.additionalData!["type"] == "event") {
        // Navigate to the events detail screen using the event ID from the custom data 
        _navigationService.navigateWithTransition(
          EventsDetailView(
            event: EventsModel.fromMap(event.notification.additionalData!["event"]), 
            status: event.notification.additionalData!["status"]
          )
        );
      } else if(event.notification.additionalData!["type"] == "job"){
        // Navigate to the jobs listing screen
        _navigationService.navigateToJobsView();
      } else if (event.notification.additionalData!["type"] == "request") {
        // Navigte to the notification screen
        _navigationService.navigateToNotificationsView();
      } else if (event.notification.additionalData!["type"] == "invitation") {
        // Navigate to the event screen 
        _navigationService.navigateWithTransition(
          EventsDetailView(
            event: EventsModel.fromMap(event.notification.additionalData!["event"]), 
            status: event.notification.additionalData!["status"]
          )
        );
      } else {
        // navigate to the notification screen
        _navigationService.navigateToNotificationsView();
      }
    },);

     if (_apiService.mobRequestsList.isEmpty) {
      await _apiService.mobileRequestList().then((value) {
        mobRequests = value;
        notifyListeners(); 
      },);
    } else {
      mobRequests = _apiService.mobRequestsList;
      notifyListeners();
    }
  }

  /// Navigate to the Notifications Screen
  void navigateToNotificationView()
    => mobRequests.isEmpty
      ? _snackbarService.showSnackbar(message: "No notfications for you", duration: Duration(seconds: 2))
      : _navigationService.navigateToNotificationsView();

  
}