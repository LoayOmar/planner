import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planner/models/task_model.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/network/local/noitification_service.dart';
import 'package:planner/shared/styles/colors.dart';

class EditTaskScreen extends StatelessWidget {
  TextEditingController taskController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController subTaskController = TextEditingController();

  final TaskModel taskModel;
  final int id;

  EditTaskScreen(this.taskModel, this.id);

  int getSeconds(DateTime date, TimeOfDay time) {
    int days = date.difference(DateTime.now()).inDays;
    int hour = 0;
    int minute = 0;
    int second = 0;
    if (days == 0) {
      if (date.day - DateTime.now().day == 0) {
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
    taskController.text = taskModel.taskTitle;
    noteController.text = taskModel.note;
    PlannerCubit.get(context).subTasks = taskModel.subTasks;
    PlannerCubit.get(context).subTasksBool = taskModel.subTasksBool;
    PlannerCubit.get(context).currentTaskDate = taskModel.date;
    PlannerCubit.get(context).currentTaskTime = taskModel.time;

    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: defaultColor,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                taskController.clear();
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Edit Task',
              style: TextStyle(
                fontSize: 25,
                color: backgroundColor,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  if (taskController.text.isNotEmpty) {
                    if (getSeconds(PlannerCubit.get(context).currentTaskDate,
                            PlannerCubit.get(context).currentTaskTime) >
                        0) {
                      PlannerCubit.get(context).updateTaskData(
                        taskModel: TaskModel(
                          uId: PlannerCubit.get(context).userModel!.uId!,
                          taskTitle: taskController.text,
                          subTasks: PlannerCubit.get(context).subTasks,
                          subTasksBool: PlannerCubit.get(context).subTasksBool,
                          date: PlannerCubit.get(context).currentTaskDate,
                          time: PlannerCubit.get(context).currentTaskTime,
                          note: noteController.text,
                          state: taskModel.state,
                        ),
                        id: id,
                      );
                      await NotificationService()
                          .cancelNotification(id, 'task');
                      await NotificationService().showNotification(
                        id,
                        taskController.text,
                        'Don\'t waste time, your task will start soon',
                        getSeconds(PlannerCubit.get(context).currentTaskDate,
                            PlannerCubit.get(context).currentTaskTime),
                        'task',
                      );
                      taskController.clear();
                      noteController.clear();
                      subTaskController.clear();
                      PlannerCubit.get(context).clearTaskData();
                      Navigator.pop(context);
                    } else {
                      showToast(
                          text: 'Please check time', state: ToastStates.ERROR);
                    }
                  } else {
                    showToast(
                        text: 'Please add Task Title',
                        state: ToastStates.ERROR);
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  defaultTextFormField(
                    controller: taskController,
                    type: TextInputType.text,
                    validate: (value) {},
                    label: 'Task',
                    hintText: 'I want to',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  buildTaskDate(
                    context: context,
                    icon: Icons.watch_later_outlined,
                    function: () {
                      showDatePicker(
                        context: context,
                        initialDate: PlannerCubit.get(context).currentTaskDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.parse('2022-05-03'),
                      ).then((value) {
                        PlannerCubit.get(context).changeCurrentTaskDate(value!);
                      });
                    },
                    text: DateFormat.yMMMd()
                        .format(PlannerCubit.get(context).currentTaskDate),
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
                    height: 10,
                  ),
                  buildTaskDate(
                    context: context,
                    icon: Icons.notifications,
                    function: () {
                      showTimePicker(
                        context: context,
                        initialTime: PlannerCubit.get(context).currentTaskTime,
                      ).then((value) {
                        PlannerCubit.get(context).changeCurrentTaskTime(value!);
                      });
                    },
                    text: PlannerCubit.get(context)
                        .currentTaskTime
                        .format(context),
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_comment_outlined,
                          color: defaultColor,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: defaultTextFormField(
                            controller: subTaskController,
                            type: TextInputType.text,
                            validate: (value) {},
                            label: 'New subtask',
                            hintText: 'Add a subtask',
                            onSubmit: (value) {
                              PlannerCubit.get(context)
                                  .addNewSubTask(subTaskController.text);
                              subTaskController.clear();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: SizedBox(
                      height: 46.5 * PlannerCubit.get(context).subTasks.length,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Checkbox(
                                  value: PlannerCubit.get(context)
                                      .subTasksBool[index],
                                  onChanged: (value) {
                                    PlannerCubit.get(context)
                                        .changeSubTaskValue(index);
                                  }),
                              Text(
                                PlannerCubit.get(context).subTasks[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontSize: 16),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    PlannerCubit.get(context)
                                        .deleteSubTask(index);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: defaultColor,
                                  ))
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(),
                        itemCount: PlannerCubit.get(context).subTasks.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: defaultButton(
                      function: () async {
                        PlannerCubit.get(context).deleteTaskData(id: id);
                        await NotificationService()
                            .cancelNotification(id, 'task');
                        taskController.clear();
                        noteController.clear();
                        subTaskController.clear();
                        PlannerCubit.get(context).clearTaskData();
                        Navigator.pop(context);
                      },
                      text: 'Delete',
                      context: context,
                      background: defaultColor,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
