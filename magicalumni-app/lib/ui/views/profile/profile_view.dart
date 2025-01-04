import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:magic_alumni/widgets/common/text_field.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/app_constants.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ProfileViewmodel(),
      onDispose: (viewModel) => viewModel.disposeProfile(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Profile card
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: kToolbarHeight),
                    child: Text(
                      "Profile", 
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
              // Body of the screen
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                top: size.height * 0.23,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Space padding for the tabs from above (below) card in stack
                          SizedBox(height: size.height * 0.1,),
                           Column(
                          spacing: 10,
                          children: [
                            Container(),
                            // Name textfield
                            TextFieldWidget(
                              controller: model.userNameController,
                              hintText: "Full Name",
                              textInputAction: TextInputAction.next,
                            ),
                            // LinkedIn profile URL text field
                            TextFieldWidget(
                              controller: model.linkedUrlController,
                              hintText: "LinkedIn Profile URL",
                              textInputAction: TextInputAction.next,
                            ),
                            // college name field
                            TextFieldWidget(
                              controller: model.collegeNameController,
                              hintText: "College Name",
                              textInputAction: TextInputAction.next,
                            ),
                            // Department name field
                            TextFieldWidget(
                              controller: model.depNameController,
                              hintText: "Department Name",
                              textInputAction: TextInputAction.next,
                            ),
                            // current year or passed out year text field
                            TextFieldWidget(
                              controller: model.currentOrCcyController,
                              hintText: "Current year/ Passed Out Year",
                              keyboardType: model.isCurrentYearStudent ? null: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            // Email text field
                            TextFieldWidget(
                              controller: model.emailController,
                              hintText: "Email",
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            // Mobile text field
                            TextFieldWidget(
                              controller: model.mobileController,
                              hintText: "Mobile number",
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            // Designation text field
                            TextFieldWidget(
                              controller: model.designationController,
                              hintText: "Desgination",
                              textInputAction: TextInputAction.next,
                            ),
                            // Add new college Section if the user need to add new college
                            ExpansionTile(
                              collapsedBackgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              onExpansionChanged: (value) {
                                model.checkExpanded(value);
                              },
                              title: Text("Add College", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                              children: [
                                const SizedBox(height: 10,),
                                // New college Name text Field
                                TextFieldWidget(
                                  controller: model.newCollegeController,
                                  hintText: "College Name",
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 10,),
                                // New College Department text field
                                TextFieldWidget(
                                  controller: model.newDepartmentController,
                                  hintText: "Department Name",
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 10,),
                                // Current year or passed out year text field
                                TextFieldWidget(
                                  controller: model.newDepartmentController,
                                  hintText: "Department Name",
                                  textInputAction: TextInputAction.next,
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
                                ElevatedButton(
                                  onPressed: () {
                                    
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
                                        onPressed: () { },
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
                                        onPressed: () {
                                          
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // // Profile card and status card
              Positioned(
                top: 120,
                left: 16,
                right: 16,
                child: SizedBox(
                  // height: size.height * 0.2,
                  child: Card(
                    color: Color(0xFFFCFCFF),
                    child: Padding(
                      padding: const EdgeInsets.all(commonPadding),
                      child: Row(
                        children: [
                          Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back to the hut,",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Raj kumar",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Icon(CupertinoIcons.check_mark_circled_solid, size: 14, color: Colors.green,),
                                    Text(
                                      "Your alumni status have been approved",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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