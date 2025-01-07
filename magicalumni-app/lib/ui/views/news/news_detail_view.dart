import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/model/news_model.dart';

class NewsDetailView extends StatelessWidget {
  final NewsModel news;
  final int index;
  const NewsDetailView({super.key, required this.news, required this.index});

   @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background color and title
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight  - 16),
                child: SizedBox(
                  height: kToolbarHeight,
                  child: ListTile(
                    // dense: true,
                    minLeadingWidth: size.width * 0.3,
                    titleAlignment: ListTileTitleAlignment.titleHeight,
                    leading: BackButton(
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      news.title, 
                      style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            top: size.height * 0.15,
            child: Column(
              children: [
                Hero(
                  tag: "news_$index",
                  transitionOnUserGestures: true,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: SizedBox(
                      width: size.width,
                      height: size.height * 0.3,
                      child: CachedNetworkImage(
                        imageUrl: news.image,
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
                  ),
                ),
                    
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          const SizedBox(height: 5,),
                          // event title text field
                          Text(
                            news.title, 
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w500, 
                              color: Colors.black
                            ),
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(CupertinoIcons.clock, color: Theme.of(context).primaryColor, size: 20,),
                              Text(
                                news.postedDate, 
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
                                  news.location, 
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
                            news.description,
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.w400, 
                              color: Colors.black
                            ),
                          ),
                          Text(
                            "Created by", 
                            style: TextStyle(
                              fontSize: 14, 
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
                            title: Text(news.createdBy, style: TextStyle(fontSize: 14),),
                            subtitle: Text(news.postedDate, style: TextStyle(fontSize: 12),),
                            trailing: IconButton(
                              onPressed: () {
                                
                              }, 
                              icon: SizedBox(
                                height: 24,
                                width: 24,
                                child: Image.asset(
                                  "assets/icon/linkedin.png"
                                ),
                              )
                            ),
                          ),
                          // Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
      
    );
  }
}