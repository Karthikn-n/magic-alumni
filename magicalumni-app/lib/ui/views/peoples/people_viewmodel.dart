import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:stacked/stacked.dart';

class PeopleViewmodel extends BaseViewModel{
  List<AlumniProfileModel> peoplesList = [];

  final ApiService api = locator<ApiService>();
  bool isLoad = false;
  String status = "";
  String mobileNumber = "";

  final ScrollController controller = ScrollController();

  /// Get all the Alumni and Students from the API 
  Future<void> peoples() async {
    if (api.peoplesList.isEmpty) {
      await api.peoples().then((value) {
          peoplesList = value;
          notifyListeners();
      },);
    } else {
      peoplesList = api.peoplesList;
      notifyListeners();
    }
    notifyListeners();
  }

  /// check the mobile request status for the alumni
  Future<void> checkStatus(String receiverId) async {
    status = "";
    mobileNumber = "";
    isLoad = true;
    await api.checkStatus(receiverId).then((value) {
      status = value["requestStatus"];
      mobileNumber = value["receiverMobileNumber"];
      isLoad = false;
      notifyListeners();
    },);
    notifyListeners();
  }



}