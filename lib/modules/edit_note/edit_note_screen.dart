import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planner/models/note_model.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/styles/colors.dart';

class EditNoteScreen extends StatelessWidget {
  TextEditingController descriptionController = TextEditingController();

  final Map<dynamic, dynamic> note;

  EditNoteScreen(this.note);

  @override
  Widget build(BuildContext context) {
    descriptionController.text = note['description'];
    PlannerCubit.get(context).initialNewNoteDate =
        DateTime.parse(note['date']);
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
                descriptionController.clear();
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Edit Note',
              style: TextStyle(
                fontSize: 25,
                color: backgroundColor,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  if (descriptionController.text.isNotEmpty) {
                    PlannerCubit.get(context).updateNoteData(
                        noteModel: NoteModel(
                          uId: PlannerCubit.get(context).userModel!.uId,
                          description: descriptionController.text,
                          imageUrl: PlannerCubit.get(context).noteImageUrl ?? note['imageUrl'],
                          date: PlannerCubit.get(context).initialNewNoteDate,
                        ),
                        id: note['id']);
                    PlannerCubit.get(context).noteImageUrl = null;
                    PlannerCubit.get(context).initialNewNoteDate =
                        DateTime.now();
                    descriptionController.clear();
                    Navigator.pop(context);
                  } else {
                    showToast(
                        text: 'Please add description',
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
                    controller: descriptionController,
                    type: TextInputType.text,
                    validate: (value) {},
                    label: 'Description',
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          PlannerCubit.get(context).getNoteImage();
                        },
                        child: Card(
                          elevation: 10,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: secondaryColor.withOpacity(0.6),
                              ),
                            ),
                            child: note['imageUrl'] == 'null' && PlannerCubit.get(context).noteImage == null
                                ? Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 100,
                                      color: secondaryColor.withOpacity(0.6),
                                    ),
                                  )
                                : PlannerCubit.get(context).noteImage != null
                                    ? Image(
                                        image: FileImage(
                                            PlannerCubit.get(context)
                                                .noteImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : Image(
                                        image: PlannerCubit.get(context).noteImageUrl == null
                                            ? NetworkImage(note['imageUrl'])
                                            : NetworkImage(PlannerCubit.get(context).noteImageUrl!),
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (PlannerCubit.get(context).noteImage != null)
                        defaultButton(
                          function: () {
                            PlannerCubit.get(context).uploadNoteImage();
                          },
                          text: 'Save',
                          background: defaultColor,
                          textColor: Colors.white,
                          context: context,
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate:
                            PlannerCubit.get(context).initialNewNoteDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.parse('2022-05-03'),
                      ).then((value) {
                        PlannerCubit.get(context)
                            .changeNewNoteInitialDate(value!);
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          color: secondaryColor,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          DateFormat.yMMMd().format(
                              PlannerCubit.get(context).initialNewNoteDate),
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    color: secondaryColor,
                                    fontSize: 25,
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
                      function: () {
                        PlannerCubit.get(context)
                            .deleteNoteData(id: note['id']);
                        descriptionController.clear();
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
