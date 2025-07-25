import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:magic_alumni/ui/views/events/events_viewmodel.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:magic_alumni/ui/widgets/events/event_list_widget.dart';
import 'package:stacked/stacked.dart';



class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> with TickerProviderStateMixin {
  late TabController _tabController;
  int _initialTabIndex = 0;

  @override
  void initState() {
    super.initState();

    // Read from storage or set default
    _initialTabIndex = PageStorage.of(context).readState(context, identifier: "events_tab_index") ?? 0;

    _tabController = TabController(length: 3, vsync: this, initialIndex: _initialTabIndex);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        PageStorage.of(context).writeState(context, _tabController.index, identifier: "events_tab_index");
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
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
          body: Container(
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
                  controller: _tabController,
                  key: const PageStorageKey("events"),
                  indicatorAnimation: TabIndicatorAnimation.elastic,
                  isScrollable: false,
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
                    controller: _tabController,
                    key: const PageStorageKey("events"),
                    children: [
                      EventListWidget(
                        key: Key("today"),
                        events: model.eventsList.where(
                          (element) => DateFormat("dd-MM-yyyy").format(DateTime.parse(element.eventDate)) == DateFormat("dd-MM-yyyy").format(DateTime.now())
                        ).toList(),
                      ),
                      EventListWidget(
                        key: Key("upcoming"),
                        events: model.eventsList.where(
                          (element) => DateTime.parse(element.eventDate).isAfter(DateTime.now())
                        ).toList(), 
                      ),
                      EventListWidget(
                        key: Key("past"),
                        events: model.eventsList.where(
                          (element) => DateTime.parse(element.eventDate).isBefore(DateTime.now())
                        ).toList()
                      ),
                    ]
                  )
                ),
              ],
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