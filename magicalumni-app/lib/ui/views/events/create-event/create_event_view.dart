import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/events/create-event/create_event_viewmodel.dart';
import 'package:magic_alumni/widgets/common/text_field.dart';
import 'package:stacked/stacked.dart';

import '../../../../constants/app_constants.dart';


class CreateEventView extends StatelessWidget {
  const CreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      onViewModelReady: (viewModel) => viewModel.init(),
      viewModelBuilder: () => CreateEventViewmodel(),
      builder: (ctx, model, child) {
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
                          "Create Event", 
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      children: [
                        const SizedBox(height: 20,),
                        // event title text field
                        TextFieldWidget(
                          controller: model.titleController,
                          hintText: "Event Title",
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.event, size: 20, color: Theme.of(context).primaryColor,),
                        ),
                        TextFieldWidget(
                          controller: model.dateController,
                          hintText: "Event Date",
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.calendar_month, size: 20, color: Theme.of(context).primaryColor,),
                          onTap: () async{
                            DateTime? selectDate = await showDatePicker(
                              context: context, 
                              firstDate: DateTime.now(), 
                              lastDate: DateTime(2100)
                            );
                            if (selectDate != null) {
                              model.pickedEventDate(selectDate);
                            }
                          },
                        ),
                        TextFieldWidget(
                          controller: model.locationController,
                          hintText: "Event Location",
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.pin_drop_rounded, size: 20, color: Theme.of(context).primaryColor,),
                        ),
                        TextFieldWidget(
                          controller: model.eventTypeController,
                          hintText: "Event Type",
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(CupertinoIcons.group, size: 20, color: Theme.of(context).primaryColor,),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Row(
                              spacing: 15,
                              children: [
                                Icon(Icons.insert_invitation, size: 20, color: Theme.of(context).primaryColor,),
                                Text("Invite Options", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black45),),
                              ],
                            ),
                            underline: Container(),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            items: model.rsvpOptions.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value, style: TextStyle(fontSize: 14),)
                              );
                            },).toList(), 
                            onChanged: (value) {
                              if (value != null) {
                                model.selectOption(model.rsvpOptions.indexOf(value));
                              }
                            },
                          ),
                        ),
                        model.selectedRsvpOptions.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 5.0,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(model.selectedRsvpOptions.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    model.selectOption(index, removeOption: true);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Theme.of(context).primaryColor)
                                    ),
                                    child: Row(
                                      spacing: 4.0,
                                      children: [
                                        Text(model.selectedRsvpOptions[index], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),),
                                        Icon(CupertinoIcons.xmark_circle, size: 18, color: Colors.red,)
                                      ],
                                    ),
                                  ),
                                );
                              },),
                            ),
                          )
                        : Container(),
                        TextFieldWidget(
                          controller: model.imageController,
                          hintText: "Cover Image",
                          prefixIcon: Icon(Icons.image_rounded, size: 20, color: Theme.of(context).primaryColor,),
                          suffixIcon: IconButton(
                            onPressed: () {
                              
                            }, 
                            icon: Icon(CupertinoIcons.cloud_upload, size: 20, color: Theme.of(context).primaryColor,),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        TextFieldWidget(
                          controller: model.criteriaController,
                          hintText: "Criteria",
                          prefixIcon: Icon(CupertinoIcons.check_mark_circled, size: 20, color: Theme.of(context).primaryColor,),
                          textInputAction: TextInputAction.next,
                        ),
                        TextFieldWidget(
                          controller: model.descriptionController,
                          hintText: "Description",
                          maxLines: 8,
                          textInputAction: TextInputAction.done,
                        ),
                         SizedBox(
                          width: size.width,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              debugPrint("${await model.eventData()}");
                              model.formValid
                              ? await model.events.eventCreate(await model.eventData()).then((value) => value ? Navigator.pop(context) : null,)// Call the API 
                              : model.showSnackbar(); // Show snack bar message
                            },
                            child: Text(
                              'Create Event',
                              style: textStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(),
                      ],
                    ),
                  ),
                )
              ),
            ],
          ),
          
        );
      }
    );
  }
}