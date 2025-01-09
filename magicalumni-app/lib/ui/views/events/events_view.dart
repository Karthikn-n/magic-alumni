import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:magic_alumni/ui/views/events/events_viewmodel.dart';
import 'package:magic_alumni/widgets/events/event_list_widget.dart';
import 'package:stacked/stacked.dart';



class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder<EventsViewModel>.reactive(
      viewModelBuilder: () => EventsViewModel(),
      onViewModelReady: (viewModel)  async => await viewModel.events(),
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
                                EventListWidget(events: model.eventsList.where((element) => DateFormat("dd-MM-yyyy").format(DateTime.parse(element.eventDate)) == DateFormat("dd-MM-yyyy").format(DateTime.now())).toList(),),
                                EventListWidget(events: model.eventsList.where((element) => DateTime.parse(element.eventDate).isAfter(DateTime.now())).toList(), ),
                                EventListWidget(events: model.eventsList.where((element) => DateTime.parse(element.eventDate).isBefore(DateTime.now())).toList()),
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
            onPressed: ()async{
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