import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/modules/day_works/day_works_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PlannerCubit.get(context);
        return TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 360)),
        lastDay: DateTime.now().add(const Duration(days: 360)),
        focusedDay: cubit.focusedDay,
        daysOfWeekHeight: 30,
        currentDay: cubit.currentDate,
        shouldFillViewport: true,
        headerVisible: false,
        onDaySelected: (oldDate, selectedDate) {
          //cubit.changeCurrentDate(selectedDate);
          navigateTo(context, DayWorksScreen(selectedDate));
        },
        onPageChanged: (date) {
          cubit.changeFocusedMonth(date);
          cubit.changeFocusedDay(date);
        },
      );
      },
    );
  }
}
