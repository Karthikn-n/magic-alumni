import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/peoples/people_viewmodel.dart';
import 'package:magic_alumni/widgets/people/people_widget.dart';
import 'package:stacked/stacked.dart';

class PeopleView extends StatelessWidget {
  const PeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: ViewModelBuilder.reactive(
        viewModelBuilder: () => PeopleViewmodel(),
        onViewModelReady: (viewModel) async => await viewModel.peoples(),
        builder: (ctx, model, child) {
          return DefaultTabController(
            length: 2,
            child: Stack(
              children: [
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
                          leading: SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset("assets/icon/logo.png"),
                          ),
                          title: GestureDetector(
                            onTap: () async => await model.peoples(),
                            child: Text(
                              "Connections", 
                              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // List of alumni and students
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  top: size.height * 0.15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        spacing: 10,
                        children: [
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
                                PeopleWidget(peoples: model.peoplesList.where((element) => element.role == "Alumni",).toList(),),
                                PeopleWidget(peoples:  model.peoplesList.where((element) => element.role == "Student",).toList(),),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}