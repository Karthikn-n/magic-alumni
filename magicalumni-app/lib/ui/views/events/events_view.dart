import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/events/events_viewmodel.dart';
import 'package:magic_alumni/widgets/events/event_list_widget.dart';
import 'package:stacked/stacked.dart';



class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => EventsViewModel(),
      onViewModelReady: (viewModel)  async => await viewModel.apiService.events(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: DefaultTabController(
            length: 3,
            child: Stack(
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
                          // Material(
                          //   color: Theme.of(context).scaffoldBackgroundColor,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Row(
                          //         spacing: 10,
                          //         children: [
                          //           FilterButton(
                          //             buttonName: "Past", 
                          //             // backgroundColor: Theme.of(context).primaryColor,
                          //             onPressed: (){}
                          //           ),
                          //           FilterButton(
                          //             buttonName: "Up Coming", 
                          //             onPressed: (){}
                          //           ),
                          //           FilterButton(
                          //             buttonName: "Today", 
                          //             onPressed: (){}
                          //           ),
                          //         ],
                          //       ),
                          //       // IconButton(
                          //       //   onPressed: () {} , 
                          //       //   icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryColor,)
                          //       // )
                          //       // FilterButton(
                          //       //   buttonName: "Clear", 
                          //       //   onPressed: (){}
                          //       // )
                          //     ],
                          //   ),
                          // ),
                          TabBar(
                              padding: EdgeInsets.zero,
                              tabAlignment: TabAlignment.center,
                              dividerColor: Colors.transparent,
                              tabs: [
                                Tab(text: "Today",),
                                Tab(text: "Up Coming",),
                                Tab(text: "Past",),
                              ]
                            ),     
                          Expanded(
                            child: TabBarView(
                              children: [
                                EventListWidget(onTap: () => model.navigateToEventDetail()),
                                EventListWidget(onTap: () => model.navigateToEventDetail()),
                                EventListWidget(onTap: () => model.navigateToEventDetail()),
                              ]
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                    
              ],
            ),
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