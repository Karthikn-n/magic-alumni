import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:magic_alumni/widgets/common/dot_indicator.dart';
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
          PageView.builder(
            controller: viewModel.pageController,
            scrollDirection: Axis.horizontal,
            itemCount:  viewModel.alumni != null ? viewModel.alumni!.colleges.length : 2,
            onPageChanged: (value) {
              viewModel.changeConfirmation(viewModel.alumni!.colleges[value].collegeName, value);
            },
            itemBuilder: (context, index) {
              return Card(
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
                            viewModel.alumni != null && viewModel.alumni!.colleges.isEmpty 
                              ? "Not approved" 
                              : "${viewModel.alumni!.colleges[index].departments[0].departmentName}, ${viewModel.alumni!.colleges[index].collegeName}",
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
                                  viewModel.alumni != null && viewModel.alumni!.colleges[index].status == "approved" 
                                  ? CupertinoIcons.check_mark_circled_solid
                                  : CupertinoIcons.info_circle, 
                                  size: viewModel.alumni != null && viewModel.alumni!.colleges[index].status == "approved" ? 14 : 18, 
                                  color: viewModel.alumni != null && viewModel.alumni!.colleges[index].status == "approved" ? Colors.green : Colors.red,
                                ),
                                Text(
                                  viewModel.alumni !=  null && viewModel.alumni!.colleges.isEmpty
                                    ? "nothing" 
                                    : viewModel.alumni!.colleges[index].status == "approved" ? "You are approved ${viewModel.alumni!.alumniProfileDetail.role} now" : "You are not approved by your college",
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
              );
            },
          ),
          viewModel.alumni != null && viewModel.alumni!.colleges.isEmpty
          ? Container()
          : Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: List.generate( viewModel.alumni != null ? viewModel.alumni!.colleges.length : 1, 
              (index) {
                return DotIndicator(isActive: index == viewModel.selectedIndex,);
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
  void onViewModelReady(ProfileViewmodel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.init();
  }
  
  @override
  bool get disposeViewModel => false;
}