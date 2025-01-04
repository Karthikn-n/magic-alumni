import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/widgets/people/filter_button.dart';
import 'package:magic_alumni/widgets/people/people_widget.dart';

class PeopleView extends StatelessWidget {
  const PeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    List<String> names = [
      "Alice Johnson",
      "Robert Smith",
      "Emily Davis",
      "Michael Brown",
      "Sophia Taylor",
      "David Wilson",
      "Olivia Moore",
      "James Anderson",
      "Charlotte Clark",
      "Ethan Thompson"
    ];
    List<String> jobRoles = [
      "Software Developer",
      "Data Analyst",
      "Marketing Manager",
      "Graphic Designer",
      "Product Manager",
      "Financial Consultant",
      "Human Resources Specialist",
      "Sales Representative",
      "Cybersecurity Specialist",
      "Customer Support Executive"
    ];
    return Scaffold(
      body: DefaultTabController(
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
                      title: Text(
                        "Connections", 
                        style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
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
                      // Filter button for the peoples
                      // Material(
                      //   color: Theme.of(context).scaffoldBackgroundColor,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         spacing: 10,
                      //         children: [
                      //           FilterButton(
                      //             buttonName: "Alumni", 
                      //             // backgroundColor: Theme.of(context).primaryColor,
                      //             onPressed: (){}
                      //           ),
                      //           FilterButton(
                      //             buttonName: "Students", 
                      //             onPressed: (){}
                      //           ),
                      //         ],
                      //       ),
                      //       // FilterButton(
                      //       //   buttonName: "Clear", 
                      //       //   onPressed: (){}
                      //       // )
                      //     ],
                      //   ),
                      // ),
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
                              names: names,
                              jobRoles: jobRoles,
                            ),
                            PeopleWidget(
                              names: names,
                              jobRoles: jobRoles,
                            ),
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
      ),
    );
  }
}