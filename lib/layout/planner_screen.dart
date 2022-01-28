import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:intl/intl.dart';
import 'package:planner/modules/new_event/new_event_screen.dart';
import 'package:planner/modules/new_note/new_note_screen.dart';
import 'package:planner/modules/new_task/new_task_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/styles/colors.dart';

class PlannerScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PlannerCubit.get(context);
        return SafeArea(
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: defaultColor,
              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: backgroundColor,
                  size: 35,
                ),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
              title: Text(
                cubit.pageSelected == 0
                    ? DateFormat.yMMM().format(cubit.focusedMonth)
                    : cubit.titles[cubit.pageSelected],
                style: TextStyle(
                  fontSize: 25,
                  color: backgroundColor,
                ),
              ),
              centerTitle: true,
            ),
            body: cubit.screens[cubit.pageSelected],
            floatingActionButton: cubit.pageSelected == 0
                ? HawkFabMenu(
                    openIcon: Icons.add,
                    closeIcon: Icons.close,
                    body: const SizedBox(),
                    items: [
                      HawkFabMenuItem(
                        label: 'Event',
                        ontap: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          navigateTo(context, NewEventScreen());
                        },
                        icon: const Icon(Icons.event),
                      ),
                      HawkFabMenuItem(
                        label: 'Task',
                        ontap: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          navigateTo(context, NewTaskScreen());
                        },
                        icon: const Icon(Icons.task_outlined),
                      ),
                      HawkFabMenuItem(
                        label: 'Note',
                        ontap: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          navigateTo(context, NewNoteScreen());
                        },
                        icon: const Icon(Icons.note_add_outlined),
                      ),
                    ],
                  )
                : cubit.pageSelected == 1
                    ? FloatingActionButton(
                        onPressed: () {
                          navigateTo(context, NewTaskScreen());
                        },
                        child: const Icon(
                          Icons.add,
                        ),
                      )
                    : cubit.pageSelected == 2
                        ? FloatingActionButton(
                            onPressed: () {
                              navigateTo(context, NewNoteScreen());
                            },
                            child: const Icon(
                              Icons.add,
                            ),
                          )
                        : null,
            drawer: Drawer(
              backgroundColor: backgroundColor,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 10,
                          child: Container(
                            width: 50,
                            height: 50,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            child: Image(
                              image: NetworkImage(cubit.userModel!.image!),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          cubit.userModel!.name!,
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  myDivider(),
                  drawerItem(
                    context: context,
                    function: () {
                      cubit.changePageSelected(0);
                    },
                    color:
                        cubit.pageSelected == 0 ? defaultColor : secondaryColor,
                    title: 'Calendar',
                    iconData: Icons.calendar_today_outlined,
                  ),
                  drawerItem(
                    context: context,
                    function: () {
                      cubit.changePageSelected(1);
                    },
                    color:
                        cubit.pageSelected == 1 ? defaultColor : secondaryColor,
                    title: 'Tasks',
                    iconData: Icons.task,
                  ),
                  drawerItem(
                    context: context,
                    function: () {
                      cubit.changePageSelected(2);
                    },
                    color:
                        cubit.pageSelected == 2 ? defaultColor : secondaryColor,
                    title: 'Notes',
                    iconData: Icons.note,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  myDivider(),
                  drawerItem(
                    context: context,
                    function: () {
                      cubit.changePageSelected(3);
                    },
                    color:
                        cubit.pageSelected == 3 ? defaultColor : secondaryColor,
                    title: 'Settings',
                    iconData: Icons.settings,
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
