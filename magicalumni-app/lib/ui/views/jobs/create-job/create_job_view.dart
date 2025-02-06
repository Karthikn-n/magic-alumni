import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/jobs/create-job/create_job_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../../constants/app_constants.dart';
import '../../../widgets/common/text_field.dart';

class CreateJobView extends StatelessWidget {
  const CreateJobView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CreateJobViewmodel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      onDispose: (viewModel) => viewModel.onDispose(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading:  BackButton(
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
            title:  Text(
              "Create Job", 
              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
            ) ,
            centerTitle: true,
          ),
          body: Container(
            height: MediaQuery.sizeOf(context).height,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    controller: model.companyNameController,
                    hintText: "Company Name",
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(CupertinoIcons.building_2_fill, size: 20, color: Theme.of(context).primaryColor,),
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
                        value: model.selectedJobType,
                        hint: Row(
                          spacing: 15,
                          children: [
                            Icon(Icons.work_outline, size: 20, color: Theme.of(context).primaryColor,),
                            Text("Job Type", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black45),),
                          ],
                        ),
                        isExpanded: true,
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
                    controller: model.tagController,
                    hintText: "Tags",
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(CupertinoIcons.tag, size: 20, color: Theme.of(context).primaryColor,),
                    suffixIcon: IconButton(onPressed: () => model.addTag(model.tagController.text), icon: Icon(CupertinoIcons.add, size: 20, color: Theme.of(context).primaryColor,)),
                  ),
                  model.tags.isNotEmpty
                  ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 5.0,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(model.tags.length, (index) {
                        return InkWell(
                          onTap: () {
                            model.addTag(model.tags[index], remove: true, index: index);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Theme.of(context).primaryColor)
                            ),
                            child: Row(
                              spacing: 4.0,
                              children: [
                                Text(model.tags[index], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),),
                                Icon(CupertinoIcons.xmark_circle, size: 18, color: Colors.red,)
                              ],
                            ),
                          ),
                        );
                      },),
                    ),
                  )
                : Container(),
                   SizedBox(
                    width: size.width,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        debugPrint("${await model.jobData()}");
                        model.isFormValid
                          ? await model.jobs.jobCreate(await model.jobData()).then((value) => value ? Navigator.pop(context) : null,)
                            
                          : model.showSnackBar();
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
          ),
          
        );
      }
    );
  }
}