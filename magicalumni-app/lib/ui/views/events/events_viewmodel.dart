import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/ui/views/events/create-event/create_event_view.dart';
import 'package:magic_alumni/ui/views/events/event_detail.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EventsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  
  // Navigate to create event view
  void navigateToCreateEvent() {
    _navigationService.navigateWithTransition(CreateEventView(), transitionStyle: Transition.downToUp);
  }

  // Navigate to Event Detail view
  void navigateToEventDetail(){
    _navigationService.navigateWithTransition(
      EventsDetailView(), 
      transitionStyle: Transition.downToUp
    );
  }
}