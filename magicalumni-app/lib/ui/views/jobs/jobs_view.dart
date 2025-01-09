import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/jobs/job_viewmodel.dart';
import 'package:magic_alumni/widgets/common/text_field.dart';
import 'package:magic_alumni/widgets/jobs/job_list_widget.dart';
import 'package:stacked/stacked.dart';

class JobsView extends StatelessWidget {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => JobViewModel(),
      onViewModelReady: (viewModel) async => await viewModel.jobs(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Stack(
              children: [
                // Background color and title
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: kToolbarHeight),
                      child: Text(
                        "Jobs", 
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  top: size.height * 0.15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        spacing: 10,
                        children: [
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
                ),
                    
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => model.navigateToCreateJob(),
            backgroundColor: Theme.of(context).primaryColor,
            tooltip: "Create Job",
            child: Icon(CupertinoIcons.plus, color: Colors.white,),
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