import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/model/colleges_model.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:magic_alumni/ui/widgets/common/loading_button_widget.dart';
import 'package:magic_alumni/ui/widgets/common/text_field.dart';
import 'package:stacked/stacked.dart';

class EditProfileWidget extends StackedView<ProfileViewmodel>{
  const EditProfileWidget({super.key});

  @override
  Widget builder(BuildContext context, ProfileViewmodel model, Widget? child) {
    // Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20,),
          onPressed: () {
            model.isEditing = false;
            model.onCancelEdit();
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Space padding for the tabs from above (below) card in stack
              // SizedBox(height: size.height * 0.1,),
              Column(
                spacing: 10,
                children: [
                  Container(),
                  // Name textfield
                  TextFieldWidget(
                    controller: model.userNameController,
                    hintText: "Full Name",
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => model.isEditing = true,
                  ),
                  // LinkedIn profile URL text field
                  TextFieldWidget(
                    controller: model.linkedUrlController,
                    hintText: "LinkedIn Profile URL",
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => model.isEditing = true
                  ),
                  // college name field
                  TextFieldWidget(
                    controller: model.collegeNameController,
                    hintText: "College Name",
                    readOnly: true,
                    fillColor: Colors.grey[300],
                    onTap: () => model.showCantEdit(),
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => model.isEditing = true
                  ),
                  // Department name field
                  TextFieldWidget(
                    controller: model.depNameController,
                    hintText: "Department Name",
                    readOnly: true,
                    fillColor: Colors.grey[300],
                    onTap: () => model.showCantEdit(),
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => model.isEditing = true
                  ),
                  // current year or passed out year text field
                  TextFieldWidget(
                    controller: model.currentOrCcyController,
                    hintText: "Current year/ Passed Out Year",
                    readOnly: true,
                    onTap: () => model.showCantEdit(),
                    fillColor: Colors.grey[300],
                    keyboardType: model.isCurrentYearStudent ? null: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => model.isEditing = true
                  ),
                  // Email text field
                  TextFieldWidget(
                    controller: model.emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => model.isEditing = true
                  ),
                  // Mobile text field
                  TextFieldWidget(
                    controller: model.mobileController,
                    hintText: "Mobile number",
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => model.isEditing = true
                  ),
                  // Designation text field
                  model.alumni != null && model.alumni!.alumniProfileDetail.role == "Student"
                    ? Container()
                    : TextFieldWidget(
                    controller: model.designationController,
                    hintText: "Desgination",
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => model.isEditing = true
                  ),
                  // Add new college Section if the user need to add new college
                  // model.alumni != null && model.alumni!.alumniProfileDetail.role == "Student"
                  //   ? Container()
                  //   :
                  ExpansionTile(
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    onExpansionChanged: (value) async{
                      model.checkExpanded(value);
                      model.collegesList.isEmpty ? await model.getColleges() : null;
                    },
                    title: Text("Add College", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                    children: [
                      const SizedBox(height: 10,),
                      // New college Name text Field
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: DropdownButton<CollegesModel>(
                          isExpanded: true,
                          hint: Row(
                            spacing: 15,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Image.asset(
                                  "assets/icon/college.png", color: Theme.of(context).primaryColor,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                model.selectedCollege != null ? model.selectedCollege!.collegeName : "Colleges", 
                                style: TextStyle(
                                  fontWeight: FontWeight.w400, 
                                  fontSize: model.selectedCollege != null ? 14 :12, 
                                  color: model.selectedCollege != null ? Colors.black : Colors.black45
                                ),
                              ),
                            ],
                          ),
                          // value: model.selectedCollege!,
                          underline: Container(),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          items: model.api.collegesList.map((value) {
                            return DropdownMenuItem<CollegesModel>(
                              value: value,
                              child: Text(value.collegeName, style: TextStyle(fontSize: 14),)
                            );
                          },).toList(), 
                          onChanged: (value) {
                            if(value != null){
                              model.setCollege(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      // Department Drop down button 
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Row(
                            spacing: 15,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Image.asset(
                                  "assets/icon/department.png", color: Theme.of(context).primaryColor,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                model.selectedDepartment != null ? model.selectedDepartment! : "Select Department", 
                                style: TextStyle(
                                  fontWeight: FontWeight.w400, 
                                  fontSize: model.selectedDepartment != null ? 14 : 12, 
                                  color: model.selectedDepartment != null ? Colors.black : Colors.black45
                                ),
                              ),
                            ],
                          ),
                          // value: model.selectedCollege!,
                          underline: Container(),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          items:  model.selectedCollege?.departments.map((value) {
                            return DropdownMenuItem<DepartmentModel>(
                              value: value,
                              child: Text(value.departmentName, style: TextStyle(fontSize: 14),)
                            );
                          },).toList(), 
                          onChanged: (value) {
                            if(value != null){
                              model.setDepartment(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      // Current year or passed out year text field
                      TextFieldWidget(
                          controller: model.newCurrentYearOrAlumniController,
                          prefixIcon: Icon(CupertinoIcons.calendar, color: Theme.of(context).primaryColor, size: 20,),
                          hintText: model.isCurrentYearStudent ? "Current Academic Year" : "Passed Out Year",
                          textInputAction: TextInputAction.next,
                          maxLength: model.isCurrentYearStudent ? 1: 4,
                          keyboardType: TextInputType.number,
                        ),
                        
                      const SizedBox(height: 10,),
                      // check box for current year students
                      CheckboxListTile(
                        dense: true,
                        checkboxScaleFactor: 0.8,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(horizontal: -4,),
                        value: model.isCurrentYearStudent,
                        controlAffinity: ListTileControlAffinity.leading, 
                        title: Text("Current Year Student", 
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        onChanged: (value) {
                          model.changeStudentStatus(value!);
                        },
                      ),
                      // Send to permission to the admin
                      model.isLoad
                      ? LoadingButtonWidget()
                      : ElevatedButton(
                        onPressed: () async {
                          model.validateAddCollege();
                          if (model.isAddCollegeValid) {
                            await model.addCollege();
                          }
                        },
                        child: Text(
                          'Send Request to Admin',
                          style: textStyle,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  model.isExpanded
                    ? Container()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: model.isEdited ? null : Theme.of(context).primaryColor.withValues(alpha: 0.4)
                              ),
                              onPressed: () async { 
                                model.isEdited
                                ? await model.update()
                                : null;
                              },
                              child: Text(
                                'Save',
                                style: textStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: model.isEdited ? null : Theme.of(context).primaryColor.withValues(alpha: 0.4)
                              ),
                              onPressed: () {
                                model.isEditing = false;
                                model.onCancelEdit();
                                FocusScope.of(context).unfocus();
                              },
                              child: Text(
                                'Cancel',
                                style: textStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 20,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ProfileViewmodel viewModelBuilder(BuildContext context) => ProfileViewmodel();

  @override
  void onViewModelReady(ProfileViewmodel viewModel) async{
    super.onViewModelReady(viewModel);
    await viewModel.fetchAlumni().then((value) => viewModel.init(),);
  } 
}