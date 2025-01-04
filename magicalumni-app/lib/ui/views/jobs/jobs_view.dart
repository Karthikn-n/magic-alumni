import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/jobs/job_viewmodel.dart';
import 'package:magic_alumni/widgets/common/text_field.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/people/filter_button.dart';

class JobsView extends StatelessWidget {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> jobTitles = [
      "Software Engineer",
      "Data Scientist",
      "Cloud Architect",
      "DevOps Engineer",
      "UI/UX Designer",
      "Mobile App Developer",
      "Cybersecurity Analyst",
      "Machine Learning Engineer",
      "Database Administrator",
      "IT Project Manager"
    ];
    List<String> locations = [
      "San Francisco, CA",
      "New York, NY",
      "Seattle, WA",
      "Austin, TX",
      "Boston, MA",
      "Chicago, IL",
      "Denver, CO",
      "Atlanta, GA",
      "Los Angeles, CA",
      "Dallas, TX"
    ];
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => JobViewModel(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: Stack(
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
                        // Filer options
                          Material(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    FilterButton(
                                      buttonName: "Internship", 
                                      // backgroundColor: Theme.of(context).primaryColor,
                                      onPressed: (){}
                                    ),
                                    FilterButton(
                                      buttonName: "Jobs", 
                                      onPressed: (){}
                                    ),
                                  ],
                                ),
                                // IconButton(
                                //   onPressed: () {} , 
                                //   icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryColor,)
                                // )
                                // FilterButton(
                                //   buttonName: "Clear", 
                                //   onPressed: (){}
                                // )
                              ],
                            ),
                          ),
                        // List of jobs
                        Expanded(
                          child: ListView.builder(
                            itemCount: jobTitles.length,
                            itemBuilder: (context, index) {
                              return Material(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                child: Column(
                                  children: [
                                    // Job List tile 
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black.withValues(alpha: 0.06), width: 1),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child:  Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            spacing: 10,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                spacing: 15,
                                                children: [
                                                  CircleAvatar(
                                                    child:  Icon(Icons.work_history),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        jobTitles[index], 
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Color(0xFF161719),
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                      Text(
                                                        locations[index],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black26
                                                        ),
                                                      ),
                                                      
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: "Apply within: ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black45
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: "13 Mar 2025",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black45,
                                                      )
                                                    )
                                                  ]
                                                )
                                              ),
                                              
                                            ],
                                          ),
                                          Material(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              spacing: 20,
                                              children: [
                                                InkWell(
                                                  splashColor: Colors.transparent.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(10),
                                                  radius: 20,
                                                  onTap: () {
                                                    
                                                  }, 
                                                  child: Icon(CupertinoIcons.link, color: Theme.of(context).primaryColor, size: 20,)
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showReportDialog(context);
                                                  }, 
                                                  child: Icon(Icons.report_outlined, color: Theme.of(context).primaryColor, size: 20,)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: index == jobTitles.length - 1 ? 66: 10,)
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        
            ],
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
                    ElevatedButton(onPressed: (){}, child: Text("Cancel", style: textStyle,)),
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