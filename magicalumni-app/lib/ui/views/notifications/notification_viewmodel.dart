import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/model/notifications_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/service/onesignal_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class NotificationViewmodel extends BaseViewModel{
  final OnesignalService onesignalService = locator<OnesignalService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  
  List<NotificationsModel> notifications = [];

  
  final ApiService apiService = locator<ApiService>();


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


  Future<void> notification() async {
    if (notifications.isEmpty) {
      notifications = await apiService.notifications();
      notifyListeners();
    }
  }

  String formatTimeDifference(String requestedDate) {
    final Duration difference = DateTime.now().difference(DateTime.parse(requestedDate));
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
  /// Dispose the Notification listener
  // void onDispose() {
  //   onesignalService.onDispose();
  // }
}