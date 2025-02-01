import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/service/authenticate_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../model/colleges_model.dart';

class ProfileViewmodel extends BaseViewModel{
  
  int selectedIndex = 0;
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
  bool _isEdited = false;

  bool isAddCollegeValid = false;



  bool get isFormValid => isUserNameValid && isCollegNameValid && isdepNameValid && isYearValid && isLinkedInUrlValid;
  bool get isEdited => _isEdited;

  set isEditing(bool isEdit){
    _isEdited = isEdit;
    notifyListeners();
  }

  AlumniModel? alumni;
  late PageController pageController = pageController =  PageController(initialPage: selectedIndex);
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final AuthenticateService auth = locator<AuthenticateService>();
  final NavigationService navigation = locator<NavigationService>();
  final ApiService api = locator<ApiService>();
  final DialogService dialogService = locator<DialogService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  List<CollegesModel> collegesList = [];
  CollegesModel? selectedCollege;
  String? selectedDepartment;

  bool isLoad = false;

  void selectCollege(int index) async {
    
    pageController =  PageController(initialPage: int.parse(await storage.read(key: "college") ?? "0"));
    notifyListeners();
  }

  /// Confirmation for changing college
  void changeConfirmation(String collegeName, int index) async {
   final  result = await dialogService.showConfirmationDialog(
      title: "Want to change the current college to $collegeName",
      description: "Once your college changed app will load news, events and alumni from the $collegeName",
      confirmationTitle: "Change"
    );
    if (result != null && result.confirmed) {
      await storage.write(key: "college", value: "$index");
      pageController =  PageController(initialPage: index);
      selectedIndex = index;
      // TODO: call news API with new collegeID
    } else {
      await storage.write(key: "college", value: "$index");
      pageController =  PageController(initialPage: int.parse(await storage.read(key: "college") ?? "0"));
    }
    notifyListeners();
  }

  /// Select the college from the API list and set the value to the [selectedCollege]
  void setCollege(CollegesModel collegeName){
    selectedCollege = collegeName;
    if (selectedCollege != null) {
      collegeNameController.text = selectedCollege!.id;
    }
    notifyListeners();
  }
  
  /// Get the Department from selected college
  void setDepartment(DepartmentModel departmentName){
    selectedDepartment = departmentName.departmentName;
    depNameController.text = departmentName.id;
    notifyListeners();
  }
  
  // change the current student status on the profile screen
  void changeStudentStatus(bool value){
    newCurrentYearOrAlumniController.clear();
    isCurrentYearStudent = value;
    notifyListeners();
  }
  
  // check the new college is expanded or not
  void checkExpanded(bool value){
    isExpanded = value;
    if(!value) {
      selectedCollege = null;
      selectedDepartment = null;
      newCollegeController.clear();
      newDepartmentController.clear();
      newCurrentYearOrAlumniController.clear();
      isCurrentYearStudent = false;
    } 
    notifyListeners();
  }

  /// Call the colleges API and notfy the listeners
  Future<void> getColleges() async {
    await api.colleges().then((value) => collegesList = value);
    notifyListeners();
  }


  Future<void> update() async {
     final alumniData = {
      'id': await storage.read(key: "alumni_id"),
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
    await auth.update(alumniData).then((value) async {
      if(value) {
        await init();
        isEditing = false;
      }
      notifyListeners();
    },);
  }

  // Validation for the login form comes in the 
  Future<void> init() async {
    if (auth.alumni != null) {
      alumni = auth.alumni;
      debugPrint("Called 1");
    }else{
      debugPrint("Called 2");
     alumni = await auth.fetchAlumni();
    }
    debugPrint("Alumni is null ${alumni == null}");
    userNameController.text = alumni != null ? alumni!.alumniProfileDetail.name : "Raj kumar";
    collegeNameController.text = alumni != null ? alumni!.colleges[0].collegeName : "ABC College"; // Default College Name
    depNameController.text = alumni != null ? alumni!.colleges[0].departments[0].departmentName : "Computer Science"; // Default Department
    currentOrCcyController.text = alumni != null ? alumni!.colleges[0].completedYear.isEmpty ? alumni!.colleges[0].currentYear : alumni!.colleges[0].completedYear : "2024"; // Default Year
    linkedUrlController.text = alumni != null ? alumni!.alumniProfileDetail.linkedUrl : "https://linkedin.com/in/rajkumar";
    mobileController.text = alumni != null ? alumni!.alumniProfileDetail.mobile : "8957859299";
    emailController.text = alumni != null ? alumni!.alumniProfileDetail.email : "rajkumar@gmail.com";
    designationController.text = alumni != null ? alumni!.alumniProfileDetail.designation : "Software Developer";
    // Name controller validationmodel.alumni!.colleges[index].collegeName
    rebuildUi();
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
    rebuildUi();
  }

  Future confirmLogout() async {
    final response = await dialogService.showConfirmationDialog(
      title: "Want to logout?",
      dialogPlatform: DialogPlatform.Material,
      confirmationTitle: "logout",
    );
    if (response?.confirmed == true) {
      await onLogout();
    }
  }


  /// Show snackbar if the Alumni is not added the fields in the Profile
  void validateAddCollege() {
    isAddCollegeValid = selectedCollege != null || selectedDepartment != null || newCurrentYearOrAlumniController.text.isEmpty;
    if (!isAddCollegeValid) {
      _snackbarService.showSnackbar(message: "All field required", duration: const Duration(milliseconds: 1200));
    }
    notifyListeners();
  }

  /// Call the Add college API with Data
  Future<void> addCollege() async {
    isLoad = true;
    Map<String, dynamic> collegeData = {
      "college_id": selectedCollege!.id,
      "department_id": selectedCollege!.departments.firstWhere((element) => element.departmentName == selectedDepartment,).id,
      "alumni_id": await storage.read(key: "alumni_id")
    };
    if (isCurrentYearStudent) {
      collegeData["current_year"] = newCurrentYearOrAlumniController.text;
    }else{
      collegeData["completed_year"] = newCurrentYearOrAlumniController.text;
    }
    debugPrint("Added college: $collegeData");
    await api.addCollege(collegeData).then((value) async {
      debugPrint("Added: $value");
      if (value) {
        alumni = await auth.fetchAlumni();
        isLoad = false;
        checkExpanded(false);
        notifyListeners();
      }
    },);
    notifyListeners();
  }

  Future<void> onLogout() async {
    await storage.deleteAll();
    navigation.pushNamedAndRemoveUntil(Routes.loginView, predicate: (route) => false,);
    notifyListeners();
    debugPrint("Logout");
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
  }
}