import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/model/jobs_model.dart';
import 'package:magic_alumni/ui/views/jobs/job_viewmodel.dart';
import 'package:magic_alumni/widgets/common/text_field.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class JobListWidget extends StatelessWidget {
  final List<JobsModel> jobs;
  const JobListWidget({
    super.key, 
    required this.jobs, 
  });

  @override
  Widget build(BuildContext context) {
    return jobs.isEmpty
    ? key == Key("job")
      ? Center(
          child: Text("There is no jobs"),
        )
      : Center(
          child: Text("There is no internship"),
        )
    : RefreshIndicator(
      onRefresh: () async => await JobViewModel().jobs(),
      child: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          return Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        horizontalTitleGap: 10.0,
                        shape: RoundedRectangleBorder(
                          
                        ),
                        title:  Text(
                          jobs[index].title, 
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF161719),
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        subtitle: Text(
                              DateTime.parse(jobs[index].lastDate).difference(DateTime.now()).inDays == 1
                              ? "${DateTime.parse(jobs[index].lastDate).difference(DateTime.now()).inDays} Day left"
                              : "${DateTime.parse(jobs[index].lastDate).difference(DateTime.now()).inDays} Days left",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black26
                              ),
                            ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(left: 9.0),
                          child: PopupMenuButton(
                            iconSize: 20,
                            color: Colors.white,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Text("Report"),
                                  onTap:() async {
                                    showReportDialog(context, jobs[index].id);
                                  },
                                )
                              ];
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        minLeadingWidth: 22.0,
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.shade200
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.business_outlined, size: 18, color: Theme.of(context).primaryColor,),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            jobs[index].companyName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                            ),
                          ),
                        ),
                        subtitle: Row(
                          spacing: 4,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.pin_drop_outlined, size: 18, color: Colors.black26,),
                            Text(
                              jobs[index].location,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black26
                              ),
                            ),
                          ],
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Material(
                            child: IconButton(
                              splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                              onPressed: () async => await launchUrl(Uri.parse(jobs[index].applyLink)),
                              icon: Text(
                                "Apply >",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: index == jobs.length - 1 ? 66: 10,)
              ],
            ),
          );
          
         
        },
      ),
    );
  }
   void showReportDialog(BuildContext context, String jobId){
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
                    ElevatedButton(
                      onPressed: () async {
                        model.reportController.text.isEmpty
                        ? model.showReportSnackBar()
                        : await model.job.reportJob(jobId, model.reportController.text).then((value) {
                              if(value) Navigator.pop(context); 
                            }
                          );
                      }, 
                      child: Text("Report", style: textStyle,)
                    ),
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