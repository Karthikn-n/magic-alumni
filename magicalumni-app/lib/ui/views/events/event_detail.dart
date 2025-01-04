import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/events/events_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/people/filter_button.dart';

class EventsDetailView extends StatelessWidget {
  const EventsDetailView({super.key});

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
                    padding: const EdgeInsets.only(top: kToolbarHeight  - 16),
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: ListTile(
                        // dense: true,
                        minLeadingWidth: size.width * 0.3,
                        titleAlignment: ListTileTitleAlignment.titleHeight,
                        leading: BackButton(
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                        title: Text(
                          "Event Title", 
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                top: size.height * 0.15,
                child: Column(
                  children: [
                    Hero(
                      tag: "event",
                      transitionOnUserGestures: true,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: SizedBox(
                          width: size.width,
                          height: size.height * 0.3,
                          child: CachedNetworkImage(
                            imageUrl: "https://hire4event.com/blogs/wp-content/uploads/2019/02/hire4event.com_-1.jpg",
                            imageBuilder: (context, imageProvider) => Ink(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:  BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)
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
                        
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              const SizedBox(height: 5,),
                              // event title text field
                              Text(
                                "Event Title", 
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w500, 
                                  color: Colors.black
                                ),
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Icon(CupertinoIcons.clock, color: Theme.of(context).primaryColor, size: 20,),
                                  Text(
                                    "Start at 13 Mar 2025", 
                                    style: TextStyle(
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w400, 
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_pin, color: Theme.of(context).primaryColor, size: 20,),
                                  Expanded(
                                    child: Text(
                                      "Hiveword, Writer's Knowledge Base, and Knockout Novel are trademarks of Zecura, LLC", 
                                      style: TextStyle(
                                        fontSize: 14, 
                                        fontWeight: FontWeight.w400, 
                                        color: Colors.black
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Free Download Linkedin Circle SVG vector file in monocolor and multicolor type for Sketch and Figma from Linkedin Circle Vectors svg vector collection. Linkedin Circle Vectors SVG vector illustration graphic art design format.",
                                style: TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w400, 
                                  color: Colors.black
                                ),
                              ),
                              Text(
                                "Confirm your presence", 
                                style: TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.w500, 
                                  color: Colors.black
                                ),
                              ),
                              Material(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: [
                                        FilterButton(
                                          width: size.width * 0.25,
                                          buttonName: "Yes", 
                                          // backgroundColor: Theme.of(context).primaryColor,
                                          onPressed: (){}
                                        ),
                                        FilterButton(
                                          width: size.width * 0.25,
                                          buttonName: "No", 
                                          onPressed: (){}
                                        ),
                                        FilterButton(
                                          width: size.width * 0.25,
                                          buttonName: "Maybe", 
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
                              Text(
                                "Created by", 
                                style: TextStyle(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.w500, 
                                  color: Colors.black
                                ),
                              ),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  child: Icon(Icons.person_rounded),
                                ),
                                title: Text("John Doe", style: TextStyle(fontSize: 14),),
                                subtitle: Text("10 Dec 2025", style: TextStyle(fontSize: 12),),
                                trailing: IconButton(
                                  onPressed: () {
                                    
                                  }, 
                                  icon: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Image.asset(
                                      "assets/icon/linkedin.png"
                                    ),
                                  )
                                ),
                              ),
                              // Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
          
        );
      }
    );
  }
}