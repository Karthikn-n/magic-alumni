import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/signup/signup_viewmodel.dart';
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
        await viewModel.auth.colleges();
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
                              prefixIcon: Icon(CupertinoIcons.link, color: Theme.of(context).primaryColor, size: 20,),
                              textInputAction: TextInputAction.next,
                            ),
                            // college name field
                            TextFieldWidget(
                              controller: model.collegeNameController,
                              hintText: "College Name",
                              prefixIcon: Container(
                                height: 10,
                                width: 10,
                                padding: EdgeInsets.all(12),
                                child: Image.asset(
                                  "assets/icon/college.png", color: Theme.of(context).primaryColor,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            // Department name field
                            TextFieldWidget(
                              controller: model.depNameController,
                              prefixIcon: Container(
                                height: 10,
                                width: 10,
                                padding: EdgeInsets.all(12),
                                child: Image.asset(
                                  "assets/icon/department.png", color: Theme.of(context).primaryColor,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              hintText: "Department Name",
                              textInputAction: TextInputAction.next,
                            ),
                            // current year or passed out year text field
                            TextFieldWidget(
                              controller: model.currentOrCcyController,
                               prefixIcon: Icon(CupertinoIcons.calendar, color: Theme.of(context).primaryColor, size: 20,),
                              hintText: model.isCurrentYearStudent ? "Current year" : "Passed Out Year",
                              textInputAction: TextInputAction.next,
                              keyboardType: model.isCurrentYearStudent 
                                ? null
                                : TextInputType.number,
                            ),
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
                              child: ElevatedButton(
                                onPressed: () {
                                  model.isFormValid
                                  ? model.auth.register(model.userData())
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