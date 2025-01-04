import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentNotificationsWidget extends StatelessWidget {
  const RecentNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                spacing: 20,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: ListTile(
                      isThreeLine: true,
                      tileColor: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.06),
                        ),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      leading: SizedBox(
                        // height: double.infinity,
                        width: 40,
                        child: CachedNetworkImage(
                          imageUrl: "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Notification title
                      title: Text(
                        "Invitation",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Notification subtitle
                      subtitle: SizedBox(
                        // width: MediaQuery.sizeOf(context).width * 0.7,
                        child: Column(
                          // spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You are invited to guest lecturing on 12 Mar 2025.",
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "Just now *",
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox()
                ],
              ),
              Positioned(
                right: 0,
                top: -20,
                child: IconButton(
                  onPressed: (){}, 
                  icon: Icon(CupertinoIcons.xmark, size: 20,)
                )
              )
            ],
          ),
        );
      },
    );
  }
}