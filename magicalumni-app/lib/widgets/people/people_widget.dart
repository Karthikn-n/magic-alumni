import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/peoples/people_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PeopleWidget extends StatelessWidget {
  final List<String> names;
  final List<String> jobRoles;
  const PeopleWidget({super.key, required this.names, required this.jobRoles});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: names.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    child:  Icon(CupertinoIcons.person),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    names[index], 
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
                    jobRoles[index],
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
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 30,
                  child: ViewModelBuilder.nonReactive(
                    viewModelBuilder: () => PeopleViewmodel(),
                    builder: (ctx, model, child) {
                      return ElevatedButton(
                        onPressed: () => showConnectionBottomSheet(context, names[index]), 
                        child: Text("Connect", style: textStyle,)
                      );
                    }
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
    
  }

  void showConnectionBottomSheet(BuildContext context, String name){
    showModalBottomSheet(
      context: context, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (sheetctx) {
        return Flexible(
          flex: 1,
          child: Container(
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
                    onPressed: () {
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
                    onPressed: () {
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10.0,
                      children: [
                       Icon(Icons.wechat_sharp, size: 24, color: Colors.white,),
                        Text(
                          'Request Mobile Number',
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
          ),
        );
      },
    );
  }
}