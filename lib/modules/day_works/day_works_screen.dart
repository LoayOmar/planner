import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planner/models/task_model.dart';
import 'package:planner/modules/edit_note/edit_note_screen.dart';
import 'package:planner/modules/edit_task/edit_task_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/styles/colors.dart';

class DayWorksScreen extends StatelessWidget {
  DateTime date;

  DayWorksScreen(this.date);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        PlannerCubit.get(context).states = [];
        PlannerCubit.get(context).subText = [];
        PlannerCubit.get(context).subBool = [];

        List dayWorksTasks = [];
        PlannerCubit.get(context).tasks.forEach((element) {
          if (DateFormat.yMMMd().format(DateTime.parse(element['date'])) ==
              DateFormat.yMMMd().format(date)) {
            dayWorksTasks.add(element);
          }
        });

        List dayWorksNotes = [];
        PlannerCubit.get(context).notes.forEach((element) {
          if (DateFormat.yMMMd().format(DateTime.parse(element['date'])) ==
              DateFormat.yMMMd().format(date)) {
            dayWorksNotes.add(element);
          }
        });

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: defaultColor,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              DateFormat.yMMMd().format(date),
              style: TextStyle(
                fontSize: 25,
                color: backgroundColor,
              ),
            ),
          ),
          body: dayWorksTasks.isEmpty && dayWorksNotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_rounded,
                        color: secondaryColor.withOpacity(0.6),
                        size: 50,
                      ),
                      Text(
                        'It\'s empty',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if(dayWorksTasks.isNotEmpty)
                    Text(
                      'Tasks',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: defaultColor,
                          ),
                    ),
                    if(dayWorksTasks.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemBuilder: (context, index) {
                          PlannerCubit.get(context).increaseTasksLength();
                          String subTask = dayWorksTasks[index]['subTasks'];
                          subTask = subTask.replaceAll('[', '');
                          subTask = subTask.replaceAll(']', '');
                          subTask = subTask.replaceAll(' ', '');

                          List<String> subTasks = subTask.split(',');
                          if (subTask.isNotEmpty) {
                            PlannerCubit.get(context).addSubText(subTasks);
                            String subTaskBool =
                                dayWorksTasks[index]['subTasksBool'];
                            subTaskBool = subTaskBool.replaceAll('[', '');
                            subTaskBool = subTaskBool.replaceAll(']', '');
                            List<String> tasksBool = subTaskBool.split(',');
                            List<bool> subTasksBool = [];
                            tasksBool.forEach((element) {
                              if (element.contains('true')) {
                                subTasksBool.add(true);
                              } else {
                                subTasksBool.add(false);
                              }
                            });
                            PlannerCubit.get(context).addSubBool(subTasksBool);
                          } else {
                            PlannerCubit.get(context).addSubText([]);
                            PlannerCubit.get(context).addSubBool([]);
                          }

                          DateTime date =
                              DateTime.parse(dayWorksTasks[index]['date']);
                          String time = dayWorksTasks[index]['time'];
                          time = time.replaceAll('TimeOfDay(', '');
                          time = time.replaceAll(')', '');

                          bool state = dayWorksTasks[index]['State'] == 'true'
                              ? true
                              : false;
                          PlannerCubit.get(context).addState(state);

                          return buildTaskItem(
                            context: context,
                            onTapFunction: () {
                              navigateTo(
                                  context,
                                  EditTaskScreen(
                                    TaskModel(
                                      uId: dayWorksTasks[index]['uId'],
                                      taskTitle: dayWorksTasks[index]
                                          ['taskTitle'],
                                      subTasks: PlannerCubit.get(context)
                                          .subText[index],
                                      subTasksBool: PlannerCubit.get(context)
                                          .subBool[index],
                                      date: date,
                                      time: TimeOfDay(
                                          hour: int.parse(time.split(':')[0]),
                                          minute:
                                              int.parse(time.split(':')[1])),
                                      note: dayWorksTasks[index]['note'],
                                      state: PlannerCubit.get(context)
                                          .states[index],
                                    ),
                                    dayWorksTasks[index]['id'],
                                  ));
                            },
                            checkboxTitleValue:
                                PlannerCubit.get(context).states[index],
                            checkboxOnChangeFunction: (value) {
                              PlannerCubit.get(context).changeState(index);
                              if (PlannerCubit.get(context).states[index] ==
                                  true) {
                                int i = 0;
                                PlannerCubit.get(context)
                                    .subBool[index]
                                    .forEach((value) {
                                  PlannerCubit.get(context).subBool[index][i] =
                                      true;
                                  i++;
                                });
                              }
                              PlannerCubit.get(context).updateTaskData(
                                taskModel: TaskModel(
                                  uId: dayWorksTasks[index]['uId'],
                                  taskTitle: dayWorksTasks[index]['taskTitle'],
                                  subTasks:
                                      PlannerCubit.get(context).subText[index],
                                  subTasksBool:
                                      PlannerCubit.get(context).subBool[index],
                                  date: date,
                                  time: TimeOfDay(
                                      hour: int.parse(time.split(':')[0]),
                                      minute: int.parse(time.split(':')[1])),
                                  note: dayWorksTasks[index]['note'],
                                  state:
                                      PlannerCubit.get(context).states[index],
                                ),
                                id: dayWorksTasks[index]['id'],
                              );
                            },
                            taskTitle: dayWorksTasks[index]['taskTitle'],
                            subTasksLength:
                                PlannerCubit.get(context).subText[index].length,
                            subTasksBooleanValue:
                                PlannerCubit.get(context).subBool[index],
                            subTasksTitles: subTasks,
                            time: TimeOfDay(hour: int.parse(time.split(':')[0]), minute: int.parse(time.split(':')[1])),
                            index: index,
                            date: date,
                            haveNote: dayWorksTasks[index]['note'] != '',
                          );
                        },
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          child: Container(
                            height: 1,
                            color: defaultColor,
                          ),
                        ),
                        itemCount: dayWorksTasks.length,
                      ),
                    ),
                    if(dayWorksNotes.isNotEmpty && dayWorksTasks.isNotEmpty)
                    Container(
                      height: 1,
                      color: defaultColor,
                    ),
                    if(dayWorksNotes.isNotEmpty)
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: defaultColor,
                          ),
                    ),
                    if(dayWorksNotes.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemBuilder: (context, index) {
                          DateTime date =
                              DateTime.parse(dayWorksNotes[index]['date']);
                          String finalDate = DateFormat.yMMMd().format(date);

                          return buildNoteItem(
                            context: context,
                            onTapFunction: () {
                              navigateTo(context,
                                  EditNoteScreen(dayWorksNotes[index]));
                            },
                            noteTitle: dayWorksNotes[index]['description'],
                            showImage:
                                dayWorksNotes[index]['imageUrl'] != 'null',
                            imageUrl: dayWorksNotes[index]['imageUrl'],
                            finalDate: finalDate,
                          );
                        },
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          child: Container(
                            height: 1,
                            color: defaultColor,
                          ),
                        ),
                        itemCount: dayWorksNotes.length,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
