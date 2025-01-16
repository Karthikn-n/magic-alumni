import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PeopleViewmodel extends BaseViewModel{
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  List<AlumniProfileModel> peoplesList = [];

  final ApiService api = locator<ApiService>();

  /// Get all the Alumni and Students from the API 
  Future<void> peoples() async {
    if (api.jobsList.isEmpty) {
      await api.peoples().then((value) {
          peoplesList = value;
          notifyListeners();
      },);
    } else {
      peoplesList = api.peoplesList;
      notifyListeners();
    }
  }

  void showConnectionBottomSheet(String name, String linkedURL) async {
    await _bottomSheetService.showBottomSheet(
      title: "Connect with $name",
      
    );
  }

  /// Get all the alumni memebers who are approved by the management
}