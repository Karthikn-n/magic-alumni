import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../service/api_service.dart';

class CreateJobViewmodel extends BaseViewModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController jobLinkController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  List<String> tags = [];
  String? selectedJobType;
  List<String> jobTypes = ["Job", "Internship"];

  bool isTitleAdded = false;
  bool isDateAdded = false;
  bool isCompanyNameAdded = false;
  bool isLocationAdded = false;
  bool isJobLinkAdded = false;

  bool get isFormValid 
    => isTitleAdded && isDateAdded && isCompanyNameAdded && isLocationAdded && isJobLinkAdded && selectedJobType != null && tags.isNotEmpty;

  final ApiService jobs = locator<ApiService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Add tags to the list
  void addTag(String tag, {bool? remove, int? index}){
    if (remove != null && index != null) {
      tags.removeAt(index);
    }else{
      tagController.clear();
      tags.add(tag);
    }
    notifyListeners();
  }

  void clearTag(int index){}

  // Validate the Jobs field 
  void init() {
    titleController.addListener(() {
      if (titleController.text.isEmpty) {
        isTitleAdded = false;
      }else{
        isTitleAdded = true;
      }
    },);

    dateController.addListener(() {
      if (dateController.text.isEmpty) {
        isDateAdded = false;
      } else {
        isDateAdded = true;
      }
    });

    companyNameController.addListener(() {
      if (companyNameController.text.isEmpty) {
        isCompanyNameAdded = false;
      } else {
        isCompanyNameAdded = true;
      }
    });


    locationController.addListener(() {
      if (locationController.text.isEmpty) {
        isLocationAdded = false;
      } else {
        isLocationAdded = true;
      }
    });

    jobLinkController.addListener(() {
      if (jobLinkController.text.isEmpty) {
        isJobLinkAdded = false;
      } else {
        isJobLinkAdded = true;
      }
    });
  }

  // Select the job type;
  void selectedJobTypeValue(String? value){
    selectedJobType = value;
    notifyListeners();
  }


  void showSnackBar() => _snackbarService.showSnackbar(message: "All fields are required", duration: Duration(milliseconds: 1200));

  // Pick the date for job application
  void pickedLastDate(DateTime? lastDate){
    if (lastDate != null) {
      dateController.text = DateFormat.yMMMd().format(lastDate);
    }
    notifyListeners();
  }

  /// Send the Job Data to the API
  Future<Map<String, dynamic>> jobData() async {
    return {
      "alumni_id": await _storage.read(key: "alumni_id") ?? "",
      "college_id": "677b6d5fb2a89b1437ba3853", //await _storage.read(key: "college_id") ?? "",
      "job_title": titleController.text,
      "last_date": dateController.text,
      "job_image" : " ",
      "location": locationController.text,
      "company_name": companyNameController.text,
      "job_url": jobLinkController.text,
      "tag": tags.toString(),
      "job_type": selectedJobType ?? ""
    };
  }

  @override
  void dispose(){
    super.dispose();
    titleController.dispose();
    dateController.dispose();
    companyNameController.dispose();
    locationController.dispose();
    jobLinkController.dispose();
    tags.clear();
    selectedJobType = null;
    notifyListeners();
  }
}