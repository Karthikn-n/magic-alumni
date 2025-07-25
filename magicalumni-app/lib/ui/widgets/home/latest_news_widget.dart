import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/constants/app_constants.dart';
import 'package:magic_alumni/model/news_model.dart';
import 'package:magic_alumni/ui/views/home/home_viewmodel.dart';
import 'package:magic_alumni/ui/views/news/news_detail_view.dart';
import 'package:stacked/stacked.dart';

class LatestNewsWidget extends StatelessWidget {
  final List<NewsModel> news;
  const LatestNewsWidget({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewmodel(),
      builder: (ctx, model, child) {
        return news.isEmpty
        ? Center(
            child: Text("There is no News"),
          )
        : RefreshIndicator(
          onRefresh: () => model.news(),
          child: ListView.builder(
            // separatorBuilder: (context, index) => Container(),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: news.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          expand: true,
                          initialChildSize: 1.0,  // Full screen
                          minChildSize: 0.5,      // Minimum height when dragged down
                          maxChildSize: 1.0,
                          builder: (context, scrollController) {
                            return FractionallySizedBox(
                              heightFactor: 1.0, // 100% of screen height
                              child: NewsDetailView(news: news[index],),
                            );
                          },
                        );
                      },
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // News image
                          Hero(
                            tag: "news_$index",
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: news[index].image.startsWith("/uploads") 
                                  ? "${baseApiUrl.replaceFirst('/api/', '')}${news[index].image}"
                                  : news[index].image,
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
                                    log('Error loading image: $url - featureImage $error', name: news[index].image);
                                    return const Icon(Icons.error);
                                  },
                                ),
                              )
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
                                  news[index].title,
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
                            child: Text(
                              news[index].description,
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
                  ),
                  const SizedBox(height: 26,)
                ],
              );
            },
          ),
        );
      }
    );
  
  }

}