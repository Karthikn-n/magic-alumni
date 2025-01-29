import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_alumni/ui/views/home/home_viewmodel.dart';
import 'package:magic_alumni/ui/views/notifications/notification_viewmodel.dart';
import 'package:magic_alumni/widgets/home/latest_news_widget.dart';
import 'package:magic_alumni/widgets/home/notifications_widgets.dart';
import 'package:magic_alumni/widgets/profile/profile_card_widget.dart';
import 'package:stacked/stacked.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder<HomeViewmodel>.reactive(
      viewModelBuilder: () => HomeViewmodel(),
      onViewModelReady: (model) async  {
        await model.init();
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
                onPressed: () => model.navigateToNotificationView(), 
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
                  child: RefreshIndicator(
                    onRefresh: () => model.init(),
                    child: SingleChildScrollView(
                      child: ViewModelBuilder.nonReactive(
                        viewModelBuilder: () => NotificationViewmodel(),
                        builder: (ctx, notifyModel, child) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Space padding for the tabs from above (below) card in stack
                                  SizedBox(height: size.height * 0.1,),
                                  // Recent Notifications
                                  notifyModel.notifications.isEmpty
                                   ? Container()
                                   : Text("Recent Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                   notifyModel.notifications.isEmpty
                                   ? Container()
                                   : SizedBox(height: size.height * 0.02,),
                                  notifyModel.notifications.isEmpty
                                   ? Container()
                                   : SizedBox(
                                      height: 100,
                                      child: RecentNotificationsWidget(requests: notifyModel.notifications.take(4).toList(),)
                                    ),
                                  // Latest News 
                                  SizedBox(height: size.height * 0.015,),
                                  Text("Latest News", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  SizedBox(height: size.height * 0.02,),
                                  // Latest news List widget
                                  LatestNewsWidget(news: model.newsList,)
                                ],
                              ),
                            );
                        }
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 10,
                right: 10,
                child: ProfileCardWidget()
              )
            ],
          )
        );
      }
    );
  }

  void _showNonClosablePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (ctx) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            SystemNavigator.pop();
          },
          child: AlertDialog(
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
          ),
        );
      },
    );
  }

}