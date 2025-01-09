import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/model/colleges_model.dart';
import 'package:magic_alumni/ui/views/signup/signup_viewmodel.dart';
import 'package:magic_alumni/widgets/common/loading_button_widget.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/common/text_field.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder<SignupViewmodel>.reactive(
      viewModelBuilder: () => SignupViewmodel(),
      onViewModelReady: (viewModel) async {
        viewModel.init();
        await viewModel.getColleges();
      },
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
              ),
              Positioned(
                top: size.height * 0.15,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                    )
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: commonPadding),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 35,),
                        Text("Signup", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                        Text("Enter your information", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black45),),
                        Column(
                          spacing: 10,
                          children: [
                            Container(),
                            // Name textfield
                            TextFieldWidget(
                              controller: model.userNameController,
                              hintText: "Full Name",
                              prefixIcon: Icon(CupertinoIcons.person, color: Theme.of(context).primaryColor, size: 20),
                              textInputAction: TextInputAction.next,
                            ),
                            // LinkedIn profile URL text field
                            TextFieldWidget(
                              controller: model.linkedUrlController,
                              hintText: "LinkedIn Profile URL",
                              maxLines: 1,
                              prefixIcon: Icon(CupertinoIcons.link, color: Theme.of(context).primaryColor, size: 20,),
                              textInputAction: TextInputAction.next,
                            ),
                            // college name field
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
                                items: model.auth.collegesList.map((value) {
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
                            // Mobile number field
                            TextFieldWidget(
                              controller: model.mobileController,
                              prefixIcon: Icon(CupertinoIcons.phone, color: Theme.of(context).primaryColor, size: 20,),
                              hintText: "Mobile Number",
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            // Email field
                            TextFieldWidget(
                              controller: model.emailController,
                              prefixIcon: Icon(CupertinoIcons.mail, color: Theme.of(context).primaryColor, size: 20,),
                              hintText: "Email",
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            // current year or passed out year text field
                            TextFieldWidget(
                              controller: model.currentOrCcyController,
                              prefixIcon: Icon(CupertinoIcons.calendar, color: Theme.of(context).primaryColor, size: 20,),
                              hintText: model.isCurrentYearStudent ? "Current Academic Year" : "Passed Out Year",
                              textInputAction: TextInputAction.next,
                              maxLength: model.isCurrentYearStudent ? 1: 4,
                              keyboardType: TextInputType.number,
                            ),
                            !model.isCurrentYearStudent
                            ? TextFieldWidget(
                              controller: model.designationController,
                              prefixIcon: Icon(CupertinoIcons.person, color: Theme.of(context).primaryColor, size: 20,),
                              hintText: "Designation",
                              textInputAction: TextInputAction.next,
                            )
                            : Container(),
                            // Check box for current year student
                            CheckboxListTile(
                              tristate: true,
                              dense: true,
                              visualDensity: VisualDensity(horizontal: -4),
                              contentPadding: EdgeInsets.zero,
                              value: model.isCurrentYearStudent, 
                              onChanged: (value) {
                                model.currentYear(!model.isCurrentYearStudent);
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text("Currently studying", style: TextStyle(fontSize: 14),),
                            ),
                            SizedBox(
                              width: size.width,
                              height: 50.0,
                              child: model.isLoading
                              ? LoadingButtonWidget()
                              : ElevatedButton(
                                onPressed: () async {
                                  model.isLoad = true;
                                  model.isFormValid
                                  ? await model.auth.register( model.userData()).then((value){
                                    model.isLoad = false;
                                    value ? model.navigateHome() : null;
                                  })
                                  : model.snackBarMessage();
                                },
                                child: Text(
                                  'Sign Up',
                                  style: textStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 15.0,
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Image.asset(
                                        "assets/icon/linkedin_circle.png",
                                        fit: BoxFit.cover,
                                      )
                                    ),
                                    Text(
                                      'Fill with LinkedIn',
                                      style: textStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(),
                            // Login Navigation
                            InkWell(
                              onTap: () {
                                model.navigateSignin();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ", 
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Login", 
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF7CA18)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}