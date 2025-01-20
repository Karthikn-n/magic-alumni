import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:magic_alumni/model/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailView extends StatelessWidget {
  final NewsModel news;
  const NewsDetailView({super.key, required this.news});

   @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading:  BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          news.title, 
          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
        ) ,
        centerTitle: true,
      ),
      body: Material(
        color: Theme.of(context).primaryColor,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Hero(
                    tag: news.id,
                    transitionOnUserGestures: true,
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
                        news.title, 
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
                            DateFormat("dd MMM yyyy").format(DateTime.parse(news.postedDate)), 
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
                        children: [
                          Icon(CupertinoIcons.link, color: Theme.of(context).primaryColor, size: 20,),
                          Material(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async => await launchUrl(Uri.parse(news.link)) ,
                              child: Text(
                                news.link, 
                                style: TextStyle(
                                  fontSize: 14, 
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w400, 
                                  color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.pin_drop_outlined, color: Theme.of(context).primaryColor, size: 20,),
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
                          fontSize: 14, 
                          fontWeight: FontWeight.w400, 
                          color: Colors.black
                        ),
                      ),
                      Text(
                        "Created by", 
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600, 
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
                        // subtitle: Text( DateFormat("dd MMM yyyy").format(DateTime.parse(news.postedDate)), style: TextStyle(fontSize: 12),),
                        
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
}