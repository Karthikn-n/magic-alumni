import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/jobs/job_viewmodel.dart';
import 'package:magic_alumni/widgets/common/text_field.dart';
import 'package:magic_alumni/widgets/jobs/job_list_widget.dart';
import 'package:stacked/stacked.dart';

import '../profile/profile_viewmodel.dart';

class JobsView extends StatelessWidget {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => JobViewModel(),
      onViewModelReady: (viewModel) async => await viewModel.jobs(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title:  Text(
              "Jobs", 
              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
            ) ,
            centerTitle: true,
          ),
          body: DefaultTabController(
            length: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
              ),
              child: Column(
                spacing: 10,
                children: [
                  Container(),
                  // List of jobs
                  TabBar(
                    padding: EdgeInsets.zero,
                    tabAlignment: TabAlignment.center,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: "Jobs",),
                      Tab(text: "Internship",),
                    ]
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        JobListWidget(
                          jobs: model.jobsList.where((element) => element.jobType == "Job",).toList(),
                          onReportTap: () => showReportDialog(context),
                        ),
                        JobListWidget(
                          jobs: model.jobsList.where((element) => element.jobType == "Intern",).toList(),
                          onReportTap: () => showReportDialog(context),
                        ),
                      ]
                    )
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: ViewModelBuilder.reactive(
            viewModelBuilder: () => ProfileViewmodel(),
            builder: (ctx, role, child) {
              return 
              // role.alumni != null && role.alumni!.alumniProfileDetail.role != "1"
              //  ?
                FloatingActionButton(
                onPressed: () => model.navigateToCreateJob(),
                backgroundColor: Theme.of(context).primaryColor,
                tooltip: "Create Job",
                child: Icon(CupertinoIcons.plus, color: Colors.white,),
              );
              // : Container();
            }
          ),
        );
      }
    );
  }

  void showReportDialog(BuildContext context){
    showDialog(
      context: context, 
      builder: (ctx) {
        return ViewModelBuilder.reactive(
          viewModelBuilder: () => JobViewModel(),
          builder: (modelctx, model, child) {
            return SimpleDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              title: Text("Report this Job", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
              children: [
                TextFieldWidget(
                  controller: model.reportController,
                  maxLines: 5,
                  hintText: "Report the Job...",
                ),
                const SizedBox(height: 10,),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: textStyle,)),
                    ElevatedButton(onPressed: (){}, child: Text("Report", style: textStyle,)),
                  ],
                ),
              ],
            );
          }
        );
      },
    );
  }
}