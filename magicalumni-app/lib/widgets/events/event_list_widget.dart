import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventListWidget extends StatelessWidget {
  final VoidCallback? onTap;
  const EventListWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: Colors.white.withValues(alpha: 0.04),
                onTap: onTap,
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
                        height: MediaQuery.sizeOf(context).height * 0.2,
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
              SizedBox(height: index == 4 ? 60 : 26,)
            ],
          ),
        );
      },
    );
  }
}