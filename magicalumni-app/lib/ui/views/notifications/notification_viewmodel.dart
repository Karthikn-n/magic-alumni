import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/service/onesignal_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class NotificationViewmodel extends BaseViewModel{
  final OnesignalService _onesignalService = locator<OnesignalService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  
  final List<OSNotification> _notifications = [];
  List<OSNotification> get notifications => _notifications;

  
  final ApiService apiService = locator<ApiService>();

  Future<void> init() async {
    _onesignalService.notificationStream.listen((event) {
      print("called1");
      _notifications.add(event);
      notifyListeners();
    },);
   
  
  }

  /// Navigate to the Notifications Screen
  void navigateToNotificationView()
    => notifications.isEmpty
      ? _snackbarService.showSnackbar(message: "No notfications for you", duration: Duration(seconds: 2))
      : _navigationService.navigateToNotificationsView();

  
}