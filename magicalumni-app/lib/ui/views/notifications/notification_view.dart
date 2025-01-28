import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:magic_alumni/model/mobrequest_model.dart';
import 'package:magic_alumni/ui/views/notifications/notification_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      onViewModelReady: (viewModel) async => await viewModel.init(),
      viewModelBuilder: () => NotificationViewmodel(),
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
              "Notifications", 
              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
            ) ,
            centerTitle: true,
          ),
          body: Material(
            color: Theme.of(context).primaryColor,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.fromLTRB(12, 10, 12, 0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: size.height,
              child: ListView.builder(
                itemCount: model.mobRequests.length,
                itemBuilder: (context, index) {
                  MobileRequestModel req = model.mobRequests[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(CupertinoIcons.bell),
                        ),
                        title: Text("Mobile number Request", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => showAlumniBottomSheet(context, req.sender),
                              child: Text("View profile")
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(onPressed: (){} , child: Text("Show")),
                                TextButton(onPressed: (){} , child: Text("Deny")),
                                Container()
                              ],
                            )
                          ],
                        ),
                        trailing: Icon(CupertinoIcons.delete),
                      ),
                      
                    ],
                  );
                },
              ),
            ),
          ),
          
        );
      }
    );
  }

  void showAlumniBottomSheet(
    BuildContext context, AlumniProfileModel alumni
  ){
    showModalBottomSheet(
      context: context, 
      constraints: BoxConstraints(
        maxWidth: double.infinity
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (sheetctx) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          // height: 150,
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 15,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: alumni.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ),
              const SizedBox(height: 5,),
              Column(
                children: [
                  Text(alumni.role),
                  Text(alumni.linkedUrl),
                ],
              ),
              const SizedBox(height: 15,),
            ],
          ),
        );
      },
    );
  }


}