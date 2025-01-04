import 'package:magic_alumni/service/api_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewmodel extends BaseViewModel {
  int selectedIndex = 0;

  /// Use API Service to get the news from the API
  final ApiService apiService = ApiService();
  /// Select the college card
  void selectOtherCollege(int value){
    selectedIndex = value;
    notifyListeners();
  }
}