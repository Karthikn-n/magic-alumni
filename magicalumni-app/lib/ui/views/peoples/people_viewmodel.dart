import 'package:magic_alumni/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PeopleViewmodel extends BaseViewModel{
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  void showConnectionBottomSheet(String name, String linkedURL) async {
    await _bottomSheetService.showBottomSheet(
      title: "Connect with $name",
      
    );
  }

  /// Get all the alumni memebers who are approved by the management
}