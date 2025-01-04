import 'package:stacked/stacked.dart';

class AppViewModel extends BaseViewModel{
  int index = 0;
  // Images 
  List<String> images = [
    "assets/bottom/home.png",
    "assets/bottom/events.png",
    "assets/bottom/connections.png",
    "assets/bottom/jobs.png",
    "assets/bottom/profile.png",
    ];
  void onTapped(int index){
    this.index = index;
    notifyListeners();
  }
}