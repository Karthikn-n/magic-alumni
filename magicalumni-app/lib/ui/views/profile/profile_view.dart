import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:magic_alumni/ui/widgets/profile/college_change_widget.dart';
import 'package:magic_alumni/ui/widgets/profile/edit_profile_widget.dart';
import 'package:magic_alumni/ui/widgets/profile/profile_card_widget.dart';
import 'package:magic_alumni/ui/widgets/profile/setting_tile_widget.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/app_constants.dart';

class ProfileView extends StatelessWidget {
  final bool isFromHomePop;
  const ProfileView({super.key, this.isFromHomePop = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ProfileViewmodel(),
      onDispose: (viewModel) => viewModel.disposeProfile(),
      onViewModelReady: (viewModel) async => await viewModel.fetchAlumni().then((value) => viewModel.init(),),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title:  Text(
              "Profile", 
              style: appBarTextStyle,
            ) ,
            actions: [
              IconButton(
                tooltip: "Log out",
                onPressed: () async {
                  await model.confirmLogout();
                }, 
                icon: SizedBox(
                  height: 24, 
                  width: 24, 
                  child: Image.asset("assets/icon/out.png", color: Colors.white,),
                )
              )
            ],
            centerTitle: true,
          ),
          body: Stack(
            children: [
              // Body of the screen
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                top: size.width > 600 ? size.width * 0.15 :  size.height * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    children: [
                      SizedBox(height: size.height * 0.1,),
                      SettingTileWidget(
                        title: "Edit Profile", 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileWidget(),)), 
                        icon: Icons.edit
                      ),
                      SettingTileWidget(
                        title: "Change College",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CollegeChangeWidget(),)), 
                        icon: Icons.school
                      ),
                    ],
                  )
                ),
              ),
              // // Profile card and status card
              Positioned(
                top: 0,
                left: 10,
                right: 10,
                child: ProfileCardWidget(fromProfile: false)
              ),
            ],
          ),
        );
      }
    );
  }
}