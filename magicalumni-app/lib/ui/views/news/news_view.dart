import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  // News image
                  SizedBox(
                    height: size.height * 0.2,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                      ),
                      child: CachedNetworkImage(
                        imageUrl:  "https://www.mheducation.co.uk/media/wysiwyg/first-year_university_student.jpg",
                        fit: BoxFit.cover,
                      ),
                    )
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
            const SizedBox(height: 26,)
          ],
        );
      },
    );
  
  }

}