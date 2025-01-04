import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/jobs/create-job/create_job_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../../constants/app_constants.dart';
import '../../../../widgets/common/text_field.dart';

class CreateJobView extends StatelessWidget {
  const CreateJobView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CreateJobViewmodel(),
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
                    padding: const EdgeInsets.only(top: kToolbarHeight  - 16),
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: ListTile(
                        // dense: true,
                        minLeadingWidth: size.width * 0.3,
                        titleAlignment: ListTileTitleAlignment.titleHeight,
                        leading: BackButton(
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                        title: Text(
                          "Create Job", 
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
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
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 15,
                      children: [
                        const SizedBox(height: 20,),
                        // event title text field
                        TextFieldWidget(
                          controller: model.titleController,
                          hintText: "Job Title",
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.event, size: 20, color: Theme.of(context).primaryColor,),
                        ),
                        TextFieldWidget(
                          controller: model.locationController,
                          hintText: "Job Location",
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.pin_drop_rounded, size: 20, color: Theme.of(context).primaryColor,),
                        ),
                        TextFieldWidget(
                          controller: model.dateController,
                          hintText: "Last Date to Apply",
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.calendar_month, size: 20, color: Theme.of(context).primaryColor,),
                          onTap: () async{
                            DateTime? selectDate = await showDatePicker(
                              context: context, 
                              firstDate: DateTime.now(), 
                              lastDate: DateTime(2100)
                            );
                            if (selectDate != null) {
                              model.pickedLastDate(selectDate);
                            }
                          },
                        ),
                        TextFieldWidget(
                          controller: model.jobLinkController,
                          hintText: "Job Link / Mail ID",
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.link, size: 20, color: Theme.of(context).primaryColor,),
                        ),
                         Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton(
                              icon: Container(),
                              value: model.selectedJobType,
                              hint: Row(
                                spacing: 15,
                                children: [
                                  Icon(Icons.work_outline, size: 20, color: Theme.of(context).primaryColor,),
                                  Text("Job Type", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black45),),
                                ],
                              ),
                              underline: Container(),
                              items: model.jobTypes.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value, style: TextStyle(fontSize: 14),)
                                );
                              },).toList(), 
                              onChanged: <String>(value) {
                                if (value != null) {
                                  model.selectedJobTypeValue(value);
                                }
                              },
                            ),
                          ),
                        ),
                        
                        TextFieldWidget(
                          controller: model.criteriaController,
                          hintText: "Criteria",
                          textInputAction: TextInputAction.next,
                        ),
                         SizedBox(
                          width: size.width,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () {
                              
                            },
                            child: Text(
                              'Post Job',
                              style: textStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(),
                      ],
                    ),
                  ),
                )
              ),
            ],
          ),
          
        );
      }
    );
  }
}