import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/ui/views/events/events_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/people/filter_button.dart';

class EventsDetailView extends StatelessWidget {
  final EventsModel event;
  final String status;
  const EventsDetailView({super.key, required this.event, required this.status});

   @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => EventsViewModel(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading:  BackButton(
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
            title:  Text(
              event.title, 
              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
            ) ,
            centerTitle: true,
          ),
          body: Material(
            color: Theme.of(context).primaryColor,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: event.image,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          const SizedBox(height: 5,),
                          // event title text field
                          Text(
                            event.title, 
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.w600, 
                              color: Colors.black
                            ),
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(CupertinoIcons.clock, color: Theme.of(context).primaryColor, size: 20,),
                              Text(
                                DateFormat("dd MMM yyyy").format(DateTime.parse(event.eventDate)), 
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
                                 event.location, 
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
                            "Notes", 
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w500, 
                              color: Colors.black
                            ),
                          ),
                          Text(
                            event.description,
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.w400, 
                              color: Colors.black
                            ),
                          ),
                          Text(
                            "Who can attend", 
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w500, 
                              color: Colors.black
                            ),
                          ),
                          Text(
                            event.criteria,
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.w400, 
                              color: Colors.black
                            ),
                          ),
                          Text(
                            "Inform your availability", 
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w500, 
                              color: Colors.black
                            ),
                          ),
                          model.isSent
                          ? Text("You status has been Updated to the Event Organizer")
                          : Material(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: List.generate(event.revpOptions.length, (index) {
                                    return FilterButton(
                                      width: size.width * 0.25,
                                      buttonName: event.revpOptions[index], 
                                      onPressed: () async {
                                        await model.givePresent(event.revpOptions[index], event.id);
                                      }
                                    );
                                  },) ,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Created by", 
                            style: TextStyle(
                              fontSize: 16, 
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
                            title: Text(event.createdBy, style: TextStyle(fontSize: 14),),
                            // subtitle: Text(event.c, style: TextStyle(fontSize: 12),),
                            
                          ),
                          Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
        );
      }
    );
  }
}