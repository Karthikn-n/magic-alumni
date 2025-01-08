import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:stacked/stacked.dart';

class ProfileViewmodel extends BaseViewModel{
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController collegeNameController = TextEditingController();
  final TextEditingController depNameController = TextEditingController();
  final TextEditingController currentOrCcyController = TextEditingController();
  final TextEditingController linkedUrlController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController designationController = TextEditingController();

  bool isExpanded = false;
  final TextEditingController newCollegeController = TextEditingController();
  final TextEditingController newDepartmentController = TextEditingController();
  final TextEditingController newCurrentYearOrAlumniController = TextEditingController();
  bool isCurrentYearStudent = false;

  bool isUserNameValid = false;
  bool isCollegNameValid = false;
  bool isdepNameValid = false;
  bool isYearValid = false;
  bool isLinkedInUrlValid = false;

  bool get isFormValid => isUserNameValid && isCollegNameValid && isdepNameValid && isYearValid && isLinkedInUrlValid;

  AlumniModel? alumni;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // change the current student status on the profile screen
  void changeStudentStatus(bool value){
    isCurrentYearStudent = value;
    notifyListeners();
  }
  
  // check the new college is expanded or not
  void checkExpanded(bool value){
    isExpanded = value;
    notifyListeners();
  }

  // Validation for the login form comes in the 
  Future<void> init() async {
    String alumniId = await storage.read(key: "alumni_id") ?? "";
    debugPrint(alumniId);
    final detail = json.decode(await storage.read(key: alumniId) ?? "");
    alumni = AlumniModel.fromJson(json.decode(await storage.read(key: alumniId) ?? ""));
    debugPrint("Alumni profile from storgae: $detail");
    userNameController.text = alumni != null ? alumni!.alumniProfileDetail.name : "Raj kumar";
    collegeNameController.text = alumni != null ? alumni!.alumniProfileDetail.name : "ABC College"; // Default College Name
    depNameController.text = alumni != null ? alumni!.alumniProfileDetail.name : "Computer Science"; // Default Department
    currentOrCcyController.text = alumni != null ? alumni!.alumniProfileDetail.name : "2024"; // Default Year
    linkedUrlController.text = alumni != null ? alumni!.alumniProfileDetail.linkedUrl : "https://linkedin.com/in/rajkumar";
    mobileController.text = alumni != null ? alumni!.alumniProfileDetail.mobile : "8957859299";
    emailController.text = alumni != null ? alumni!.alumniProfileDetail.email : "rajkumar@gmail.com";
    designationController.text = alumni != null ? alumni!.alumniProfileDetail.designation : "Software Developer";
    // Name controller validation
    userNameController.addListener(() {
      if (userNameController.text.isNotEmpty) {
        isUserNameValid = true;
      }else{ 
        isUserNameValid = false;
      }
    },);
    // College name controller validation
    collegeNameController.addListener(() {
      if (collegeNameController.text.isNotEmpty) {
        isCollegNameValid = true;
      }else{ 
        isCollegNameValid = false;
      }
    },);
    // Department name validation
    depNameController.addListener(() {
      if (depNameController.text.isNotEmpty) {
        isdepNameValid = true;
      }else{ 
        isdepNameValid = false;
      }
    },);
    // Studied year or current year validation
    currentOrCcyController.addListener(() {
      if (currentOrCcyController.text.isNotEmpty) {
        isYearValid = true;
      }else{ 
        isYearValid = false;
      }
    },);
    // LinkedIn Url field validation
    linkedUrlController.addListener(() {
      if (linkedUrlController.text.isNotEmpty) {
        isLinkedInUrlValid = true;
      }else{ 
        isLinkedInUrlValid = false;
      }
    },);
    notifyListeners();
  }

  
  void disposeProfile(){
    userNameController.dispose();
    collegeNameController.dispose();
    depNameController.dispose();
    currentOrCcyController.dispose();
    linkedUrlController.dispose();
    mobileController.dispose();
    emailController.dispose();
    designationController.dispose();
    newCollegeController.dispose();
    newDepartmentController.dispose();
    newCurrentYearOrAlumniController.dispose();
    notifyListeners();
  }
}