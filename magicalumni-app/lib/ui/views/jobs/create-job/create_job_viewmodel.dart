import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class CreateJobViewmodel extends BaseViewModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController criteriaController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController jobLinkController = TextEditingController();
  String? selectedJobType;
  List<String> jobTypes = ["Job", "Internship"];

  // Select the job type;
  void selectedJobTypeValue(String? value){
    selectedJobType = value;
    notifyListeners();
  }

  // Pick the date for job application
  void pickedLastDate(DateTime? lastDate){
    if (lastDate != null) {
      dateController.text = DateFormat.yMMMd().format(lastDate);
    }
    notifyListeners();
  }
}