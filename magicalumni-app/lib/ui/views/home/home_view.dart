import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/home/home_viewmodel.dart';
import 'package:magic_alumni/widgets/common/dot_indicator.dart';
import 'package:magic_alumni/widgets/home/latest_news_widget.dart';
import 'package:magic_alumni/widgets/home/notifications_widgets.dart';
import 'package:stacked/stacked.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        SystemNavigator.pop();
      },
      child: ViewModelBuilder<HomeViewmodel>.reactive(
        viewModelBuilder: () => HomeViewmodel(),
        onViewModelReady: (model) async  {
          debugPrint(" Alumni is present ${model.alumni == null}");
          if (!model.isInitialized) {
           await model.init();
          }
          if (model.newsList.isEmpty) {
            await model.news();
          }
          model.alumni!.colleges[0].status != "approved" ? _showNonClosablePopup(context) : null;
        },
        builder: (ctx, model, child) {
          return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: ListTile(
              leading: SizedBox(
                height: 24,
                width: 24,
                child: Image.asset("assets/icon/logo.png"),
              ),
              title: Text(
                "Welcome back to the hut,", 
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white
                ),
              ),
              subtitle:  Text(
                model.alumni != null ? model.alumni!.alumniProfileDetail.name : "", 
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
              ),
              trailing: IconButton(
                onPressed: (){}, 
                icon: Icon(
                  CupertinoIcons.bell,
                  color: Colors.white,
                )
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: size.width > 600 ? size.width * 0.15 :  size.height * 0.1,
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  // height: size.height,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Space padding for the tabs from above (below) card in stack
                            SizedBox(height: size.height * 0.1,),
                            // Recent Notifications
                            Text("Recent Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                            SizedBox(height: size.height * 0.02,),
                            SizedBox(
                              height: 100,
                              child: RecentNotificationsWidget()
                            ),
                            // Latest News 
                            SizedBox(height: size.height * 0.015,),
                            Text("Latest News", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                            // Latest news List widget
                            LatestNewsWidget(news: model.newsList,)
                          ],
                        ),
                      ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 10,
                right: 10,
                child: SizedBox(
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
                                                ? "Not approved" 
                                                : model.alumni!.colleges[index].status == "approved" ? "You are approved Alumni now" : "You are not approved by your college",
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
                ),
              )
            ],
          )
         
          
          );
        
        }
      ),
    );
  }

  void _showNonClosablePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not approved'),
          content: Text("You're not approved by college"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // You can add any action here, but not closing the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}