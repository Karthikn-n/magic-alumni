import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/peoples/people_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/alumni_model.dart';

class PeopleWidget extends StatelessWidget {
  final List<AlumniProfileModel> peoples;
  const PeopleWidget({super.key, required this.peoples});

  @override
  Widget build(BuildContext context) {
    return peoples.isEmpty 
      ?  key == Key("alumni")
        ? Center(
            child: Text("There is no approved alumni for this college"),
          )
        : Center(
            child: Text("There is no approved student for this college"),
          )
      : RefreshIndicator(
        onRefresh: () async => await PeopleViewmodel().peoples(),
        child: GridView.extent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.9,
            shrinkWrap: true,
            children: List.generate(peoples.length, (index) {
              return Container(
                // padding: EdgeInsets.symmetric(horizontal: 10,),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Flexible(
                      flex: 3,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).canvasColor,
                        child:  Icon(CupertinoIcons.person),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            peoples[index].name, 
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                              color: Color(0xFF161719),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            peoples[index].designation.isEmpty ? "Student" : peoples[index].designation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black26,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        // height: 30,
                        child: ViewModelBuilder.reactive(
                          viewModelBuilder: () => PeopleViewmodel(),
                          builder: (ctx, model, child) {
                            return 
                            // model.isLoad 
                            // ? LoadingButtonWidget()
                            ElevatedButton(
                              onPressed: () async => 
                              // await model.checkStatus(peoples[index].id).then((value) => 
                                showConnectionBottomSheet(
                                  model, 
                                  peoples[index].id,
                                  context, 
                                  peoples[index].name, 
                                  peoples[index].linkedUrl,
                                  model.status
                                ),
                              // ), 
                              child: Text("Connect", style: textStyle,)
                            );
                          }
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              );
            },
            )
          ),
      );
    
  }

  void showConnectionBottomSheet(
    PeopleViewmodel model, String receiverId, 
    BuildContext context, String name, String url,
    String? status,
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
                  text: "Connect with ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ]
                )
              ),
              const SizedBox(height: 5,),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () async {
                    // if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    // }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10.0,
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
                        'Connect via LinkedIn',
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () async 
                    => status.isNotEmpty 
                      ? status == "Allow" // Check the mobile request is approved
                        ? await launchUrl(Uri.parse("https://wa.me/+91${model.mobileNumber}")) // Open the whatsapp with this number 
                        : Navigator.pop(context) // Close the bottom Navigation bar
                      : await model.api.requestMobile(receiverId).then((value) async { // Request the Alumni Mobile number
                          if (value) {
                             Navigator.pop(context);
                          }
                        },),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10.0,
                    children: [
                     Icon(Icons.wechat_sharp, size: 24, color: Colors.white,),
                      Text(
                        status!.isEmpty 
                          ? 'Request Mobile Number' 
                          : status == "Allow" 
                            ? "Message at +91${model.mobileNumber}"
                            : status,
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15,),
            ],
          ),
        );
      },
    );
  }

}