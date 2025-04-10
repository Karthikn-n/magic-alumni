import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/model/colleges_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/service/authenticate_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignupViewmodel extends BaseViewModel{
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController collegeNameController = TextEditingController();
  final TextEditingController depNameController = TextEditingController();
  final TextEditingController currentOrCcyController = TextEditingController();
  final TextEditingController linkedUrlController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController designationController = TextEditingController();

  List<CollegesModel> collegesList = [];

  // Navigator router to navigate next screens without context
  final NavigationService _navigationService = locator<NavigationService>();
  // Snackbar service to show the messages in screen
  final SnackbarService _snackbar = locator<SnackbarService>();

  final AuthenticateService auth = locator<AuthenticateService>();
  final ApiService api = locator<ApiService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoad(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  
  bool isUserNameValid = false;
  bool isCollegNameValid = false;
  bool isdepNameValid = false;
  bool isYearValid = false;
  bool isLinkedInUrlValid = false;
  bool isCurrentYearStudent = false;

  bool get isFormValid => isUserNameValid && isCollegNameValid && isdepNameValid && isYearValid && isLinkedInUrlValid;

  CollegesModel? selectedCollege;
  String? selectedDepartment;

  /// Select the college from the API list and set the value to the [selectedCollege]
  void setCollege(CollegesModel collegeName){
    selectedCollege = collegeName;
    if (selectedCollege != null) {
      collegeNameController.text = selectedCollege!.id;
      selectedDepartment = null;
      depNameController.clear();
    }
    notifyListeners();
  }
  /// Get the Department from selected college
  void setDepartment(DepartmentModel departmentName){
    selectedDepartment = departmentName.departmentName;
    depNameController.text = departmentName.id;
    notifyListeners();
  }



  /// Call the colleges API and notfy the listeners
  Future<void> getColleges() async {
    await api.colleges().then((value) => collegesList = value);
    notifyListeners();
  }

  /// Call the Register API 
  Future<void> register() async {
    isLoad = true;
    await auth.register(userData()).then((value) {
      if (value) {
       isLoad = false; 
       navigateHome();
      }
      notifyListeners();
    },);
    isLoad = false; 
    notifyListeners();
  } 

  // Validation for the login form comes in the 
  void init(){
    // Name controller validation
    userNameController.addListener(() {
      if (userNameController.text.isNotEmpty) {
        isUserNameValid = true;
      } else if(RegExp(r'^[A-Za-z ]+$').hasMatch(userNameController.text)) {
        isUserNameValid = false;
      }else{ 
        isUserNameValid = false;
      }
      userNameController.text.trim();
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
      } else { 
        isLinkedInUrlValid = false;
      }
      if(!RegExp(r'^http[s]?:\/\/www\.linkedin\.com\/in\/[a-zA-Z0-9_-]+$').hasMatch(linkedUrlController.text)) { 
        isLinkedInUrlValid = false;
      }
    },);

  }
  
  /// Navigate to home screen once the [isFormValid] is true
  void navigateHome() => _navigationService.replaceWithAppView();
  
  /// Navigate to signin screen
  void navigateSignin() => _navigationService.replaceWithLoginView();
  
  /// Navigate to payment view
  void navigatePayment() => _navigationService.navigateToPaymentView();

  /// Set true for the current year student to change the field hint
  void currentYear(bool isCurrentYearStudent){
    this.isCurrentYearStudent = isCurrentYearStudent;
    currentOrCcyController.clear();
    designationController.clear();
    notifyListeners();
  }

  // Validate snack bar
  void snackBarMessage(){
   if (linkedUrlController.text.isNotEmpty && !isLinkedInUrlValid) {
    _snackbar.showSnackbar(
      message: "Enter a Valid LinkedIn Profile URL",
      duration: const Duration(milliseconds: 1500),
    );
   }else{
    _snackbar.showSnackbar(
      message: "All fields are required",
      duration: const Duration(milliseconds: 1500),
    );
   }
  }
  
  Map<String, dynamic> userData(){
    final alumniData = {
      "name": userNameController.text,
      "linkedin_url": linkedUrlController.text,
      "college_id": [collegeNameController.text],
      "department_id":[depNameController.text],
      "mobile_number": mobileController.text,
      "email": emailController.text,
    };
    if(isCurrentYearStudent) {
      alumniData["role"] = 'Student';
      alumniData["current_year"] = currentOrCcyController.text;
      alumniData["designation"] = "Student";
    }else{
      alumniData["completed_year"] = currentOrCcyController.text;
      alumniData["designation"] = designationController.text;
    }
    return alumniData;
  }
}