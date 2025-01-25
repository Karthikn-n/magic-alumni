import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:magic_alumni/ui/views/login/login_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ClicableImages extends StatelessWidget {
  const ClicableImages({super.key});

  @override
  Widget build(BuildContext context) {
    
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => LoginViewmodel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("clickable images"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: PagedListView.separated(
              pagingController: model.pagingController, 
              separatorBuilder: (context, int i) => const Divider(
                color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                thickness: 3,
                height: 3,
              ),
              builderDelegate: PagedChildBuilderDelegate<String>(
                itemBuilder: (context, item, index) {
                  return CachedNetworkImage(
                    imageUrl: "imageUrl"
                  );
                },
              ), 
            )
            
            // ListView.separated(
            //   itemBuilder: (context, index) {
            //     return  AspectRatio(
            //       aspectRatio: 16/9,
            //       child: CachedNetworkImage(
            //         imageUrl: model.images[index],
            //         errorWidget: (context, url, error) {
            //           return const Icon(Icons.error);
            //         },
            //          placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
            //         imageBuilder: (context, imageProvider) => Container(
            //           decoration: BoxDecoration(
            //             image: DecorationImage(
            //               image: imageProvider,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            //   separatorBuilder: (context, index) {
            //     return Divider(
            //         color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            //       thickness: 3,
            //       height: 3,
            //     );
            //   }, 
            //   itemCount: model.images.length
            // ),
          
          ),
        );
      }
    );
  }
}

