import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:magic_alumni/ui/widgets/common/dot_indicator.dart';
import 'package:stacked/stacked.dart';

class ProfileCardWidget extends StackedView<ProfileViewmodel>{
  final bool fromProfile; 
  const ProfileCardWidget({super.key, this.fromProfile = false});

  
  @override
  Widget builder(BuildContext context, ProfileViewmodel viewModel, Widget? child) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.width < 600 ? size.height * 0.18 : size.height * 0.4,
      width: size.width * 0.8,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // PageView.builder(
          //   controller: viewModel.pageController,
          //   scrollDirection: Axis.horizontal,
          //   itemCount:  viewModel.alumni != null ? viewModel.alumni!.colleges.length : 2,
          //   onPageChanged: (value) {
          //     viewModel.changeConfirmation(viewModel.alumni!.colleges[value].collegeName, value);
          //   },
          //   itemBuilder: (context, index) {
          //     return 
              Card(
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
                            viewModel.alumni !=  null ? viewModel.alumni!.alumniProfileDetail.name : "",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            viewModel.currentCollege != null && viewModel.currentCollege!.status == "not approved"
                              ? "Not approved" 
                              : "${viewModel.currentCollege!.departments[0].departmentName}, ${viewModel.currentCollege!.collegeName}",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Row(
                              spacing: 10,
                              children: [
                                Icon(
                                  viewModel.currentCollege != null && viewModel.currentCollege!.status == "approved" 
                                  ? CupertinoIcons.check_mark_circled_solid
                                  : CupertinoIcons.info_circle, 
                                  size: viewModel.currentCollege != null && viewModel.currentCollege!.status == "approved" ? 14 : 18, 
                                  color: viewModel.currentCollege != null && viewModel.currentCollege!.status == "approved" ? Colors.green : Colors.red,
                                ),
                                Text(
                                  viewModel.currentCollege !=  null
                                    ? viewModel.currentCollege!.status == "approved" ? "You are approved ${viewModel.alumni!.alumniProfileDetail.role} now" : "You are not approved by your college"
                                    : "nothing",
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
          //   },
          // ),
          viewModel.currentCollege != null
          ? Container()
          : Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: List.generate( viewModel.alumni != null ? 1 : 1, 
              (index) {
                return DotIndicator(isActive: true,);
              },
              ),
            ),
          ),
        ],
      ),
    );
      
  }
  
  @override
  ProfileViewmodel viewModelBuilder(BuildContext context) => ProfileViewmodel();

  @override
  void onDispose(ProfileViewmodel viewModel) {
    super.onDispose(viewModel);
    viewModel.disposeProfile();
  }

  @override
  void onViewModelReady(ProfileViewmodel viewModel) async{
    super.onViewModelReady(viewModel);
    if(viewModel.alumni != null && viewModel.currentCollege != null) return; 
    await viewModel.fetchAlumni().then((value) => viewModel.init(),);
  }
  
  @override
  bool get disposeViewModel => false;
}