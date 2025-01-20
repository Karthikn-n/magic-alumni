import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/jobs/job_viewmodel.dart';
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
                        ),
                        JobListWidget(
                          jobs: model.jobsList.where((element) => element.jobType == "Intern",).toList(),
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
              return role.alumni != null && role.alumni!.alumniProfileDetail.role == "Alumni Co-ordinator"
               ? FloatingActionButton(
                    onPressed: () => model.navigateToCreateJob(),
                    backgroundColor: Theme.of(context).primaryColor,
                    tooltip: "Create Job",
                    child: Icon(CupertinoIcons.plus, color: Colors.white,),
                  )
              : Container();
            }
          ),
        );
      }
    );
  }

 
}