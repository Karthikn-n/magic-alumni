import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/model/jobs_model.dart';
import 'package:url_launcher/url_launcher.dart';

class JobListWidget extends StatelessWidget {
  final List<JobsModel> jobs;
  final VoidCallback? onReportTap;
  const JobListWidget({
    super.key, 
    required this.jobs, 
    this.onReportTap
  });

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        return Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                tileColor: Colors.white,
                horizontalTitleGap: 10.0,
                // leading:  CircleAvatar(
                //   child:  Icon(Icons.work_history),
                // ),
                title:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobs[index].title, 
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF161719),
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      jobs[index].companyName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black26
                      ),
                    ),
                    const SizedBox(height: 5,),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_pin, size: 20, color: Colors.black45,),
                    Text(
                      jobs[index].location,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45
                      ),
                    ),
                    // RichText(
                    //   text: TextSpan(
                    //     text: "Apply within: ",
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //       color: Colors.black45
                    //     ),
                    //     children: [
                    //       TextSpan(
                    //         text: DateFormat("dd MMM yyyy").format(DateTime.parse(jobs[index].lastDate)),
                    //         style: TextStyle(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w500,
                    //           color: Colors.black45,
                    //         )
                    //       )
                    //     ]
                    //   )
                    // ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      radius: 20,
                      onTap: () async {
                        await launchUrl(Uri.parse(jobs[index].applyLink));
                      }, 
                      child: Icon(CupertinoIcons.link, color: Theme.of(context).primaryColor, size: 20,)
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: onReportTap, 
                      child: Icon(Icons.report_outlined, color: Theme.of(context).primaryColor, size: 20,)
                    ),
                  ],
                ),
              ),
              SizedBox(height: index == jobs.length - 1 ? 66: 10,)
            ],
          ),
        );
        
       
      },
    );
  }
}