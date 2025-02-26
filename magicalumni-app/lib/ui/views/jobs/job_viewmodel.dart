import 'package:flutter/cupertino.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/model/jobs_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/ui/views/jobs/create-job/create_job_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class JobViewModel extends BaseViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  final TextEditingController reportController = TextEditingController();

  final ApiService job = locator<ApiService>();

  List<JobsModel> jobsList = [];

  // Navigate to the create job View
  void navigateToCreateJob() =>
    _navigationService.navigateWithTransition(CreateJobView(), transitionStyle: Transition.downToUp);

  /// Get all the Jobs from the API and store it in the List
  Future<void> jobs() async {
    if (job.jobsList.isEmpty) {
      await job.jobs().then((value) {
        debugPrint("Job Length ${value.length}");
        jobsList = value;
        notifyListeners();
      });
    } else{
      jobsList = job.jobsList;
      notifyListeners();
    }
  }

  void showReportSnackBar() 
  => _snackbarService.showSnackbar(message: "Enter a report to send admin", duration: const Duration(milliseconds: 1200));


}