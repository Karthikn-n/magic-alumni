import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:magic_alumni/ui/views/events/events_viewmodel.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:magic_alumni/widgets/events/event_list_widget.dart';
import 'package:stacked/stacked.dart';



class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EventsViewModel>.reactive(
      viewModelBuilder: () => EventsViewModel(),
      onViewModelReady: (viewModel)  async => await viewModel.events(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            automaticallyImplyLeading: false,
            title:  Text(
              "Events", 
              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
            ) ,
            centerTitle: true,
          ),
          body: DefaultTabController(
            length: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
              ),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(),
                  TabBar(
                    indicatorAnimation: TabIndicatorAnimation.elastic,
                    isScrollable: true,
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
                    // flex: 4,
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
          // Create event buttton 
          floatingActionButton:  ViewModelBuilder.reactive(
            viewModelBuilder: () => ProfileViewmodel(),
            builder: (ctx, role, child) {
              return role.alumni != null && role.alumni!.alumniProfileDetail.role == "Alumni coordinator"
              ? FloatingActionButton(
                onPressed: ()async{
                  model.navigateToCreateEvent();
                },
                backgroundColor: Theme.of(context).primaryColor,
                tooltip: "Create event",
                child: Icon(CupertinoIcons.plus, color: Colors.white,),
              )
             : Container();
            }
          ),
        );
      }
    );
  }
}