import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class CollegeChangeWidget extends StackedView<ProfileViewmodel>{
  const CollegeChangeWidget({super.key});
  
  @override
  Widget builder(BuildContext context, ProfileViewmodel model, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change College"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: model.alumni!.colleges.length,
        itemBuilder: (context, index) {
          return ListTile(
            dense: true,
            leading: Icon(Icons.school, color: Theme.of(context).primaryColor,),
            title: Text(model.alumni!.colleges[index].collegeName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.alumni!.colleges[index].departments[0].departmentName),
                Text(
                  model.alumni!.colleges[index].status == "not approved" ? "Not approved" : "Approved",
                  style: TextStyle(
                    color: model.alumni!.colleges[index].status == "not approved" ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            trailing: model.isLoad 
              ? CircularProgressIndicator()
              : model.isCurrentCollege(model.alumni!.colleges[index].id) ? Icon(Icons.done, color: Theme.of(context).primaryColor,) : null,
            onTap: () async {
              model.changeConfirmation(model.alumni!.colleges[index].collegeName, model.alumni!.colleges[index].id);
            },
          );
        },
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
