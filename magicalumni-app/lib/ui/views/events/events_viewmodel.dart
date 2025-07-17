import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/ui/views/events/create-event/create_event_view.dart';
import 'package:magic_alumni/ui/views/events/event_detail.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../service/api_service.dart';

class EventsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final bottomSheetService = locator<BottomSheetService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();


   /// Use API Service to get the news from the API
  final ApiService apiService = ApiService();
  final ScrollController scrollController = ScrollController();
  List<EventsModel> eventsList = [];
  bool isSent = false;

  // Navigate to create event view
  void navigateToCreateEvent()
    => _navigationService.navigateWithTransition(CreateEventView(), transitionStyle: Transition.downToUp);
  

  /// Call the Events API and store if the events get from the API or return empty list
  Future<void> events({bool? isrefreshed}) async {
    if (isrefreshed != null) {
       await apiService.events().then(
        (value) {
          eventsList = value;
          notifyListeners();
        } ,
      );
    }
    if(eventsList.isEmpty) {
      await apiService.events().then(
        (value) {
          eventsList = value;
          notifyListeners();
        } ,
      );
    } else {
      eventsList = apiService.eventsList;
      notifyListeners(); 
    }
  }

  /// Send the Feedback for attendance to the event
  Future<void> givePresent(String option, String eventId) async {
    await apiService.giveRsvp(eventId, option).then((value) {
      if (value) {
        isSent = value;
      }
      notifyListeners();
    },);
  }

  /// Get the event status if already user send the request and show snackbar if not approved
  void showUnapprovedEventSnack() async => _snackbarService.showSnackbar(message: "Event is not approved yet");
  

  // Navigate to Event Detail view
  void navigateToEventDetail(EventsModel event, String status, Key? key){
    // bottomSheetService. setCustomSheetBuilders({
    //     BottomSheetType.eventDetails: (context, sheetRequest, completer) =>
    //         _EventDetailsSheet(request: sheetRequest, completer: completer),
    //   });
    // bottomS/
    // _navigationService.navigateWithTransition(
    //   EventsDetailView(event: event, status: status, key: key,), 
    //   transitionStyle: Transition.downToUp
    // );
  }

  void onDispose(){
    scrollController.dispose();
  }
}