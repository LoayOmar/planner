import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planner/modules/edit_note/edit_note_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/styles/colors.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PlannerCubit.get(context);
        return PlannerCubit.get(context).notes.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.note, color: secondaryColor.withOpacity(0.6), size: 50,),
              Text(
                'No notes',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        )
            :  ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            DateTime date = DateTime.parse(cubit.notes[index]['date']);
            String finalDate = DateFormat.yMMMd().format(date);

            return buildNoteItem(
              context: context,
              onTapFunction: (){navigateTo(context, EditNoteScreen(cubit.notes[index]));},
              noteTitle: cubit.notes[index]['description'],
              showImage: cubit.notes[index]['imageUrl'] != 'null',
              imageUrl: cubit.notes[index]['imageUrl'],
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
          itemCount: PlannerCubit.get(context).notes.length,
        );
      },
    );
  }
}
