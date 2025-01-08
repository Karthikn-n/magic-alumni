import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/app-view/app_viewmodel.dart';
import 'package:magic_alumni/ui/views/events/events_view.dart';
import 'package:magic_alumni/ui/views/home/home_viewmodel.dart';
import 'package:magic_alumni/ui/views/jobs/jobs_view.dart';
import 'package:magic_alumni/ui/views/home/home_view.dart';
import 'package:magic_alumni/ui/views/peoples/people_view.dart';
import 'package:magic_alumni/ui/views/profile/profile_view.dart';
import 'package:magic_alumni/widgets/app/image_widget.dart';
import 'package:stacked/stacked.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> views = [
      HomeView(),
      EventsView(),
      PeopleView(),
      JobsView(),
      ProfileView(),
    ];
    
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewmodel(),
      onViewModelReady: (viewModel) async 
        => viewModel.alumni != null ? viewModel.alumni!.colleges.isEmpty ? viewModel.showDialog() : null : await viewModel.init(),
      builder: (homectx, homeModel, child) {
        return ViewModelBuilder.reactive(
          viewModelBuilder: () => AppViewModel(), 
          onViewModelReady: (viewModel) async {
            await viewModel.apiService.events();
          },
          builder: (ctx, model, child) {
            return Scaffold(
              body: views.elementAt(model.index),
              bottomNavigationBar: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35)
                ),
                child: SizedBox(
                  child: BottomNavigationBar(
                    elevation: 10,
                    items: <BottomNavigationBarItem>[
                      // Home button
                      BottomNavigationBarItem(
                        tooltip: "Home",
                        icon:  model.index == 0 
                          ? ImageWidget(image: model.images[0], color: Theme.of(context).primaryColor, height: 24, width: 24,)
                          : ImageWidget(image: model.images[0], color: Colors.black,),
                        label: ""
                      ),
                      // Events button
                      BottomNavigationBarItem(
                        tooltip: "Events",
                        icon: model.index == 1 
                          ? ImageWidget(image: model.images[1], color: Theme.of(context).primaryColor, height: 24, width: 24,)
                          : ImageWidget(image: model.images[1], color: Colors.black,),
                        label: "",
                      ),
                      // Connection button
                      BottomNavigationBarItem(
                        tooltip: "Connections",
                        icon: model.index == 2 
                          ? ImageWidget(image: model.images[2], color: Theme.of(context).primaryColor, height: 24, width: 24,)
                          : ImageWidget(image: model.images[2], color: Colors.black,),
                        label: "",
                      ),
                      // Jobs button
                      BottomNavigationBarItem(
                        tooltip: "Jobs",
                        icon: model.index == 3 
                          ? ImageWidget(image: model.images[3], color: Theme.of(context).primaryColor, height: 24, width: 24,)
                          : ImageWidget(image: model.images[3], color: Colors.black,),
                        label: "",
                      ),
                      // Profile button
                      BottomNavigationBarItem(
                        tooltip: "Profile",
                        icon: model.index == 4
                          ? ImageWidget(image: model.images[4], color: Theme.of(context).primaryColor, height: 24, width: 26,)
                          : ImageWidget(image: model.images[4], color: Colors.black, ),
                        label: "",
                      )
                    
                    ],
                    currentIndex: model.index,
                    onTap: (value) => model.onTapped(value),
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}