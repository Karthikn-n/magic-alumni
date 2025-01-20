import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:stacked/stacked.dart';

class PeopleViewmodel extends BaseViewModel{
  List<AlumniProfileModel> peoplesList = [];

  final ApiService api = locator<ApiService>();

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


}