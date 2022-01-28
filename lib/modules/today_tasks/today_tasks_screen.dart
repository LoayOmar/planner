import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/models/task_model.dart';
import 'package:planner/modules/edit_task/edit_task_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/styles/colors.dart';

class TodayTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        PlannerCubit.get(context).states = [];
        PlannerCubit.get(context).subText = [];
        PlannerCubit.get(context).subBool = [];
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
              'Today',
              style: TextStyle(
                fontSize: 25,
                color: backgroundColor,
              ),
            ),
          ),
          body: PlannerCubit.get(context).tasksToday.isEmpty
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
                  'No tasks',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              String subTask =
              PlannerCubit.get(context).tasksToday[index]['subTasks'];
              subTask = subTask.replaceAll('[', '');
              subTask = subTask.replaceAll(']', '');
              subTask = subTask.replaceAll(' ', '');

              List<String> subTasks = subTask.split(',');
              if(subTask.isNotEmpty) {
                PlannerCubit.get(context).addSubText(subTasks);
              } else{
                PlannerCubit.get(context).addSubText([]);
              }


              String subTaskBool =
              PlannerCubit.get(context).tasksToday[index]['subTasksBool'];
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

              DateTime date = DateTime.parse(
                  PlannerCubit.get(context).tasksToday[index]['date']);
              String time =
              PlannerCubit.get(context).tasksToday[index]['time'];
              time = time.replaceAll('TimeOfDay(', '');
              time = time.replaceAll(')', '');

              bool state = PlannerCubit.get(context).tasksToday[index]['State'] == 'true'
                  ? true
                  : false;
              PlannerCubit.get(context).addState(state);

              return buildTaskItem(
                context: context,
                onTapFunction: (){
                  navigateTo(context, EditTaskScreen(
                    TaskModel(
                      uId: PlannerCubit.get(context).tasksToday[index]['uId'],
                      taskTitle: PlannerCubit.get(context).tasksToday[index]['taskTitle'],
                      subTasks: PlannerCubit.get(context).subText[index],
                      subTasksBool: PlannerCubit.get(context).subBool[index],
                      date: date,
                      time: TimeOfDay(hour: int.parse(time.split(':')[0]), minute: int.parse(time.split(':')[1])),
                      note: PlannerCubit.get(context).tasksToday[index]['note'],
                      state: PlannerCubit.get(context).states[index],
                    ),
                    PlannerCubit.get(context).tasksToday[index]['id'],
                  ));
                },
                checkboxTitleValue: PlannerCubit.get(context).states[index],
                checkboxOnChangeFunction: (value) {
                  PlannerCubit.get(context).changeState(index);
                  if(PlannerCubit.get(context).states[index] == true){
                    int i = 0;
                    PlannerCubit.get(context).subBool[index].forEach((value){
                      PlannerCubit.get(context).subBool[index][i] = true;
                      i++;
                    });
                  }
                  PlannerCubit.get(context).updateTaskData(
                    taskModel: TaskModel(
                      uId: PlannerCubit.get(context).tasksToday[index]['uId'],
                      taskTitle: PlannerCubit.get(context).tasksToday[index]['taskTitle'],
                      subTasks: PlannerCubit.get(context).subText[index],
                      subTasksBool: PlannerCubit.get(context).subBool[index],
                      date: date,
                      time: TimeOfDay(hour: int.parse(time.split(':')[0]), minute: int.parse(time.split(':')[1])),
                      note: PlannerCubit.get(context).tasksToday[index]['note'],
                      state: PlannerCubit.get(context).states[index],
                    ),
                    id: PlannerCubit.get(context).tasksToday[index]
                    ['id'],
                  );
                },
                taskTitle: PlannerCubit.get(context).tasksToday[index]['taskTitle'],
                subTasksLength: PlannerCubit.get(context).subText[index].length,
                subTasksBooleanValue: PlannerCubit.get(context).subBool[index],
                subTasksTitles: subTasks,
                index: index,
                time: TimeOfDay(hour: int.parse(time.split(':')[0]), minute: int.parse(time.split(':')[1])),
                date: date,
                haveNote: PlannerCubit.get(context).tasksToday[index]['note'] != '',
              );
            },
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Container(
                height: 1,
                color: defaultColor,
              ),
            ),
            itemCount: PlannerCubit.get(context).tasksToday.length,
          ),
        );
      },
    );
  }
}
