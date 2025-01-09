import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateEventViewmodel extends BaseViewModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController eventTypeController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController criteriaController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<String> rsvpOptions = ['Yes', 'No', 'Maybe'];
  List<String> selectedRsvpOptions = [];
  final ApiService events = locator<ApiService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // alumni_id,
  //     college_id,
  bool _isTitleAdded = false;
  bool _isdateAdded = false;
  bool _isTypeAdded = false;
  bool _imageAdded = false;
  bool _criteriaAdded = false;
  bool _locationAdded = false;
  bool _desAdded = false;

  bool get formValid 
    => _isTitleAdded && _isdateAdded && _isTypeAdded && _imageAdded && _criteriaAdded && _locationAdded && _desAdded;

  // Store the Selected Rsvp Options
  void selectOption(int index, {bool? removeOption}){
    if (removeOption != null) {
      rsvpOptions.add(selectedRsvpOptions[index]);
      selectedRsvpOptions.removeAt(index);
    } else {
      selectedRsvpOptions.add(rsvpOptions[index]);
      rsvpOptions.removeAt(index);
    }
    notifyListeners();
  }

  void init() {
    titleController.addListener(() {
      if (titleController.text.isEmpty) {
        _isTitleAdded = false;
      }else{
        _isTitleAdded = true;
      }
    },);

    dateController.addListener(() {
      if (dateController.text.isEmpty) {
        _isdateAdded = false;
      }else{
        _isdateAdded = true;
      }
    },);
    eventTypeController.addListener(() {
      if (eventTypeController.text.isEmpty) {
      _isTypeAdded = false;
      } else {
      _isTypeAdded = true;
      }
    });

    imageController.addListener(() {
      if (imageController.text.isEmpty) {
      _imageAdded = false;
      } else {
      _imageAdded = true;
      }
    });

    criteriaController.addListener(() {
      if (criteriaController.text.isEmpty) {
      _criteriaAdded = false;
      } else {
      _criteriaAdded = true;
      }
    });

    locationController.addListener(() {
      if (locationController.text.isEmpty) {
      _locationAdded = false;
      } else {
      _locationAdded = true;
      }
    });

    descriptionController.addListener(() {
      if (descriptionController.text.isEmpty) {
      _desAdded = false;
      } else {
      _desAdded = true;
      }
    });
  }

  // Show snack bar for every field any one of the required fiedl is empty
  void showSnackbar() => _snackbarService.showSnackbar(message: "All field are required", duration: const Duration(milliseconds: 1200));

  // Store the picked event date
  void pickedEventDate(DateTime? eventDate){
    if (eventDate != null) {
      dateController.text = DateFormat.yMMMd().format(eventDate);
    }
    notifyListeners();
  }

  /// Return all the fields to the API
  Future<Map<String, dynamic>> eventData() async {
    return {
      "alumni_id": await _storage.read(key: "alumni_id"),
      "college_id": "677b6d5fb2a89b1437ba3853",//await _storage.read(key: "college_id") ?? "",
      "event_title": titleController.text,
      "date": dateController.text,
      // "approval_status": "",
      "event_type": eventTypeController.text,
      "rsvp_options": selectedRsvpOptions,
      "location": locationController.text,
      "criteria": criteriaController.text,
      "descrtipion": descriptionController.text,
      "event_image": imageController.text,
    };
  }  


  void onDispose() {
    titleController.dispose();
    dateController.dispose();
    eventTypeController.dispose();
    imageController.dispose();
    criteriaController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    selectedRsvpOptions.clear();
  }
}
 