import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:planner/models/task_model.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/styles/colors.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

Widget defaultButton({
  double width = double.infinity,
  double elevation = 10,
  Color? background,
  double radius = 10.0,
  double textSize = 16.0,
  required var function,
  required String text,
  Color textColor = Colors.black,
  required BuildContext context,
  LinearGradient? gradient,
  bool buttonEnable = true,
}) =>
    Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          color: background,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 10),
          onPressed: function,
          child: Text(
            '${text}',
            style: Theme
                .of(context)
                .textTheme
                .bodyText1
                ?.copyWith(
              color: textColor,
              fontSize: textSize,
            ),
          ),
        ),
      ),
    );

defaultCircleButton({
  double elevation = 10,
  Color background = Colors.blue,
  required double radius,
  required var function,
  required IconData icon,
  Color iconColor = Colors.black,
  required BuildContext context,
  LinearGradient? gradient,
}) =>
    InkWell(
      onTap: function,
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(radius),
            gradient: gradient,
          ),
          child: Center(
            child: Icon(
              icon,
              size: radius / 2,
              color: iconColor,
            ),
          ),
        ),
      ),
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  var onSubmit,
  var onTap,
  var onChanged,
  var suffixPressed,
  required var validate,
  required String? label,
  String? hintText,
  IconData? prefix,
  bool isClickable = true,
  IconData? suffix,
  bool showUnderLine = true,
}) =>
    TextFormField(
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: showUnderLine
              ? BorderSide(color: defaultColor)
              : BorderSide(color: defaultColor.withOpacity(0)),
        ),
        labelText: label,
        labelStyle: TextStyle(color: defaultColor.withOpacity(0.6)),
        hintText: hintText ?? '',
        prefixIcon: prefix != null
            ? Icon(
          prefix,
        )
            : null,
        suffixIcon: suffix != null
            ? IconButton(
          icon: Icon(
            suffix,
            color: defaultColor,
          ),
          onPressed: suffixPressed,
        )
            : null,
        border: null,
      ),
      onTap: onTap,
      enabled: isClickable,
      validator: validate,
      onChanged: onChanged,
      keyboardType: type,
      controller: controller,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
    );

void showToast({
  required String text,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
      msg: '${text}',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
  }

  return color;
}

Widget defaultTextButton({
  required var function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );

void navigateTo(context, widget) =>
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => widget,
        ));

void navigateAndFinish(context, widget) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
          (route) => false,
    );

Widget myDivider() =>
    Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey[400],
    );

Widget defaultItemPressed({
  required BuildContext context,
  required IconData iconData,
  required String title,
  required Widget widget,
  required var function,
  Color? iconColor,
}) =>
    InkWell(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              iconData,
              color: iconColor ?? secondaryColor,
              size: 28,
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              title,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
            Spacer(),
            widget,
          ],
        ),
      ),
    );

Widget drawerItem({
  required BuildContext context,
  required var function,
  required Color color,
  required String title,
  required IconData iconData,
}) =>
    InkWell(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              iconData,
              color: color,
              size: 28,
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              title,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );

AwesomeDialog myShowDialog({
  required BuildContext context,
  required Widget body,
}) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.NO_HEADER,
    body: body,
  )
    ..show();
}

Widget colorItem({
  required BuildContext context,
  required Color color,
  required String colorName,
  required var function,
}) =>
    InkWell(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: color,
            ),
            const SizedBox(width: 20,),
            Text(
              colorName,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontSize: 20, color: defaultColor),
            ),
          ],
        ),
      ),
    );

Widget buildEventTime({
  required BuildContext context,
  required String date,
  required String time,
  required var dateFunction,
  required var timeFunction,
}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: dateFunction,
          child: Text(
                date,
            style: Theme
                .of(context)
                .textTheme
                .bodyText2
                ?.copyWith(
              color: defaultColor,
              fontSize: 20,
            ),
          ),
        ),
        InkWell(
          onTap: timeFunction,
          child: Text(
            time,
            style: Theme
                .of(context)
                .textTheme
                .bodyText2
                ?.copyWith(
              color: defaultColor,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );

Widget buildTaskDate ({
  required BuildContext context,
  required IconData icon,
  required var function,
  required String text,
}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10),
  child: Row(
    children: [
      Icon(
        icon,
        color: defaultColor,
      ),
      const SizedBox(
        width: 20,
      ),
      InkWell(
        onTap: function,
        child: Text(
          text,
          style: Theme
              .of(context)
              .textTheme
              .bodyText2
              ?.copyWith(
            color: defaultColor,
            fontSize: 20,
          ),
        ),
      ),
    ],
  ),
);

Widget buildTaskItem ({
  required BuildContext context,
  required var onTapFunction,
  required bool checkboxTitleValue,
  required var checkboxOnChangeFunction,
  required String taskTitle,
  required int subTasksLength,
  required List<bool> subTasksBooleanValue,
  required List<String> subTasksTitles,
  required DateTime date,
  required TimeOfDay time,
  required bool haveNote,
  required int index,
}) => InkWell(
  onTap: onTapFunction,
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Checkbox(
          value: checkboxTitleValue,
          onChanged: checkboxOnChangeFunction,
      ),

      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 16),
              ),
              SizedBox(
                height: 46.5 * subTasksLength,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, idx) {
                    PlannerCubit.get(context).changeSubTaskIndex(idx);
                    return Row(
                      children: [
                        Checkbox(
                            value: subTasksBooleanValue[idx],
                            onChanged: (value) {
                              PlannerCubit.get(context).changeSubBool(index, idx);
                              PlannerCubit.get(context).updateTaskData(
                                taskModel: TaskModel(
                                  uId: PlannerCubit.get(context).tasks[index]['uId'],
                                  taskTitle: PlannerCubit.get(context).tasks[index]['taskTitle'],
                                  subTasks: PlannerCubit.get(context).subText[index],
                                  subTasksBool: PlannerCubit.get(context).subBool[index],
                                  date: date,
                                  time: time,
                                  note: PlannerCubit.get(context).tasks[index]['note'],
                                  state: PlannerCubit.get(context).states[index],
                                ),
                                id: PlannerCubit.get(context).tasks[index]
                                ['id'],
                              );
                            },
                        ),
                        Text(
                          subTasksTitles[idx],
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 16),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, idx) => const SizedBox(),
                  itemCount: subTasksLength,
                ),
              ),
            ],
          ),
        ),
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            Text(
              DateFormat.yMMMd().format(date),
            ),
            Row(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 20,
                ),
                if (haveNote)
                  const Icon(
                    Icons.note_alt_outlined,
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
);

Widget buildNoteItem ({
  required BuildContext context,
  required var onTapFunction,
  required String noteTitle,
  required bool showImage,
  required String imageUrl,
  required finalDate,
}) => InkWell(
  onTap: onTapFunction,
  child: Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              noteTitle,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 22),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(showImage)
                  Card(
                    elevation: 10,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: secondaryColor.withOpacity(0.6),
                        ),
                      ),
                      child: Image(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 5,),
                Text(
                  finalDate,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: defaultColor),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);