import 'package:stacked/stacked.dart';

class HomeViewmodel extends BaseViewModel {
  int selectedIndex = 0;

  /// Select the college card
  void selectOtherCollege(int value){
    selectedIndex = value;
    notifyListeners();
  }
}