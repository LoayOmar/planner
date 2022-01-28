import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planner/models/event_model.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/network/local/noitification_service.dart';
import 'package:planner/shared/styles/colors.dart';

class NewEventScreen extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController notificationController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  int getSeconds(DateTime date, TimeOfDay time){
    int days = date.difference(DateTime.now()).inDays;
    int hour = 0;
    int minute = 0;
    int second = 0;
    if(days == 0){
      if(date.day - DateTime.now().day == 0){
        hour = time.hour - TimeOfDay.now().hour;
        minute = time.minute - TimeOfDay.now().minute;
        second = (hour * 60 * 60) + (minute * 60);
      } else {
        hour += 24 - DateTime.now().hour;
        hour += time.hour;
        minute += time.minute - DateTime.now().minute;
        second = (hour * 60 * 60) + (minute * 60);
      }
    } else {
      days = 1;
      hour += 24 - DateTime.now().hour;
      hour += time.hour;
      minute += time.minute - DateTime.now().minute;
      second = (days * 24 * 60 * 60) + (hour * 60 * 60) + (minute * 60);
    }
    return second;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PlannerCubit.get(context);
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: defaultColor,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                titleController.clear();
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            title: Text(
              'New Event',
              style: TextStyle(
                fontSize: 25,
                color: backgroundColor,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async{
                  if (titleController.text.isNotEmpty) {
                    int sec = notificationController.text.isEmpty ? (15 * 60) : (int.parse(notificationController.text) * 60);
                    if(getSeconds(cubit.currentEventStartDate, cubit.currentEventStartTime) > sec){
                      int len = PlannerCubit.get(context).events.length;
                      cubit.insertEventToDatabase(
                        eventModel: EventModel(
                          uId: cubit.userModel!.uId!,
                          eventTitle: titleController.text,
                          location: locationController.text,
                          notification: notificationController.text,
                          note: noteController.text,
                          startDate: cubit.currentEventStartDate,
                          endDate: cubit.currentEventEndDate,
                          startTime: cubit.currentEventStartTime,
                          endTime: cubit.currentEventEndTime,
                          colorName: cubit.eventColorName,
                        ),
                        context: context,
                      );
                      await NotificationService().showNotification(
                        len + 1,
                        titleController.text,
                        'Don\'t waste time, your event will start soon',
                        getSeconds(cubit.currentEventStartDate, cubit.currentEventStartTime) - sec,
                        'event',
                      );
                      titleController.clear();
                      locationController.clear();
                      notificationController.clear();
                      noteController.clear();
                      cubit.currentEventStartDate = DateTime.now();
                      cubit.currentEventEndDate = DateTime.now();
                      cubit.currentEventStartTime = TimeOfDay.now();
                      cubit.currentEventEndTime = TimeOfDay.now();
                      cubit.changeEventColor(Colors.tealAccent, 'Default');
                      Navigator.pop(context);
                    } else {
                    showToast(
                    text: 'Please check time', state: ToastStates.ERROR);
                    }
                  } else {
                    showToast(
                        text: 'Please add title', state: ToastStates.ERROR);
                  }
                },
                icon: Icon(
                  Icons.save,
                  color: backgroundColor,
                  size: 30,
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: defaultTextFormField(
                      controller: titleController,
                      type: TextInputType.text,
                      validate: (value) {},
                      label: 'Title',
                      hintText: 'Enter title'),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: defaultColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: defaultTextFormField(
                            controller: locationController,
                            type: TextInputType.text,
                            validate: (value) {},
                            label: 'Location',
                            hintText: 'Add location'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        color: defaultColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: defaultTextFormField(
                          controller: notificationController,
                          type: TextInputType.number,
                          validate: (value) {},
                          label: 'Add number of minutes before notification',
                          hintText: '15 minutes before by default',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.note_add_rounded,
                        color: defaultColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: defaultTextFormField(
                          controller: noteController,
                          type: TextInputType.text,
                          validate: (value) {},
                          label: 'Note',
                          hintText: 'Add a note',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        color: defaultColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            buildEventTime(
                              context: context,
                              date: DateFormat.yMMMd()
                                  .format(cubit.currentEventStartDate),
                              time: cubit.currentEventStartTime.format(context),
                              dateFunction: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: cubit.currentEventStartDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-05-03'),
                                ).then((value) {
                                  cubit.changeCurrentEventStartDate(value!);
                                });
                              },
                              timeFunction: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: cubit.currentEventStartTime,
                                ).then((value) {
                                  cubit.changeCurrentEventStartTime(value!);
                                });
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            buildEventTime(
                              context: context,
                              date: DateFormat.yMMMd()
                                  .format(cubit.currentEventEndDate),
                              time: cubit.currentEventEndTime.format(context),
                              dateFunction: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: cubit.currentEventEndDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-05-03'),
                                ).then((value) {
                                  cubit.changeCurrentEventEndDate(value!);
                                });
                              },
                              timeFunction: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: cubit.currentEventEndTime,
                                ).then((value) {
                                  cubit.changeCurrentEventEndTime(value!);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55, right: 10),
                  child: Container(
                    height: 1,
                    color: defaultColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                colorItem(
                  context: context,
                  color: cubit.eventColor,
                  colorName: cubit.eventColorName,
                  function: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      body: Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 5),
                        child: Column(
                          children: [
                            colorItem(
                                context: context,
                                color: Colors.tealAccent,
                                colorName: 'Default',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.tealAccent, 'Default');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.indigo,
                                colorName: 'Peacock',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.indigo, 'Peacock');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.indigoAccent.withOpacity(0.4),
                                colorName: 'Blueberry',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.indigoAccent.withOpacity(0.4),
                                      'Blueberry');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.cyanAccent,
                                colorName: 'Lavender',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.cyanAccent, 'Lavender');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.tealAccent,
                                colorName: 'Sage',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.tealAccent, 'Sage');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.green,
                                colorName: 'Basil',
                                function: () {
                                  cubit.changeEventColor(Colors.green, 'Basil');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.yellow,
                                colorName: 'Banana',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.yellow, 'Banana');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.orangeAccent,
                                colorName: 'Tangerine',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.orangeAccent, 'Tangerine');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.redAccent.withOpacity(0.6),
                                colorName: 'Flamingo',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.redAccent.withOpacity(0.6),
                                      'Flamingo');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.red,
                                colorName: 'Tomato',
                                function: () {
                                  cubit.changeEventColor(Colors.red, 'Tomato');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.purple.withOpacity(0.3),
                                colorName: 'Grape',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.purple.withOpacity(0.3), 'Grape');
                                  Navigator.pop(context);
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            colorItem(
                                context: context,
                                color: Colors.blueGrey.withOpacity(0.2),
                                colorName: 'Graphite',
                                function: () {
                                  cubit.changeEventColor(
                                      Colors.blueGrey.withOpacity(0.3),
                                      'Graphite');
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ),
                    ).show();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55, right: 10),
                  child: Container(
                    height: 1,
                    color: defaultColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
