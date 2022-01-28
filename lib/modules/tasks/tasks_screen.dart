import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/modules/inbox_tasks/inbox_tasks_screen.dart';
import 'package:planner/modules/today_tasks/today_tasks_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/styles/colors.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PlannerCubit.get(context);
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              defaultItemPressed(
                context: context,
                iconData: Icons.all_inbox_rounded,
                title: 'Inbox',
                widget: Text(
                  '${cubit.tasks.length}',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                function: () {
                  navigateTo(context, InboxTasksScreen());
                },
              ),
              myDivider(),
              defaultItemPressed(
                context: context,
                iconData: Icons.event,
                title: 'Today',
                  widget: Text(
                    '${cubit.tasksToday.length}',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    ),
                  ),
                function: () {
                  navigateTo(context, TodayTasksScreen());
                },
              ),
              myDivider()
            ],
          ),
        );
      },
    );
  }
}
