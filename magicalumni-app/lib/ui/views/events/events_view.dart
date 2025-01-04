import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/ui/views/events/events_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/people/filter_button.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => EventsViewModel(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Background color and title
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: kToolbarHeight),
                    child: Text(
                      "Events", 
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                top: size.height * 0.15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Material(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  FilterButton(
                                    buttonName: "Past", 
                                    // backgroundColor: Theme.of(context).primaryColor,
                                    onPressed: (){}
                                  ),
                                  FilterButton(
                                    buttonName: "Up Coming", 
                                    onPressed: (){}
                                  ),
                                  FilterButton(
                                    buttonName: "Today", 
                                    onPressed: (){}
                                  ),
                                ],
                              ),
                              // IconButton(
                              //   onPressed: () {} , 
                              //   icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryColor,)
                              // )
                              // FilterButton(
                              //   buttonName: "Clear", 
                              //   onPressed: (){}
                              // )
                            ],
                          ),
                        ),
                              
                        Expanded(
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Material(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(commonPadding, 0, commonPadding, 0),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        splashColor: Colors.white.withValues(alpha: 0.04),
                                        onTap: () {
                                          model.navigateToEventDetail();
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Column(
                                            children: [
                                              // Event image
                                              SizedBox(
                                                height: size.height * 0.2,
                                                width: double.infinity,
                                                child: Ink(
                                                  child: Hero(
                                                    tag: "event",
                                                    transitionOnUserGestures: true,
                                                    child: CachedNetworkImage(
                                                      imageUrl: "https://hire4event.com/blogs/wp-content/uploads/2019/02/hire4event.com_-1.jpg",
                                                      imageBuilder: (context, imageProvider) => Ink(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:  BorderRadius.only(
                                                              topLeft: Radius.circular(10),
                                                              topRight: Radius.circular(10)
                                                            ),
                                                            image: DecorationImage(
                                                              image: imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Title and other information
                                              const SizedBox(height: 5,),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Sports day",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color(0xFF161719),
                                                        fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  //   Text(
                                                  //     "23 Jan 2025",
                                                  //     style: TextStyle(
                                                  //       fontSize: 12,
                                                  //       color: Color(0xFF161719),
                                                  //       fontWeight: FontWeight.w400
                                                  //     ),
                                                  //   ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Lorem ipsum dolor sit amet, consectetur dddssa adipiscing elit, sed do eiusmod tempor..",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          overflow: TextOverflow.ellipsis
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: index == 4 ? 60 : 26,)
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        
            ],
          ),
          // Create event buttton 
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              model.navigateToCreateEvent();
            },
            backgroundColor: Theme.of(context).primaryColor,
            tooltip: "Create event",
            child: Icon(CupertinoIcons.plus, color: Colors.white,),
          ),
        );
      }
    );
  }
}