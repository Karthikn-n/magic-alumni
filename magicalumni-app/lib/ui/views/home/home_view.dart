import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewmodel(),
      onViewModelReady: (viewModel) async => await viewModel.apiService.news(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              // App Bar Tile
               Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
                child: Column(
                  children: [
                    SizedBox(height: kToolbarHeight,),
                    ListTile(
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
                        "Raj Kumar", 
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
                  ],
                ),
              ),
              // Body of the screen
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                top: size.height * 0.25,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
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
                          LatestNewsWidget()
                        ],
                      ),
                    ),
                  ),
                )
              ),
              // // Profile card and status card
              Positioned(
                top: 120,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: size.height * 0.18,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        onPageChanged: (value) {
                          model.selectOtherCollege(value);
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
                                        "Raj kumar",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      Text(
                                        "Tamilnadu Engineering college",
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
                                            Icon(CupertinoIcons.check_mark_circled_solid, size: 14, color: Colors.green,),
                                            Text(
                                              "Your alumni status have been approved",
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
                      Positioned(
                        bottom: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: List.generate(2, 
                          (index) {
                            return DotIndicator(isActive: index == model.selectedIndex,);
                          },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            ],
          ),
        );
      
      }
    );
  }
}