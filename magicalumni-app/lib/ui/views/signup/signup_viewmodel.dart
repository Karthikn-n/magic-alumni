import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/service/authenticate_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignupViewmodel extends BaseViewModel{
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController collegeNameController = TextEditingController();
  final TextEditingController depNameController = TextEditingController();
  final TextEditingController currentOrCcyController = TextEditingController();
  final TextEditingController linkedUrlController = TextEditingController();

  // Navigator router to navigate next screens without context
  final NavigationService _navigationService = locator<NavigationService>();
  // Snackbar service to show the messages in screen
  final SnackbarService _snackbar = locator<SnackbarService>();

  final AuthenticateService auth = locator<AuthenticateService>();

  bool isUserNameValid = false;
  bool isCollegNameValid = false;
  bool isdepNameValid = false;
  bool isYearValid = false;
  bool isLinkedInUrlValid = false;
  bool isCurrentYearStudent = false;

  bool get isFormValid => isUserNameValid && isCollegNameValid && isdepNameValid && isYearValid && isLinkedInUrlValid;

  // Validation for the login form comes in the 
  void init(){
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

  }

  /// Navigate to home screen once the [isFormValid] is true
  void navigateHome() => _navigationService.replaceWithAppView();
  
  /// Navigate to signin screen
  void navigateSignin() => _navigationService.replaceWithLoginView();
  

  /// Set true for the current year student to change the field hint
  void currentYear(bool isCurrentYearStudent){
    this.isCurrentYearStudent = isCurrentYearStudent;
    notifyListeners();
  }

  // Validate snack bar
  void snackBarMessage(){
   _snackbar.showSnackbar(
      message: "All fields are required",
      duration: const Duration(milliseconds: 1500),
    );
  }

  Map<String, dynamic> userData(){
    final alumniData = {
      "alumni_name": userNameController.text,
      "linkedin_url": linkedUrlController.text,
      "college_name": [collegeNameController.text],
      "department_name":[depNameController.text],
    };
    if(isCurrentYearStudent) {
      alumniData["current_year_student"] = true;
      alumniData["current_year"] = currentOrCcyController.text;
    }else{
      alumniData["current_year_student"] = false;
      alumniData["passed_out_year"] = currentOrCcyController.text;
    }
    return alumniData;
  }
}