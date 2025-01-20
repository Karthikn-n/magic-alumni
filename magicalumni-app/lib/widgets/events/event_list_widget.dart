import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/model/events_model.dart';
import 'package:magic_alumni/ui/views/events/events_viewmodel.dart';
import 'package:stacked/stacked.dart';

class EventListWidget extends StatelessWidget {
  final List<EventsModel> events;
  const EventListWidget({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return  ViewModelBuilder.nonReactive(
      viewModelBuilder: () => EventsViewModel(),
      builder: (ctx, model, child) {
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: Colors.white.withValues(alpha: 0.04),
                    onTap: () async => await model.apiService.checkEventStatus(events[index].id).then(
                      (value) => model.navigateToEventDetail(events[index], value)),
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
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child:  CachedNetworkImage(
                              imageUrl: events[index].image,
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                log('Error loading image: $url - featureImage $error');
                                return const Icon(Icons.error);
                              },
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
                                  events[index].title,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF161719),
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
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
                  SizedBox(height: index == 4 ? 60 : 26,)
                ],
              ),
            );
          },
        );
      }
    );
  }
}