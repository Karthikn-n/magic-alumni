import 'package:flutter/material.dart';
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
  void init(){
    userNameController.text = "Raj kumar";
    collegeNameController.text = "ABC College"; // Default College Name
    depNameController.text = "Computer Science"; // Default Department
    currentOrCcyController.text = "2024"; // Default Year
    linkedUrlController.text = "https://linkedin.com/in/rajkumar";
    mobileController.text = "8957859299";
    emailController.text = "rajkumar@gmail.com";
    designationController.text = "Software Developer";
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