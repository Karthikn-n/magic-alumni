import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class CreateEventViewmodel extends BaseViewModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController eventTypeController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController criteriaController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<String> rsvpOptions = ['Yes', 'No', 'Maybe'];

  void pickedEventDate(DateTime? eventDate){
    if (eventDate != null) {
      dateController.text = DateFormat.yMMMd().format(eventDate);
    }
    notifyListeners();
  }
}
 