import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/peoples/people_viewmodel.dart';
import 'package:magic_alumni/ui/widgets/people/people_widget.dart';
import 'package:stacked/stacked.dart';

class PeopleView extends StatelessWidget {
  const PeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // leading: Container(
        //   // height: 10,
        //   // width: 10,
        //   child: Image.asset("assets/icon/logo.png", fit: BoxFit.cover,),
        // ),
        title:  Text(
          "Connections", 
          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
        ) ,
        centerTitle: true,
      ),
      body: ViewModelBuilder.reactive(
        viewModelBuilder: () => PeopleViewmodel(),
        onViewModelReady: (viewModel) async => await viewModel.peoples(),
        builder: (ctx, model, child) {
          return DefaultTabController(
            length: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                ),
              ),
              child: Column(
                spacing: 10,
                children: [
                  Container(),
                  // List of peoples
                  TabBar(
                    padding: EdgeInsets.zero,
                    tabAlignment: TabAlignment.center,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: "Alumni"),
                      Tab(text: "Students"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        PeopleWidget(
                          key: Key("alumni"),
                          peoples: model.peoplesList.where(
                            (element) => element.role == "Alumni",
                          ).toList(),
                        ),
                        PeopleWidget(
                          key: Key("student"),
                          peoples:  model.peoplesList.where(
                            (element) => element.role == "Student",
                          ).toList(),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ),
          );
        }
      ),
    );
  }
}