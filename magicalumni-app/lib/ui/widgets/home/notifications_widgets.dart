import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/model/notifications_model.dart';

class RecentNotificationsWidget extends StatelessWidget {
  final List<NotificationsModel> requests;
  const RecentNotificationsWidget({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      itemCount: requests.length,
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
                      tileColor: Colors.white,
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
                        "Mobile Request",
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
                              "Your mobile number is requested by ${requests[index].title}.",
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
                                formatTimeDifference(requests[index].date),
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
                  onPressed: (){
                  }, 
                  icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset("assets/icon/close.png"),
                  )
                )
              )
            ],
          ),
        
        );
      },
    );
  }
  
  String formatTimeDifference(String requestedDate) {
    final Duration difference = DateTime.now().difference(DateTime.parse(requestedDate));
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} secs ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hrs ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

}