import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:magic_alumni/widgets/common/dot_indicator.dart';
import 'package:stacked/stacked.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      onViewModelReady: (model) async => await model.init(),
      viewModelBuilder: () => ProfileViewmodel(), 
      builder: (ctx, model, child) {
        return  SizedBox(
          height: size.width < 600 ? size.height * 0.18 : size.height * 0.4,
          width: size.width * 0.8,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:  model.alumni != null ? model.alumni!.colleges.length : 2,
                onPageChanged: (value) {
                  // model.selectOtherCollege(value);
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
                                model.alumni !=  null ? model.alumni!.alumniProfileDetail.name : "",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Text(
                                model.alumni != null && model.alumni!.colleges.isEmpty 
                                  ? "Not approved" 
                                  : "${model.alumni!.colleges[index].departments[index].departmentName}, ${model.alumni!.colleges[index].collegeName}",
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
                                      model.alumni != null && model.alumni!.colleges[index].status == "approved" 
                                      ? CupertinoIcons.check_mark_circled_solid
                                      : CupertinoIcons.info_circle, 
                                      size: model.alumni != null && model.alumni!.colleges[index].status == "approved" ? 14 : 18, 
                                      color: model.alumni != null && model.alumni!.colleges[index].status == "approved" ? Colors.green : Colors.red,
                                    ),
                                    Text(
                                      model.alumni !=  null && model.alumni!.colleges.isEmpty
                                        ? "nothing" 
                                        : model.alumni!.colleges[index].status == "approved" ? "You are approved ${model.alumni!.alumniProfileDetail.role} now" : "You are not approved by your college",
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
              model.alumni != null && model.alumni!.colleges.isEmpty
              ? Container()
              : Positioned(
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: List.generate( model.alumni != null ? model.alumni!.colleges.length : 1, 
                  (index) {
                    return DotIndicator(isActive: index == model.selectedIndex,);
                  },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}