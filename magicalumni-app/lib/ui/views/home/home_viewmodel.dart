import 'package:magic_alumni/model/news_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewmodel extends BaseViewModel {
  int selectedIndex = 0;

  List<NewsModel> newsList = [];
  /// Use API Service to get the news from the API
  final ApiService apiService = ApiService();
  /// Select the college card
  void selectOtherCollege(int value){
    selectedIndex = value;
    notifyListeners();
  }

  /// Call the news API and store if the news get from the API or return empty list
  Future<void> news() async {
    apiService.news().then((value) => newsList = value,);
    notifyListeners();
  }
}