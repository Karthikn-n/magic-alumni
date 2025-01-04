import 'package:flutter/cupertino.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/ui/views/jobs/create-job/create_job_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class JobViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  final TextEditingController reportController = TextEditingController();

  // Navigate to the create job View
  void navigateToCreateJob() =>
    _navigationService.navigateWithTransition(CreateJobView(), transitionStyle: Transition.downToUp);
  

  void showReportDialog(){
    _dialogService.showDialog(
      title: "Report this Job",

    );
  }
}